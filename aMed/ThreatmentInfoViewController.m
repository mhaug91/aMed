//
//  behInfoViewController.m
//  aMed
//
//  Created by MacBarhaug on 19.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "ThreatmentInfoViewController.h"


@interface ThreatmentInfoViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ThreatmentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWebView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks
#pragma mark Methods

- (void) getThreatmentMethod:(id)threatmentObject{
    self.currentMethod=threatmentObject;
}


- (void) setWebView{
    [self.webView loadHTMLString:self.currentMethod.introText baseURL:nil];
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
