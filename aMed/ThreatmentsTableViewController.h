//
//  BehListeTableViewController.h
//  aMed
//
//  Created by MacBarhaug on 16.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreatmentMethod.h"
#import "BehMetViewController.h"
#import "ThreatmentInfoViewController.h"
#import "RetrieveData.h"

@interface ThreatmentsTableViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>


@property(strong, nonatomic) RetrieveData *rd;
@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *threatmentsArray;

#pragma marks
#pragma mark - Class methods
//- (void) retrieveData;
//- (void) setWebView;



@end
