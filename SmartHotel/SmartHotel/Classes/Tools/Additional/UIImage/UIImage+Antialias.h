 

#import <UIKit/UIKit.h>

@interface UIImage (Antialias)


/**
 生成一张指定颜色高度为1的线条
 
 @param color 指定颜色
 @return 线条
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 返回一张抗锯齿图片 在图片生成一个透明为1的像素边框

 @return UIImage *
 */
- (UIImage *)imageAntialias;

@end
