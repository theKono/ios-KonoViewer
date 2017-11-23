//
//  KonoFitreadingView.m
//  KonoViewerKit
//
//  Created by kuokuo on 2017/8/14.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KonoFitreadingView.h"

@interface KonoFitreadingView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, strong) KCBook *bookItem;

@end

@implementation KonoFitreadingView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    if( self.tapGestureRecognizer == nil ){
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTap)];
        self.tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:self.tapGestureRecognizer];
    }
    
    self.delegate = self;
    
}

- (id)initWithFrame:(CGRect)frame isUseDefaultLayout:(BOOL)isUseDefault{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray* nibViews = [[KonoViewUtil viewcontrollerBundle] loadNibNamed:@"KonoFitreadingView" owner:self options:nil];
        UIView* mainView = (UIView*)[nibViews objectAtIndex:0];
        
        self = (KonoFitreadingView *)mainView;
    }
    if (isUseDefault) {
        [self loadTemplate];
    }
    
    return self;
}

- (void)setUpActionMenu {
    
    UIMenuItem *customMenuItem1 = [[UIMenuItem alloc] initWithTitle:@"Speak" action:@selector(customAction1:)];
    UIMenuItem *customMenuItem2 = [[UIMenuItem alloc] initWithTitle:@"Quiz" action:@selector(customAction2:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:customMenuItem1, customMenuItem2, nil]];
    
}

- (void)dealloc {
    
    [[UIMenuController sharedMenuController] setMenuItems:nil];
    
}


- (KCBook *)bookItem {
    
    return [self.dataSource displayBookItem];
}

- (void)loadTemplate {
    
    
    NSURL *url = [NSURL fileURLWithPath:[[KonoViewUtil resourceBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"dist"]];
    [self loadRequest:[NSURLRequest requestWithURL:url]];
    
    
}

- (void)renderFitreadingArticleFromData:(NSData*)data withImageRefPath:(NSString*)imagePath requireKey:(BOOL)requireKey{
    
    
    
    NSError* error;
    NSData *parsedData;
    
    if( self.bookItem != nil ){
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:json];
        [dic setObject:self.bookItem.name forKey:@"magTitle"];
        [dic setObject:self.bookItem.issue forKey:@"magIssue"];
        
        parsedData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        
    }
    
    NSString *myString = [[NSString alloc] initWithData:parsedData encoding:NSUTF8StringEncoding];
    
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"setAPIURL('%@')", [KCServerConfig getApiBaseURL]]];
    
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"setDeviceType(%d)", 0 ]];
    
    /* set the second parameter to indicate this is an online article or not */
    /* also set the base_url for images on the third parameter */
    NSString *articleImageRefURL = imagePath!=nil?imagePath:[KCServerConfig getApiBaseURL];
    
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"open_article(%@, %d, '%@')", myString , imagePath==nil , articleImageRefURL ]];
    //[self adjustDefaultFontSize];
    
    //[self loadMagazineInfo];
    
}

- (void)clearSelection {
    
    self.userInteractionEnabled = NO;
    self.userInteractionEnabled = YES;
    
}

# pragma mark - override the UIMenuItem

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (action == @selector(customAction1:)) {
        return YES;
    }
    else if (action == @selector(customAction2:)) {
        return YES;
    }
    
    return NO;
}

# pragma mark - UIMenuItem handler

- (void)customAction1:(id)sender {
    
    if( [self.actionDelegate respondsToSelector:@selector(firstMenuItemAction)]){
        [self.actionDelegate firstMenuItemAction];
    }
    [self clearSelection];
    
}

- (void)customAction2:(id)sender {
    
    if( [self.actionDelegate respondsToSelector:@selector(secondMenuItemAction)]){
        [self.actionDelegate secondMenuItemAction];
    }
    [self clearSelection];
    
}


# pragma mark - user tap action handle related function

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)userDidTap {
    if( [self.actionDelegate respondsToSelector:@selector(userDidClickOnContent)]){
        [self.actionDelegate userDidClickOnContent];
    }
}


# pragma mark - webView operate function

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    /* template finish loading */
    if( [request.URL.scheme isEqualToString:@"konoviewer"] && [request.URL.host isEqualToString:@"template_load_finished"]){
        
        
        
    }
    else if( navigationType == UIWebViewNavigationTypeLinkClicked ){
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
    
}


@end
