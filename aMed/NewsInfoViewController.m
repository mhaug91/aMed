//
//  NyhetsVisningController.m
//  aMed
//
//  Created by MacBarhaug on 18.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "NewsInfoViewController.h"
#import "News.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface NewsInfoViewController ()
@end

@implementation NewsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.spinner];
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.spinner setColor:UIColorFromRGB(0x602167)];
    [self.spinner startAnimating];


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma marks

-(void) viewDidAppear:(BOOL)animated{
    self.rd = [[RetrieveData alloc] init];
    [self retrieveIntroText];
    [self setWebView];
    
    [self.spinner stopAnimating];
}

#pragma mark Methods

/* Not in use Version 1.2
- (void) getNewsObject: (id) newsObject{
    self.currentNews = newsObject;
}
 */

-(void) getAlias:(NSString *) alias{
    self.alias = alias;

}

-(void) retrieveIntroText{
    self.introText= [self.rd retrieveNewsInfoData:self.alias];
}

- (void) setWebView{
    
    //NSString *htmlString = self.currentNews.introText;
    /* If the image path is bad, for example: "images/...", replace it with the full path: */
    if ([self.introText rangeOfString:@"https://www.amed.no/OLD/images"].location == NSNotFound) { // If the substring "images" is not found
        self.introText = [self.introText stringByReplacingOccurrencesOfString:@"images" withString:@"https://www.amed.no/OLD/images"];
    }
    /* Amed.no (the website) has a custom backbutton used on the pages for the
     * treatment methods. This has to be removed from the text: */
    self.introText = [self.introText stringByReplacingOccurrencesOfString:@"{backbutton}" withString:@""];
    [self.webView loadHTMLString:self.introText baseURL:nil];
}


@end
