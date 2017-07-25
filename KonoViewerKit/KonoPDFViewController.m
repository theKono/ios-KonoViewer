//
//  KonoPDFViewController.m
//  KonoViewerKit
//
//  Created by kuokuo on 2017/7/24.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KonoPDFViewController.h"

@interface KonoPDFViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *magazineTitle;

@end

@implementation KonoPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.magazineTitle setText:self.book.name];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
