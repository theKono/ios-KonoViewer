//
//  KonoPDFViewController.m
//  KonoViewerKit
//
//  Created by kuokuo on 2017/7/24.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KonoPDFViewController.h"
#import "KonoPageWebView.h"
#import "KonoFatPageWebView.h"


static NSString *contentCellIdentifier = @"contentCellIdentifier";

@interface KonoPDFViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (unsafe_unretained, nonatomic) IBOutlet UICollectionView *viewContainer;

@end

@implementation KonoPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLayoutSubviews {
    
    [self initViewContainer];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init function

- (void)initViewContainer {
    
    UICollectionViewFlowLayout *colFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    colFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    colFlowLayout.itemSize = CGSizeMake( self.view.frame.size.width, self.view.frame.size.height );
    colFlowLayout.minimumLineSpacing = 0;
    
    [self.viewContainer setCollectionViewLayout:colFlowLayout];
    [self.viewContainer setPagingEnabled:YES];
    [self.viewContainer setDelegate:self];
    [self.viewContainer setDataSource:self];
    [self.viewContainer setBackgroundColor:[UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0]];
    [self.viewContainer registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:contentCellIdentifier];
    
    
}

- (KonoPageWebView *)createWebView{
    
    // Disable the long press copy menu bar
    NSString *source = @"var style = document.createElement('style'); \
    style.type = 'text/css'; \
    style.innerText = '*:not(input):not(textarea) { -webkit-user-select: none; -webkit-touch-callout: none; }'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(style);";
    WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    
    // Create the user content controller and add the script to it
    WKUserContentController *userContentController = [WKUserContentController new];
    [userContentController addUserScript:script];
    
    // Create the configuration with the user content controller
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    configuration.userContentController = userContentController;
    
    KonoPageWebView *webview = [[KonoPageWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:configuration];
    webview.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
    //webview.pageDelegate = self;
    webview.scrollView.delegate = self;
    webview.scrollView.bounces = NO;
    
    return webview;
}



#pragma mark - collection view data source & delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:contentCellIdentifier forIndexPath:indexPath];
    
    for( UIView *view in cell.contentView.subviews ){
        if( [view isKindOfClass:[KonoPageWebView class]] || [view isKindOfClass:[KonoFatPageWebView class]]){
            [view removeFromSuperview];
        }
    }
    KonoPageWebView *webview = [self createWebView];
    [cell.contentView addSubview:webview];
    webview.alpha = 0;
    
    KCBookPage *firstPage = [self.book.pageMappingArray objectAtIndex:0];
    NSString *filePath = [firstPage.htmlFilePath stringByAppendingPathComponent:@"index.html"];
    [self loadHTMLFileWithWebview:webview withHTMLFilePath:filePath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.book.pageMappingArray count];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - content operating related function

- (void)loadHTMLFileWithWebview:(KonoPageWebView *)webview withHTMLFilePath:(NSString *)mergeFilePath{
    
    if( [mergeFilePath isEqualToString:webview.cacheKey] ){
        
        webview.alpha = 1;
        return;
    }
    
    
    webview.alpha = 0;
    webview.cacheKey = nil;
    
    [webview stopLoading];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    
    NSURL *url = [NSURL fileURLWithPath:mergeFilePath];
    NSString *directory = [mergeFilePath stringByDeletingLastPathComponent];
    NSURL *dir_url = [NSURL fileURLWithPath:directory isDirectory:YES];
    
    __weak KonoPageWebView *weakOperator = webview;
    
    [webview loadFileURL:url allowingReadAccessToURL:dir_url withComplete:^{
        weakOperator.isReadyToShow = YES;
        weakOperator.alpha = 1;
        weakOperator.cacheKey = mergeFilePath;
        
    } withFail:^(NSError *error) {
        NSLog(@"fail :%@" , error );
    }];
    
}

@end
