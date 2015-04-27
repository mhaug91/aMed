//
//  finnBehandlerTableViewController.h
//  aMed
//
//  Created by Kristofer Myhre on 09/03/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetrieveData.h"
#import "TherapistViewController.h"

@interface TherapistTableViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property(strong, nonatomic) RetrieveData *rd;
@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *therapists;



@end
