

#import <UIKit/UIKit.h>

@interface UIDevice (DeviceType)

// MARK: - 屏幕大小

/// 3.5屏幕大小
+ (BOOL)is3_5inch;

/// 4.0屏幕大小
+ (BOOL)is4_0inch;

/// 4.7 屏幕大小
+ (BOOL)is4_7inch;

/// 5.5 屏幕大小
+ (BOOL)is5_5inch;


// MARK: - 设备类型

/**
 当前设备是iPhone
 
 @return YES - iPone
 */
+ (BOOL)is_iPhone;

/**
 当前设备是iPad

 @return YES - iPad
 */
+ (BOOL)is_iPad;

/**
 当前设备是iPhone X
 
 @return YES - iPhoneX
 */
+ (BOOL)is_iPhoneX;

@end
