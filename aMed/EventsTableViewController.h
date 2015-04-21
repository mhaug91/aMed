//
//  EventsTableViewController.h
//  aMed
//
//  Created by Kristofer Myhre on 21/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetrieveData.h"


@interface EventsTableViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) RetrieveData *rd;
@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *eventArray;

@end
