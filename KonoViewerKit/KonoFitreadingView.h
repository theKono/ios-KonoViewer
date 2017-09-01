//
//  KonoFitreadingView.h
//  KonoViewerKit
//
//  Created by kuokuo on 2017/8/14.
//  Copyright © 2017年 Kono. All rights reserved.
//
#import <KonoContentKit/KonoContentKit.h>
#import <UIKit/UIKit.h>

@protocol KonoFitreadingViewDelegate <NSObject>

- (void)userDidClickOnContent;

@optional

@end



@interface KonoFitreadingView : UIWebView <UIWebViewDelegate>

@property (nonatomic, weak) id<KonoFitreadingViewDelegate> actionDelegate;

@property (nonatomic, strong) KCBook *bookItem;

@property (nonatomic, strong) KCBookArticle *articleItem;


- (void)renderFitreadingArticleFromData:(NSData*)data withImageRefPath:(NSString*)imagePath requireKey:(BOOL)requireKey;

@end
