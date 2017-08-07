//
//  KonoPDFView.h
//  KonoViewerKit
//
//  Created by kuokuo on 2017/8/7.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import <KonoContentKit/KonoContentKit.h>
#import <UIKit/UIKit.h>

@protocol KonoPDFViewDatasource <NSObject>

- (void)requireArticleKey:(void (^)(void))completeBlock withFail:(void(^)(NSUInteger statusCode))failBlock;

- (NSString*)thumbnailURLAtIndex:(NSInteger)index;

- (NSString*)htmlFilePathForItemAtIndex:(NSInteger)index isPreload:(BOOL)isPreload;

- (NSInteger)numberOfitems;

@optional
- (CGFloat)downloadPercentageForItemAtIndex:(NSInteger)index;

@end



@protocol KonoPDFViewDelegate <NSObject>

@optional

- (void)userStartOperationOnView;

- (void)userDoneOperationOnView;

- (void)articleViewStartMoving;

- (void)updateDisplayPage:(NSInteger)currentIdx;

- (void)willDisplayPage:(NSInteger)currentIdx;

- (void)purchaseBtnPressed;

- (void)referralBtnPressed;

- (void)registerBtnPressed;

@end



@interface KonoPDFView : UIView 

@property (nonatomic, weak) id<KonoPDFViewDatasource> dataSource;

@property (nonatomic, weak) id<KonoPDFViewDelegate> delegate;

@property (nonatomic, strong) KCBook *book;

- (void)initViewContainer;

@end
