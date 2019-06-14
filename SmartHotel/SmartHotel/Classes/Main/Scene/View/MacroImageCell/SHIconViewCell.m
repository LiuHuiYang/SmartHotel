//
//  SHIconViewCell.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHIconViewCell.h"

@interface SHIconViewCell ()


/**
 图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;


@end

@implementation SHIconViewCell

- (void)setIconName:(NSString *)iconName {
    
    _iconName = iconName.copy;
    
    UIImage *image = [UIImage imageNamed:iconName];
    
    if (image) {
        
        self.iconView.image = image;
    
    } else {
    
        printLog(@"从数据库中查询");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.backgroundColor = UIColor.clearColor;

}

@end
