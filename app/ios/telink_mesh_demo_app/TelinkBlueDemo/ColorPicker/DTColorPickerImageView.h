/********************************************************************************************************
 * @file     DTColorPickerImageView.h 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2015/3/19
 *
 * @par     Copyright (c) [2017], Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
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

#import <UIKit/UIKit.h>

typedef void(^DTColorPickerHandler)(UIColor *__nonnull color);

@protocol DTColorPickerImageViewDelegate;

NS_ASSUME_NONNULL_BEGIN
@interface DTColorPickerImageView : UIImageView

@property (assign, nullable) IBOutlet id<DTColorPickerImageViewDelegate> delegate;

+ (instancetype)colorPickerWithFrame:(CGRect)frame;
+ (instancetype)colorPickerWithImage:(nullable UIImage *)image;

// When handler and delegate not nil, will handler respondes first.
- (void)handlesDidPickColor:(DTColorPickerHandler)handler;

@end

@protocol DTColorPickerImageViewDelegate <NSObject>

@optional
- (void)imageView:(DTColorPickerImageView *)imageView didPickColorWithColor:(UIColor *)color;

@end
NS_ASSUME_NONNULL_END
