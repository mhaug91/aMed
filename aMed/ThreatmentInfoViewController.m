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
    self.rd = [[RetrieveData alloc] init];
    self.allTherapists = [self.rd retrieveTherapists];
    [self findAssociatedTherapists];
    
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

/* Puts the introtext made of html inside the webview
 * Some adjustments to the string has to be made to display well.
 */
- (void) setWebView{
    self.htmlString = self.currentMethod.introText; // stores the introtext in an own variable
    
    /* If the image path is bad, for example: "images/...", replace it with the full path: */
    if ([self.htmlString rangeOfString:@"images"].location != NSNotFound) { // If the substring "images" is found
        self.htmlString = [self.currentMethod.introText stringByReplacingOccurrencesOfString:@"images" withString:@"https://www.amed.no/images"];
    }
    
    /* Amed.no (the website) has a custom backbutton used on the pages for the
     * treatment methods. This has to be removed from the text: */
    self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"{backbutton}" withString:@""];
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
    
}

/* This method finds the associated therapists with the current threatmentmethod */
- (void) findAssociatedTherapists{
    if(self.allTherapists != nil){
        self.associatedTherapists = [[NSMutableArray alloc] init];
        for(Therapists *t in self.allTherapists){ // Short for- loop. Loops through all therapists
            for(NSString *s in t.treatmentMethods){ // Loops through the threatmentmethods of a therapist.
                if([self.currentMethod.title isEqualToString:s]){ // if current method is associated with therapist
                    NSLog(@"%@", t.firstName);
                    [self.associatedTherapists addObject:t]; // add the therapist to associated therapists array.
                }
                
            }
        }
    }
    
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
