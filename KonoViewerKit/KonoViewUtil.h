//
//  KonoViewUtil.h
//  KonoViewerKit
//
//  Created by kuokuo on 2017/10/23.
//  Copyright © 2017年 Kono. All rights reserved.
//
#import <KonoContentKit/KonoContentKit.h>
#import <Foundation/Foundation.h>

@interface KonoViewUtil : NSObject

+ (NSBundle *)viewcontrollerBundle;

+ (NSBundle *)resourceBundle;

+ (void)loadSampleJson;

+ (NSString *)getHTMLTemplateFromArticleDic:(NSDictionary *)articleDic withCSSFilePath:(NSString *)cssFilePath;


@end
