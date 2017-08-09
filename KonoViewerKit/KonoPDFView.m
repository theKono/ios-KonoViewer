//
//  KonoPDFView.m
//  KonoViewerKit
//
//  Created by kuokuo on 2017/8/7.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KonoPDFView.h"
#import "KonoPageWebView.h"
#import "KonoFatPageWebView.h"

static int webViewObjMaxCount = 10;

static NSString *contentCellIdentifier = @"contentCellIdentifier";

@interface KonoPDFView () <KonoPageWebViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource>

@property (unsafe_unretained, nonatomic) IBOutlet UICollectionView *viewContainer;

@end

@implementation KonoPDFView {
    
    NSMutableDictionary *webviewDictionary;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    webviewDictionary = [NSMutableDictionary dictionary];
    
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"KonoViewerKitVC" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        
        NSArray* nibViews = [bundle loadNibNamed:@"KonoPDFView" owner:self options:nil];
        UIView* mainView = (UIView*)[nibViews objectAtIndex:0];
        
        self = (KonoPDFView *)mainView;
    }
    return self;
}

- (void)dealloc {
    
    [self clearDelegate];
    [webviewDictionary removeAllObjects];
    NSLog(@"dellocate the Kono PDF view");
    
}


- (void)initViewContainer {
    
    UICollectionViewFlowLayout *colFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    colFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    colFlowLayout.itemSize = CGSizeMake( self.frame.size.width, self.frame.size.height );
    colFlowLayout.minimumLineSpacing = 0;
    colFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    [self.viewContainer setCollectionViewLayout:colFlowLayout];
    [self.viewContainer setPagingEnabled:YES];
    [self.viewContainer setDelegate:self];
    [self.viewContainer setDataSource:self];
    [self.viewContainer setBackgroundColor:[UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0]];
    [self.viewContainer registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:contentCellIdentifier];
    
}

- (void)initLayout {
    
    
}

# pragma mark - webview object resource related function

- (KonoPageWebView *)getResuableWebviewForIndex:(NSInteger)index {
    
    NSInteger serialNum = index % webViewObjMaxCount;
    
    KonoPageWebView *webViewObj = [webviewDictionary objectForKey:[NSString stringWithFormat:@"%d",(int)serialNum]];
    if( nil == webViewObj) {
        
        webViewObj = [self createWebView];
        [webviewDictionary setObject:webViewObj forKey:[NSString stringWithFormat:@"%d",(int)serialNum]];
    }
    
    return webViewObj;
    
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
    
    KonoPageWebView *webview = [[KonoPageWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) configuration:configuration];
    webview.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
    webview.pageDelegate = self;
    webview.scrollView.delegate = self;
    webview.scrollView.bounces = NO;
    
    return webview;
}

- (void)clearDelegate {
    
    [webviewDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [(KonoPageWebView *)obj stopLoading];
        [(KonoPageWebView *)obj loadHTMLString:@"" baseURL:nil];
        ((KonoPageWebView *)obj).scrollView.delegate = nil;
        ((KonoPageWebView *)obj).pageDelegate = nil;
        [(KonoPageWebView *)obj removeFromSuperview];
    }];
}

#pragma mark - collection view data source & delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:contentCellIdentifier forIndexPath:indexPath];
    
    for( UIView *view in cell.contentView.subviews ){
        if( [view isKindOfClass:[KonoPageWebView class]] ){
            
            [view removeFromSuperview];
        }
    }
    KonoPageWebView *webview = [self getResuableWebviewForIndex:indexPath.row];
    [cell.contentView addSubview:webview];
    webview.alpha = 0;
    
    NSString *filePath = [self.dataSource htmlFilePathForItemAtIndex:indexPath.row isPreload:NO];
    if (filePath) {
        [self loadHTMLFileWithWebview:webview withHTMLFileDirPath:filePath];
    }
    else {
        [webview clearContent];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataSource numberOfPages];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self preloadWithCenterIndex:indexPath.row];
}


#pragma mark - content operating related function

- (void)loadHTMLFileWithWebview:(KonoPageWebView *)webview withHTMLFileDirPath:(NSString *)htmlFileDirPath{
    
    NSString *indexFilePath = [htmlFileDirPath stringByAppendingPathComponent:@"index.html"];
    
    if( [indexFilePath isEqualToString:webview.cacheKey] ){
        
        webview.alpha = 1;
        return;
    }
    
    webview.alpha = 0;
    webview.cacheKey = nil;
    
    [webview clearContent];
    
    
    NSURL *url = [NSURL fileURLWithPath:indexFilePath];
    NSString *directory = [indexFilePath stringByDeletingLastPathComponent];
    NSURL *dir_url = [NSURL fileURLWithPath:directory isDirectory:YES];
    
    __weak KonoPageWebView *weakOperator = webview;
    
    [webview loadFileURL:url allowingReadAccessToURL:dir_url withComplete:^{
        weakOperator.isReadyToShow = YES;
        weakOperator.alpha = 1;
        weakOperator.cacheKey = indexFilePath;
        
    } withFail:^(NSError *error) {
        NSLog(@"fail :%@" , error );
    }];
    
}

- (void)preloadWithCenterIndex:(NSInteger)index {
    
    NSInteger leftIndex = MAX( 0, index-1 );
    NSInteger rightIndex = MIN( [self.dataSource numberOfPages] - 1, index+1 );
    
    KonoPageWebView *leftWebview = [self getResuableWebviewForIndex:leftIndex];
    NSString *leftFilePath = [self.dataSource htmlFilePathForItemAtIndex:leftIndex isPreload:YES];
    if (leftFilePath) {
        [self loadHTMLFileWithWebview:leftWebview withHTMLFileDirPath:leftFilePath];
    }
    
    KonoPageWebView *rightWebview = [self getResuableWebviewForIndex:rightIndex];
    NSString *rightFilePath = [self.dataSource htmlFilePathForItemAtIndex:rightIndex isPreload:YES];
    if (rightFilePath) {
        [self loadHTMLFileWithWebview:rightWebview withHTMLFileDirPath:rightFilePath];
    }
    
}

- (void)reloadPageIndex:(NSInteger)index withFilePath:(NSString *)htmlFilePath; {
    
    KonoPageWebView *webview = [self getResuableWebviewForIndex:index];
    [self loadHTMLFileWithWebview:webview withHTMLFileDirPath:htmlFilePath];
    
}

#pragma mark - webview touch related delegate function

- (void)userDidSingleTapOnView:(KonoPageWebView*)view {
    NSLog(@"single tap on view");
}

- (void)userStartOperationOnView {
    NSLog(@"user touch the webview");
}

- (void)userDoneOperationOnView {
    NSLog(@"the webivew action is done");
    
}

- (void)userClickInViewWithURL:(NSURL *)url {
    NSLog(@"user click the URL inside webview");
}


@end
