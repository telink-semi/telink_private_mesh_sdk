/********************************************************************************************************
 * @file     LoadView.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2016/7/27
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

#import "LoadView.h"

#define ANGLE 10
#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)

@interface LoadView (){
    UIImageView *_imageView;
    int _angle;
}

@end

@implementation LoadView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    //    _angle = 10;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _imageView.image = [UIImage imageNamed:@"L_0000_1"];
    
    [self addSubview:_imageView];
}

- (void)setImage:(NSString *)imageString{
    _imageView.image = [UIImage imageNamed:imageString];
}

- (void)startLoading{
    NSMutableArray *muarr = [[NSMutableArray alloc] init];
    for(int i = 12;i>=1;i--)
    {
        NSString *name = [NSString stringWithFormat:@"L_0000_%d",i];
        NSLog(@"=========%@",name);
        UIImage *image = [UIImage imageNamed:name];
        [muarr addObject:image];
    }
    
    _imageView.animationImages = muarr;
    _imageView.animationDuration = 0.8;
    _imageView.animationRepeatCount = 0;
    [_imageView startAnimating];
}

- (void)stopLoading{
    [_imageView stopAnimating];
}

-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    _imageView.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void)endAnimation
{
    _angle += 20;
    [self startAnimation];
}

//- (void)startAnimation
//{
//    int tem = _angle % 360;
//    NSLog(@"===============%d",tem);
//    CGAffineTransform endAngle = CGAffineTransformMakeRotation(tem * (M_PI / 180.0f));
//    [UIView animateWithDuration:0.1 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
//        _imageView.transform = endAngle;
//    } completion:^(BOOL finished) {
//        _angle += 20;
//        [self startAnimation];
//    }];
//    //旋转动画。
////    [_imageView.layer addAnimation:[self rotation:MAXFLOAT degree:kRadianToDegrees(360) direction:1 repeatCount:MAXFLOAT] forKey:nil];
//}

//#pragma mark ====旋转动画======
//-(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
//{
//    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
//    animation.duration  =  dur;
//    animation.autoreverses = YES;
//    animation.cumulative = NO;
//    animation.fillMode = kCAFillModeForwards;
//    animation.repeatCount = repeatCount;
//    animation.delegate = self;
//
//    return animation;
//
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
