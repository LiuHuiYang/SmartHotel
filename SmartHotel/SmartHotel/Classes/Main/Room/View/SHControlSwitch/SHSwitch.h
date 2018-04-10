//
//  SHSwitch.h
//  SmartHotel
//
//  Created by Mac on 2018/4/10.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHSwitchChangeHandler)(BOOL on);



@interface SHSwitch :  UIControl

@property (nonatomic, strong) UIImage *trackImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *overlayImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *thumbImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *thumbHighlightImage UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIImage *trackMaskImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *thumbMaskImage UI_APPEARANCE_SELECTOR;

/**
 If the thumb image has a shadow you will need to add an inset to make it sit flush when fully on or off.
 */
@property (nonatomic, assign) CGFloat thumbInsetX UI_APPEARANCE_SELECTOR;

/**
 Adjust the vertical positioning of the thumb
 */
@property (nonatomic, assign) CGFloat thumbOffsetY UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign, getter=isOn) BOOL on;

/**
 When the switch value is changed this block will be called.
 */
@property (nonatomic, copy) SHSwitchChangeHandler changeHandler;

/**
 A Boolean value that determines the off/on state of the switch.
 @param on the off/on state
 @param animated When changing the state of the switch should the switch animate to its new state
 */
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
