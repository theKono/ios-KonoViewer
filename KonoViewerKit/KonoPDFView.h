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

- (NSString*)htmlFilePathForItemAtIndex:(NSInteger)index isPreload:(BOOL)isPreload;

- (NSInteger)numberOfPages;

@end



@protocol KonoPDFViewDelegate <NSObject>

@optional


@end



@interface KonoPDFView : UIView

@property (nonatomic, weak) id<KonoPDFViewDatasource> dataSource;

@property (nonatomic, weak) id<KonoPDFViewDelegate> delegate;

- (void)initViewContainer;

- (void)reloadPageIndex:(NSInteger)index withFilePath:(NSString *)htmlFilePath;

@end
