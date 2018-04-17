//
//  UIImage+SaveAndGet.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/9.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import "UIImage+SaveAndGet.h"



NSString *imageFloderName = @"TVChannelIconFlodeer";


@implementation UIImage (SaveAndGet)
 

/**
 删除沙盒中的图片
 
 @param group 分组
 @param imageName 图片名称
 @return 图片
 */
+ (BOOL )deleteImaageFromDoucment:(NSString *)group imageName:(NSString *)imageName {
    
    // 获得图片文件夹的内容
    NSString *folderPath = [[[FileTools documentPath] stringByAppendingPathComponent:imageFloderName] stringByAppendingPathComponent:group];
    
    // 图片路径
    NSString *imagePath = [folderPath stringByAppendingPathComponent:imageName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
         
        return [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    }
    
    return NO;
}


/**
 获得沙盒中的图片

 @param group 分组
 @param imageName 图片名称
 @return 图片
 */
+ (UIImage *)getImaageFromDoucment:(NSString *)group imageName:(NSString *)imageName {
    
    // 获得图片文件夹的内容
    NSString *folderPath = [[[FileTools documentPath] stringByAppendingPathComponent:imageFloderName] stringByAppendingPathComponent:group];
    
    // 图片路径
    NSString *imagePath = [folderPath stringByAppendingPathComponent:imageName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    }
    
    return nil;
}

/**
 将图片写入沙盒

 @param group 分组
 @param imageName 图片名
 @param image 图片
 */
+ (void)writeImageToDocument:(NSString *)group imageName:(NSString *)imageName image:(UIImage *)image {
    
    // 图片路径: documet/TVChannelIcon/通道类型/ 图片
    // 获得图片文件夹的内容
    NSString *folderPath = [[[FileTools documentPath] stringByAppendingPathComponent:imageFloderName] stringByAppendingPathComponent:group];
    
    // 如果文件夹不存在就创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 图片路径
    NSString *imagePath = [folderPath stringByAppendingPathComponent:imageName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        // 直接写入
        [UIImagePNGRepresentation(image) writeToFile: imagePath  atomically:YES];
        
    } else {
        //  如果有了，先删除
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
        
        [UIImagePNGRepresentation(image) writeToFile: imagePath    atomically:YES];
    }
}

@end
