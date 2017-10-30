//
//  KonoNavigationView.m
//  KonoViewerKit
//
//  Created by kuokuo on 2017/9/1.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KonoNavigationView.h"

static int HEIGHT = 49;

@implementation KonoNavigationView

+ (KonoNavigationView *)defatulView {
    
    KonoNavigationView *navigationBar = [[self alloc] initWithFrame:CGRectMake( 0, -HEIGHT, [[UIScreen mainScreen]bounds].size.width, HEIGHT)];
    
    return navigationBar;
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray* nibViews = [[KonoViewUtil viewcontrollerBundle] loadNibNamed:@"KonoNavigationView" owner:self options:nil];
        UIView* mainView = (UIView*)[nibViews objectAtIndex:0];
        
        self = (KonoNavigationView *)mainView;
        self.frame = frame;
    }
    return self;
}

- (void)show {
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    }];
    self.isDisplay = YES;
    
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -1 * self.frame.size.height;
        self.frame = frame;
    }];
    self.isDisplay = NO;
    
}
- (IBAction)backBtnPressed:(id)sender {
    
    if( [self.delegate respondsToSelector:@selector(backBtnPressed)]){
        [self.delegate backBtnPressed];
    }
    
    
}

@end
