//
//  NyhetsVisningController.h
//  aMed
//
//  Created by MacBarhaug on 18.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "RetrieveData.h"

/**
 *  Controlling the newsinfo view. 
 * Contains a webwiev with article.
 */
@interface NewsInfoViewController : UIViewController <UIAlertViewDelegate, UIWebViewDelegate>

//@property(strong, nonatomic) News *currentNews; // Current newsobject to display info about.
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner; //An activity indicator to show that a task is in progress.
@property(strong, nonatomic) RetrieveData *rd; // Handling requests to database.
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(weak, nonatomic) NSString *alias;
@property(strong, nonatomic) NSString *introText;

/**
 *  Sets the currentNews object.
 *
 *  @param newsObject 
 *  @note In our app we use this method in the news table view controller
 */
//- (void) getNewsObject: (id) newsObject;
- (void) getAlias: (NSString *) alias;

@end
