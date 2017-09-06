//
//  KonoNavigationView.h
//  KonoViewerKit
//
//  Created by kuokuo on 2017/9/1.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KonoNavigationViewDelegate <NSObject>

- (void)backBtnPressed;

@end

@interface KonoNavigationView : UIView

@property (nonatomic) BOOL isDisplay;
@property (nonatomic, weak) id<KonoNavigationViewDelegate> delegate;

+ (KonoNavigationView *)defatulView;

- (void)show;
- (void)hide;

@end
