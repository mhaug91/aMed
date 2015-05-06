//
//  behInfoViewController.h
//  aMed
//
//  Created by MacBarhaug on 19.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreatmentMethod.h"
#import "Therapists.h"
#import "retrieveData.h"
#import "TherapistTableViewController.h"
#import "NewsInfoViewController.h"
#import "NewsViewController.h"
@interface ThreatmentInfoViewController : UIViewController <UIAlertViewDelegate>


@property(nonatomic, strong) ThreatmentMethod *currentMethod;
@property(nonatomic, strong) NSString *htmlString;
@property(nonatomic, strong) NSMutableArray *allTherapists;
@property(nonatomic, strong) NSMutableArray *associatedTherapists;
@property(nonatomic, strong) RetrieveData *rd;
@property (strong, nonatomic) UITableView *tableView;



#pragma marks
#pragma mark Methods

- (void) getThreatmentMethod:(id)threatmentObject;
- (void) setWebView;

@end
