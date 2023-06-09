/********************************************************************************************************
 * @file     DTColorPickerImageView.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2015/3/19
 *
 * @par     Copyright (c) [2014], Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
 *
 *          Licensed under the Apache License, Version 2.0 (the "License");
 *          you may not use this file except in compliance with the License.
 *          You may obtain a copy of the License at
 *
 *              http://www.apache.org/licenses/LICENSE-2.0
 *
 *          Unless required by applicable law or agreed to in writing, software
 *          distributed under the License is distributed on an "AS IS" BASIS,
 *          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *          See the License for the specific language governing permissions and
 *          limitations under the License.
 *******************************************************************************************************/

#import "DTColorPickerImageView.h"
#import "UIImage+ColorPicker.h"

@interface DTColorPickerImageView()
{
    DTColorPickerHandler _handler;
}

@end

@implementation DTColorPickerImageView

+ (instancetype)colorPickerWithFrame:(CGRect)frame
{
    DTColorPickerImageView *colorPicker = [[DTColorPickerImageView alloc] initWithFrame:frame];
    
    return [colorPicker autorelease];
}

+ (instancetype)colorPickerWithImage:(UIImage *)image
{
    DTColorPickerImageView *colorPicker = [[DTColorPickerImageView alloc] initWithImage:image];
    
    return [colorPicker autorelease];
}

#pragma mark - Instance Methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUserInteractionEnabled:YES];    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    [self setUserInteractionEnabled:YES];
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self == nil) return nil;
    
    [self setUserInteractionEnabled:YES];
    
    return self;
}

- (void)dealloc
{
    if (_handler != nil) {
        Block_release(_handler);
    }
    
    [super dealloc];
}

- (void)handlesDidPickColor:(DTColorPickerHandler)handler
{
    if (_handler != nil) {
        Block_release(_handler);
    }
    
    _handler = Block_copy(handler);
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    [self pickerColorAtPoint:location];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    // Respondes when point in self bounds.
    if (!CGRectContainsPoint(self.bounds, location)) {
        return;
    }
    
    [self pickerColorAtPoint:location];
}

- (void)pickerColorAtPoint:(CGPoint)point
{
    CGPoint convertPoint = [self.image convertPoint:point fromImageView:self];
    
    UIColor *color = [self.image pickColorWithPoint:convertPoint];
    
    if (_handler != nil) {
        _handler(color);
        
        return;
    }
    
    //过滤无效的数据
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    if (red == 0 && green == 0 && blue == 0) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(imageView:didPickColorWithColor:)]) {
        [self.delegate imageView:self didPickColorWithColor:color];
    }
}

@end
