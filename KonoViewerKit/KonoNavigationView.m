//
//  KonoNavigationView.m
//  KonoViewerKit
//
//  Created by kuokuo on 2017/9/1.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KonoNavigationView.h"

@implementation KonoNavigationView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"KonoViewerKitVC" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        
        NSArray* nibViews = [bundle loadNibNamed:@"KonoPDFView" owner:self options:nil];
        UIView* mainView = (UIView*)[nibViews objectAtIndex:0];
        
        self = (KonoNavigationView *)mainView;
    }
    return self;
}
@end
