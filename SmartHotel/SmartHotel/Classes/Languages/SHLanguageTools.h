//
//  SHLanguageTools.h
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHLanguageTools : NSObject

/// 当前使用的语言文件字典
@property (nonatomic, strong) NSMutableDictionary* currentLanguagePlistDictionary;

/// 获得具体的字段名称(可能是字段)
- (id )getTextFromPlist:(NSString *)mainTitle withSubTitle:(NSString *)subTitle;

/// 设置应用使用的语言
- (void)setLanguage;

/// 获得所有的语言名称
- (NSArray *)getAllLanguages;

/// 拷贝语言文件
- (void)copyLanguagePlist;

SingletonInterface(SHLanguageTools);

@end
