//
//  KonoViewUtil.h
//  KonoViewerKit
//
//  Created by kuokuo on 2017/10/23.
//  Copyright © 2017年 Kono. All rights reserved.
//
#import <KonoContentKit/KonoContentKit.h>
#import <Foundation/Foundation.h>

@interface ArticleHTMLInfo : NSObject

@property (nonatomic, copy) NSString *htmlString;
@property (nonatomic) NSInteger totalSentenceCount;
@property (nonatomic) NSInteger totalImageCount;

@end


@interface KonoViewUtil : NSObject

+ (NSBundle *)viewcontrollerBundle;

+ (NSBundle *)resourceBundle;

+ (void)loadSampleJson;

+ (ArticleHTMLInfo *)getHTMLTemplateFromArticleDic:(NSDictionary *)articleDic withCSSFilePath:(NSString *)cssFilePath;


@end

