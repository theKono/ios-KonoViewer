//
//  KonoFitreadingView.m
//  KonoViewerKit
//
//  Created by kuokuo on 2017/8/14.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KonoFitreadingView.h"

@implementation KonoFitreadingView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"KonoViewerKitVC" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        
        NSArray* nibViews = [bundle loadNibNamed:@"KonoFitreadingView" owner:self options:nil];
        UIView* mainView = (UIView*)[nibViews objectAtIndex:0];
        
        self = (KonoFitreadingView *)mainView;
    }
    return self;
}

- (void)loadTemplate {
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"dist"]];
    [self loadRequest:[NSURLRequest requestWithURL:url]];

    
    
}

@end
