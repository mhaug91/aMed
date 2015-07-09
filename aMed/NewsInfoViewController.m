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

-(void) viewWillAppear:(BOOL)animated{
    [self setWebView];
    [self.spinner stopAnimating];
}

#pragma mark Methods

- (void) getNewsObject: (id) newsObject{
    self.currentNews = newsObject;
}
- (void) setWebView{
    NSString *htmlString = self.currentNews.introText;
    /* If the image path is bad, for example: "images/...", replace it with the full path: */
    if ([htmlString rangeOfString:@"https://www.amed.no/images"].location == NSNotFound) { // If the substring "images" is not found
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"images" withString:@"https://www.amed.no/images"];
    }
    
    if ([htmlString rangeOfString:@""].location == NSNotFound){
    //    htmlString = [htmlString string
    }
    
    /* Amed.no (the website) has a custom backbutton used on the pages for the
     * treatment methods. This has to be removed from the text: */
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"{backbutton}" withString:@""];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}


@end
