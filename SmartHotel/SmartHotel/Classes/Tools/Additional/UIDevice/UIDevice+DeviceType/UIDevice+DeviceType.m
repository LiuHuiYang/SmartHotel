 

#import "UIDevice+DeviceType.h"

@implementation UIDevice (DeviceType)

/// 3.5屏幕大小
+ (BOOL)is3_5inch {

    return ([UIScreen mainScreen].bounds.size.height == 480.0);
}

/// 4.0屏幕大小
+ (BOOL)is4_0inch {

    return ([UIScreen mainScreen].bounds.size.height == 568.0);
}

/// 4.7 屏幕大小
+ (BOOL)is4_7inch {

    return ([UIScreen mainScreen].bounds.size.height == 667.0);
}

/// 5.5 屏幕大小
+ (BOOL)is5_5inch {

    return ([UIScreen mainScreen].bounds.size.height == 736.0);
}


/**
 当前设备是iPhone
 
 @return YES - iPone
 */
+ (BOOL)is_iPhone {
    
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

/**
 当前设备是iPad
 
 @return YES - iPad
 */
+ (BOOL)is_iPad {
    
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

 
/**
 当前设备是iPhone X

 @return YES - iPhoneX
 */
+ (BOOL)is_iPhoneX {
    
    return CGSizeEqualToSize(([[[UIScreen mainScreen] currentMode] size]), CGSizeMake(1125, 2436));;
}
                              
@end
