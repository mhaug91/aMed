//
//  NyhetsVisningController.m
//  aMed
//
//  Created by MacBarhaug on 18.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "NewsInfoViewController.h"
#import "News.h"

@interface NewsInfoViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView; // Contains the article

@end

@implementation NewsInfoViewController

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

- (void) getNewsObject: (id) newsObject{
    self.currentNews = newsObject;
}
- (void) setWebView{
    NSString *htmlString = self.currentNews.introText;
    /* If the image path is bad, for example: "images/...", replace it with the full path: */
    if ([htmlString rangeOfString:@"https://www.amed.no/images"].location == NSNotFound) { // If the substring "images" is not found
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"images" withString:@"https://www.amed.no/images"];
    }
    
    /* Amed.no (the website) has a custom backbutton used on the pages for the
     * treatment methods. This has to be removed from the text: */
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"{backbutton}" withString:@""];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}


@end
