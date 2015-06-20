//
//  FirstViewController.h
//  aMed
//
//  Created by MacBarhaug on 09.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "NewsViewController.h"
#import "NewsInfoViewController.h"
#import "RetrieveData.h"

/**
 *  This controller controls the News table view.
 *  Consists of a table view.
 *  Has a segue from selected news to the article. 
 */
@interface NewsViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property(strong, nonatomic) RetrieveData *rd; // Handling requests to database. 
@property(strong, nonatomic) NSMutableArray *newsArray; // News from the database.
@property(strong, nonatomic) UIActivityIndicatorView *spinner;//An activity indicator to show that a task is in progress.



@end

