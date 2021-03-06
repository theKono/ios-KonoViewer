//
//  KEPageWebView.h
//  Kono
//
//  Created by Neo on 12/24/14.
//  Copyright (c) 2014 Kono. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class KonoPageWebView;

@protocol KonoPageWebViewDelegate <NSObject>

@optional
- (void)userDidSingleTapOnView:(KonoPageWebView*)view;

- (void)userStartOperationOnView;

- (void)userDoneOperationOnView;

- (void)userClickInViewWithURL:(NSURL *)url;


@end


@interface KonoPageWebView : WKWebView<WKNavigationDelegate, WKUIDelegate, UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic) NSInteger serialIdx;
@property (nonatomic) BOOL isReadyToShow;

@property (nonatomic, weak) id<KonoPageWebViewDelegate> pageDelegate;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;

@property (nonatomic) BOOL isNeedToResize;

@property (nonatomic, strong) UIView *touchPad;

@property (nonatomic, strong) NSString *cacheKey;

@property (nonatomic, copy) void (^loadCompletionBlock)(void);
@property (nonatomic, copy) void (^loadFailBlock)(NSError* error);


- (WKNavigation *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL withComplete:(void (^)(void))completeBlock withFail:(void (^)(NSError *))failBlock;

- (void)setContentFitScreenSize;

- (void)clearContent;

@end
