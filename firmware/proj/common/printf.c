/********************************************************************************************************
 * @file     printf.c 
 *
 * @brief    for TLSR chips
 *
 * @author	 telink
 *
 * @par      Copyright (c) Telink Semiconductor (Shanghai) Co., Ltd.
 *           All rights reserved.
 *           
 *			 The information contained herein is confidential and proprietary property of Telink 
 * 		     Semiconductor (Shanghai) Co., Ltd. and is available under the terms 
 *			 of Commercial License Agreement between Telink Semiconductor (Shanghai) 
 *			 Co., Ltd. and the licensee in separate contract or the terms described here-in. 
 *           This heading MUST NOT be removed from this file.
 *
 * 			 Licensees are granted free, non-transferable use of the information in this 
 *			 file under Mutual Non-Disclosure Agreement. NO WARRENTY of ANY KIND is provided. 
 *           
 *******************************************************************************************************/
#include <stdarg.h>
#include "../../proj/tl_common.h"  


#if(PRINT_DEBUG_INFO)

#define			DECIMAL_OUTPUT		10
#define			OCTAL_OUTPUT		8
#define			HEX_OUTPUT			16


//#define va_start(ap,v)    (ap = (char *)((int)&v + sizeof(v)))
//#define va_arg(ap,t)      ((t *)(ap += sizeof(t)))[-1]

#ifndef		BIT_INTERVAL
#define		BIT_INTERVAL	(CLOCK_SYS_CLOCK_1S/PRINT_BAUD_RATE)
#endif

_attribute_no_retention_bss_ static int tx_pin_initialed = 0;

/**
 * @brief  DEBUG_INFO_TX_PIN initialize. Enable 1M pull-up resistor,
 *   set pin as gpio, enable gpio output, disable gpio input.
 * @param  None
 * @retval None
 */
_attribute_no_inline_ void debug_info_tx_pin_init()
{
    gpio_set_func(DEBUG_INFO_TX_PIN, AS_GPIO);
	gpio_write(DEBUG_INFO_TX_PIN, 1);
    gpio_set_output_en(DEBUG_INFO_TX_PIN, 1);
    gpio_set_input_en(DEBUG_INFO_TX_PIN, 0);
}

/* Put it into a function independently, to prevent the compiler from 
 * optimizing different pins, resulting in inaccurate baud rates.
 */
_attribute_ram_code_ 
_attribute_no_inline_ 
static void uart_do_put_char(u32 pcTxReg, u8 *bit)
{
	int j;
#if PRINT_BAUD_RATE == 1000000
	/*! Make sure the following loop instruction starts at 4-byte alignment */
	// _ASM_NOP_; 
	
	for(j = 0;j<10;j++) 
	{
	#if CLOCK_SYS_CLOCK_HZ == 16000000
		CLOCK_DLY_8_CYC;
	#elif CLOCK_SYS_CLOCK_HZ == 32000000
		CLOCK_DLY_7_CYC;CLOCK_DLY_7_CYC;CLOCK_DLY_10_CYC;
	#elif CLOCK_SYS_CLOCK_HZ == 48000000
		CLOCK_DLY_8_CYC;CLOCK_DLY_8_CYC;CLOCK_DLY_10_CYC;
		CLOCK_DLY_8_CYC;CLOCK_DLY_6_CYC;
	#else
	#error "error CLOCK_SYS_CLOCK_HZ"
	#endif
		write_reg8(pcTxReg, bit[j]); 	   //send bit0
	}
#else
	u32 t1 = 0, t2 = 0;
	t1 = read_reg32(0x740);
	for(j = 0;j<10;j++)
	{
		t2 = t1;
		while(t1 - t2 < BIT_INTERVAL){
			t1	= read_reg32(0x740);
		}
		write_reg8(pcTxReg,bit[j]); 	   //send bit0
	}
#endif
}



_attribute_ram_code_ static void uart_put_char(u8 byte){
	if (!tx_pin_initialed) {
	    debug_info_tx_pin_init();
		tx_pin_initialed = 1;
	}

	u32 pcTxReg = (0x583+((DEBUG_INFO_TX_PIN>>8)<<3));//register GPIO output
	u8 tmp_bit0 = read_reg8(pcTxReg) & (~(DEBUG_INFO_TX_PIN & 0xff));
	u8 tmp_bit1 = read_reg8(pcTxReg) | (DEBUG_INFO_TX_PIN & 0xff);


	u8 bit[10] = {0};
	bit[0] = tmp_bit0;
	bit[1] = (byte & 0x01)? tmp_bit1 : tmp_bit0;
	bit[2] = ((byte>>1) & 0x01)? tmp_bit1 : tmp_bit0;
	bit[3] = ((byte>>2) & 0x01)? tmp_bit1 : tmp_bit0;
	bit[4] = ((byte>>3) & 0x01)? tmp_bit1 : tmp_bit0;
	bit[5] = ((byte>>4) & 0x01)? tmp_bit1 : tmp_bit0;
	bit[6] = ((byte>>5) & 0x01)? tmp_bit1 : tmp_bit0;
	bit[7] = ((byte>>6) & 0x01)? tmp_bit1 : tmp_bit0;
	bit[8] = ((byte>>7) & 0x01)? tmp_bit1 : tmp_bit0;
	bit[9] = tmp_bit1;

	
	/*! Minimize the time for interrupts to close and ensure timely 
	    response after interrupts occur. */
#if SIMU_UART_IRQ_EN
	u8 r = irq_disable();
#endif
	uart_do_put_char(pcTxReg, bit);
#if SIMU_UART_IRQ_EN
	irq_restore(r);
#endif
}

_PRINT_FUN_RAMCODE_ static void printchar(int c) {
	(void) uart_put_char(c);
}

#define PAD_RIGHT 1
#define PAD_ZERO 2

_PRINT_FUN_RAMCODE_ static int prints(const char *string, int width, int pad) {
	register int pc = 0, padchar = ' ';

	if (width > 0) {
		register int len = 0;
		register const char *ptr;
		for (ptr = string; *ptr; ++ptr)
			++len;
		if (len >= width)
			width = 0;
		else
			width -= len;
		if (pad & PAD_ZERO)
			padchar = '0';
	}
	if (!(pad & PAD_RIGHT)) {
		for (; width > 0; --width) {
			printchar(padchar);
			++pc;
		}
	}
	for (; *string; ++string) {
		printchar(*string);
		++pc;
	}
	for (; width > 0; --width) {
		printchar(padchar);
		++pc;
	}

	return pc;
}

/* the following should be enough for 32 bit int */
#define PRINT_BUF_LEN 12

_PRINT_FUN_RAMCODE_ static int printi(int i, int b, int sg, int width, int pad, int letbase) {
	char print_buf[PRINT_BUF_LEN];
	register char *s;
	register int t, neg = 0, pc = 0;
	register unsigned int u = i;

	if (i == 0) {
		print_buf[0] = '0';
		print_buf[1] = '\0';
		return prints(print_buf, width, pad);
	}

	if (sg && b == 10 && i < 0) {
		neg = 1;
		u = -i;
	}

	s = print_buf + PRINT_BUF_LEN - 1;
	*s = '\0';

	while (u) {
		t = u % b;
		if (t >= 10)
			t += letbase - '0' - 10;
		*--s = t + '0';
		u /= b;
	}

	if (neg) {
		if (width && (pad & PAD_ZERO)) {
			printchar('-');
			++pc;
			--width;
		} else {
			*--s = '-';
		}
	}

	return pc + prints(s, width, pad);
}

_PRINT_FUN_RAMCODE_ int mini_printf(const char *format, ...) {
	register int width, pad;
	register int pc = 0;
	char scr[2];
	va_list args;
	va_start(args, format);
	
	for (; *format != 0; ++format) {
		if(pc> 512-2){
			return pc;
		}
		if (*format == '%') {
			++format;
			width = pad = 0;
			if (*format == '\0')
				break;
			if (*format == '%')
				goto out;
			if (*format == '-') {
				++format;
				pad = PAD_RIGHT;
			}
			while (*format == '0') {
				++format;
				pad |= PAD_ZERO;
			}
			for (; *format >= '0' && *format <= '9'; ++format) {
				width *= 10;
				width += *format - '0';
			}
			if (*format == 's') {
				register char *s = (char *) va_arg( args, int );
				pc += prints(s ? s : "(null)", width, pad);
				continue;
			}
			if (*format == 'd') {
				pc += printi(va_arg( args, int ), 10, 1, width, pad, 'a');
				continue;
			}
			if (*format == 'x') {
				pc += printi(va_arg( args, int ), 16, 0, width, pad, 'a');
				continue;
			}
			if (*format == 'X') {
				pc += printi(va_arg( args, int ), 16, 0, width, pad, 'A');
				continue;
			}
			if (*format == 'u') {
				pc += printi(va_arg( args, int ), 10, 0, width, pad, 'a');
				continue;
			}
			if (*format == 'c') {
				/* char are converted to int then pushed on the stack */
				scr[0] = (char) va_arg( args, int );
				scr[1] = '\0';
				pc += prints(scr, width, pad);
				continue;
			}
		} else {
			out: printchar( *format);
			++pc;
		}
	}

	va_end( args );
	return pc;
	
}

u8 HexTable[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
void PrintHex(u8 x)
{
	uart_put_char('0');
	uart_put_char('x');
	uart_put_char(HexTable[x>>4]);
	uart_put_char(HexTable[x&0xf]);
	uart_put_char(' ');
}

#if (PRINT_DEBUG_INFO)

void printfserial(char *str, u8 *p, int len)
{
//	u8 r = irq_disable();
	printf("\n");
	printf("%s:",str);
	for(int i=0;i<len;i++)
	{
		//printf("%x",*p++);
	}
	foreach(i,len){PrintHex(p[i]);}
	
	printf("\n");
//	irq_restore(r);
}

////////////////////////////////////// Test printf///////////////////////////////
void Test_printf(void)
{
	#if 1
		static u32 indicate_tick=0;
		static u32 tick_loop;
		if(clock_time_exceed(indicate_tick, 1000000))
		{
			tick_loop ++;
			
			indicate_tick=clock_time();
			#if (PRINT_DEBUG_INFO)
			//printf("indicate_tick=%x\n",tick_loop);
			#endif
			printfserial("indicate_tick",(u8 *)&indicate_tick,4);
		}
	#endif	
}	
///////////////////////////////////////////////////////////////////////////



#endif



#endif

