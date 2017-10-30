//
//  KonoFitreadingView.h
//  KonoViewerKit
//
//  Created by kuokuo on 2017/8/14.
//  Copyright © 2017年 Kono. All rights reserved.
//
#import "KonoViewUtil.h"
#import <KonoContentKit/KonoContentKit.h>
#import <UIKit/UIKit.h>

@protocol KonoFitreadingViewDelegate <NSObject>

- (KCBook *)displayBookItem;

- (void)userDidClickOnContent;

@end


@protocol KonoFitreadingViewDatasource <NSObject>

- (KCBook *)displayBookItem;

@end



@interface KonoFitreadingView : UIWebView <UIWebViewDelegate>

@property (nonatomic, weak) id<KonoFitreadingViewDelegate> actionDelegate;

@property (nonatomic, weak) id<KonoFitreadingViewDatasource> dataSource;

@property (nonatomic) BOOL isUseKonoDefaultLayout;

- (void)renderFitreadingArticleFromData:(NSData*)data withImageRefPath:(NSString*)imagePath requireKey:(BOOL)requireKey;

@end
