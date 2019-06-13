//
//  SHMacroCommandDetailViewController.h
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHMacroCommandDetailViewController : SHViewController

/**
 宏命令
 */
@property (strong, nonatomic) SHMacroCommand *macroCommand;

@end

NS_ASSUME_NONNULL_END
