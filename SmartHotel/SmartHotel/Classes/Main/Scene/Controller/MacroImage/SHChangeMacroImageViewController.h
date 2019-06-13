//
//  SHChangeMacroImageViewController.h
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHChangeMacroImageViewController : SHViewController


/**
 选择图片的回调
 */
@property (copy, nonatomic) void(^selectImageName)(NSString *iconName);

@end

NS_ASSUME_NONNULL_END
