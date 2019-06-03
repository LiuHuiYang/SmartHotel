//
//  SHLightViewCell.h
//  SmartHotel
//
//  Created by Apple on 2019/6/3.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHLightViewCell : UICollectionViewCell


/**
 灯光设备
 */
@property (strong, nonatomic) SHLight *light;

@end

NS_ASSUME_NONNULL_END
