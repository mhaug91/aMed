//
//  EventsTableViewController.h
//  aMed
//
//  Created by Kristofer Myhre on 21/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetrieveData.h"
#import "SelectedEventViewController.h"


@interface EventsTableViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property(strong, nonatomic) RetrieveData *rd;
@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *eventArray;
@property(strong, nonatomic) NSMutableArray *filterArray;
@property(strong, nonatomic) UIActivityIndicatorView *spinner; //An activity indicator to show that a task is in progress. 

@end
