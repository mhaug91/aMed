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

@interface NewsViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) RetrieveData *rd;
@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *newsArray;


@end

