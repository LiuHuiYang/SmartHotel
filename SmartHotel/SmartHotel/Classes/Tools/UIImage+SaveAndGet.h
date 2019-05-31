//
//  UIImage+SaveAndGet.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/9.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SaveAndGet)

 
/**
 删除沙盒中的图片
 
 @param group 分组
 @param imageName 图片名称
 @return 图片
 */
+ (BOOL)deleteImaageFromDoucment:(NSString *)group imageName:(NSString *)imageName;

/**
 获得沙盒中的图片
 
 @param group 分组
 @param imageName 图片名称
 @return 图片
 */
+ (UIImage *)getImaageFromDoucment:(NSString *)group imageName:(NSString *)imageName;

/**
 将图片写入沙盒
 
 @param group 分组
 @param imageName 图片名
 @param image 图片
 */
+ (void)writeImageToDocument:(NSString *)group imageName:(NSString *)imageName image:(UIImage *)image;


@end
