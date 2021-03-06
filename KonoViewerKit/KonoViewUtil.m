//
//  KonoViewUtil.m
//  KonoViewerKit
//
//  Created by kuokuo on 2017/10/23.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KonoViewUtil.h"

@implementation KonoViewUtil

+ (NSBundle *)viewcontrollerBundle {
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"KonoViewerKitVC" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    return bundle;
    
}

+ (NSBundle *)resourceBundle {
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"KonoViewerKit" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    return bundle;
    
}


+ (void)loadSampleJson {
    
    NSString *templateFileName = [[self resourceBundle] pathForResource:@"article_sample"
                                                                 ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:templateFileName];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSString *cssFilePath = [[self resourceBundle] pathForResource:@"article_sample"
                                                          ofType:@"css"];
    
    
    [self getHTMLTemplateFromArticleDic:json withCSSFilePath:cssFilePath];
}

+ (NSString *)getHTMLTemplateFromArticleDic:(NSDictionary *)articleDic withCSSFilePath:(NSString *)cssFilePath{
    
    NSString *htmlString;
    NSString *customizeCSS;
    NSString *articleHeader = [self renderHeader:articleDic];
    NSArray *sectionArray = [articleDic objectForKey:@"sections"];
    NSString *articleContent = [self renderSections:sectionArray];
    
    if (cssFilePath) {
        customizeCSS = [NSString stringWithContentsOfFile:cssFilePath encoding:NSUTF8StringEncoding error:nil];
    }
    else {
        NSString *defaultCSSFilePath = [[self resourceBundle] pathForResource:@"article_sample"
                                                                               ofType:@"css"];
        customizeCSS = [NSString stringWithContentsOfFile:defaultCSSFilePath encoding:NSUTF8StringEncoding error:nil];
    }
    
    htmlString = [NSString stringWithFormat:@"<!DOCTYPE html><head><meta charset=\"utf-8\"><meta content=\"\" name=\"description\"><meta content=\"width=device-width\" name=\"viewport\"><style>%@</style></head><body><div class=\"container\" id=\"template-body\">%@ %@</div></body><script  src=\"jquery.js\"></script><script  src=\"main.js\"></script></html>",customizeCSS,articleHeader,articleContent] ;
    
    NSLog(@"HTML result\n:%@",htmlString);
    
    return htmlString;
}

+ (NSString *)renderHeader:(NSDictionary *)articleDic {
    
    NSMutableString *headerHTMLString;
    
    NSString *templateFileName = [[self resourceBundle] pathForResource:@"articleHeaderTemplate"
                                                                 ofType:@"html"];
    NSMutableString *articleTemplate = [NSMutableString stringWithContentsOfFile:templateFileName
                                                                        encoding:NSUTF8StringEncoding
                                                                           error:NULL];
    NSDictionary *issueInfoDic = articleDic[@"magazine"];
    NSString *articleMainImageURL = [NSString stringWithFormat:@"%@/articles/%@/main_image?size=medium",[KCServerConfig getApiBaseURL],articleDic[@"article_id"]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        articleMainImageURL = [articleMainImageURL stringByAppendingString:@"&crop=9:5"];
    }
    else {
        articleMainImageURL = [articleMainImageURL stringByAppendingString:@"&crop=4:3"];
    }
    
    headerHTMLString = [[articleTemplate stringByReplacingOccurrencesOfString:@"$ARTICLE_MAIN_IMAGE" withString:articleMainImageURL] mutableCopy];
    headerHTMLString = [[headerHTMLString stringByReplacingOccurrencesOfString:@"$ARTICLE_TITLE" withString:articleDic[@"title"]] mutableCopy];
    headerHTMLString = [[headerHTMLString stringByReplacingOccurrencesOfString:@"$ARTICLE_SUBTITLE" withString:articleDic[@"sub_title"]] mutableCopy];
    headerHTMLString = [[headerHTMLString stringByReplacingOccurrencesOfString:@"$MAGAZINE_TITLE" withString:issueInfoDic[@"name"]] mutableCopy];
    headerHTMLString = [[headerHTMLString stringByReplacingOccurrencesOfString:@"$MAGAZINE_ISSUE" withString:issueInfoDic[@"issue"]] mutableCopy];
    headerHTMLString = [[headerHTMLString stringByReplacingOccurrencesOfString:@"$ARTICLE_AUTHOR" withString:articleDic[@"author"]] mutableCopy];
    headerHTMLString = [[headerHTMLString stringByReplacingOccurrencesOfString:@"$ARTICLE_INTRO" withString:articleDic[@"intro"]] mutableCopy];
    
    return headerHTMLString;
}

+ (NSString *)renderSections:(NSArray *)sectionsArray {
    
    NSString *htmlString = [NSString new];
    
    for (NSDictionary *sectionInfo in sectionsArray) {
        
        NSString *sectionImageString = [self renderSectionImages:sectionInfo[@"images"]];
        NSString *sectionParagraphString = [self renderParagraphs:sectionInfo[@"paragraphs"]];
        htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<div class=\"row section-row\"><div class=\"lg-col-12 md-col-12 sm-col-12\"><div class=\"section-subtitle\">%@</div>%@ %@</div></div>", sectionInfo[@"title"],sectionImageString,sectionParagraphString]];
    }
    
    return htmlString;
}

+ (NSString *)renderSectionImages:(NSArray *)imagesArray {
    
    NSString *sectionImageHTMLString = [NSString new];
    
    for (NSDictionary *imageDic in imagesArray) {
        
        NSString *articleImageURL = [NSString stringWithFormat:@"%@/images/%@",[KCServerConfig getApiBaseURL],imageDic[@"id"]];
        
        sectionImageHTMLString = [sectionImageHTMLString stringByAppendingString:[NSString stringWithFormat:@"<img alt=\"section-img\" class=\"img-responsive content-image\" src=%@>", articleImageURL]];
    }
    return sectionImageHTMLString;
}

+ (NSString *)renderParagraphs:(NSArray *)paragraphesArray {
    
    NSString *paragraphHTMLString = [NSString new];
    
    for (NSDictionary *paragraphDic in paragraphesArray) {
        
        NSString *paragraphContentHTMLString = [self renderContent:paragraphDic[@"content"]];
        NSString *paragraphImageHTMLString = [self renderParagraphImages:paragraphDic[@"images"]];
        NSString *paragraphAudioHTMLString = [self renderAudio:paragraphDic[@"audios"]];
        NSString *paragraphVideoHTMLString = [self renderVideo:paragraphDic[@"videos"]];
        
        paragraphHTMLString = [paragraphHTMLString stringByAppendingString:[NSString stringWithFormat:@"<div class=\"section-content\">%@ %@ %@ %@ </div>", paragraphAudioHTMLString,paragraphVideoHTMLString, paragraphContentHTMLString,paragraphImageHTMLString]];
    }
    return paragraphHTMLString;
}

+ (NSString *)renderContent:(NSString *)contentString {
    
    NSString *contentHTMLString = [NSString stringWithFormat:@"<div class=\"content-text\">%@</div>",contentString];
    
    return contentHTMLString;
}

+ (NSString *)renderParagraphImages:(NSArray *)imagesArray {
    
    NSString *paragraphImageHTMLString = [NSString new];
    
    for (NSDictionary *imageDic in imagesArray) {
        
        NSString *imageURL = [NSString stringWithFormat:@"%@/images/%@",[KCServerConfig getApiBaseURL],imageDic[@"id"]];
        
        paragraphImageHTMLString = [paragraphImageHTMLString stringByAppendingString:[NSString stringWithFormat:@"<div class=\"content-block\"><img alt=\"paragraph-img\" class=\"img-responsive content-image\" src=%@><div class=\"media-description\">%@</div></div>", imageURL,imageDic[@"caption"]]];
    }
    return paragraphImageHTMLString;
}

+ (NSString *)renderAudio:(NSArray *)audiosArray {
    
    NSString *audioHTMLString = [NSString new];
    
    for (NSDictionary *audioDic in audiosArray) {
        
        if ( [audioDic objectForKey:@"reader_id"] && [audioDic objectForKey:@"access_token"]) {
            NSString *audioURL = [NSString stringWithFormat:@"%@/audios/%@/playback?reader_id=%@&access_token=%@",[KCServerConfig getApiBaseURL],audioDic[@"id"],audioDic[@"reader_id"],audioDic[@"access_token"]];;
            
            audioHTMLString = [audioHTMLString stringByAppendingString:[NSString stringWithFormat:@"<div class=\"content-block\" style=\"width:100%%;\"><audio controls=\"\" style=\"width:100%%;\"><source src=\"%@\"></audio><div class=\"media-title\">%@</div><div class=\"media-description\">%@</div></div>", audioURL,audioDic[@"title"],audioDic[@"description"]]];
        }
    }
    return audioHTMLString;
}

+ (NSString *)renderVideo:(NSArray *)videosArray {
    
    NSString *videoHTMLString = [NSString new];
    
    for (NSDictionary *videoDic in videosArray) {
        
        if ([videoDic objectForKey:@"reader_id"] && [videoDic objectForKey:@"access_token"]) {
            
            float videoDisplayRatio = ([videoDic[@"height"] floatValue] / [videoDic[@"width"] floatValue])*100;
            
            NSString *videoStyle = [NSString stringWithFormat:@"padding-bottom:\"%lf%%\"",videoDisplayRatio];
            
            NSString *videoPreviewImage = [NSString stringWithFormat:@"%@/videos/%@/thumbnail/medium",[KCServerConfig getApiBaseURL],videoDic[@"id"]];;
            NSString *videoURL = [NSString stringWithFormat:@"%@/videos/%@/playback?reader_id=%@&access_token=%@",[KCServerConfig getApiBaseURL],videoDic[@"id"],videoDic[@"reader_id"],videoDic[@"access_token"]];
            
            videoHTMLString = [videoHTMLString stringByAppendingString:[NSString stringWithFormat:@"<div class=\"content-block\"><div class=\"content-video\" style=\"%@\"><video controls=\"\" poster=\"%@\" src=\"%@\"></video></div><div class=\"media-title\">%@</div><div class=\"media-description\">%@</div></div>", videoStyle, videoPreviewImage,videoURL,videoDic[@"title"],videoDic[@"description"]]];
            
        }
    }
    return videoHTMLString;
}


@end
