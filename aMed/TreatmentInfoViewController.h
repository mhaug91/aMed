//
//  behInfoViewController.h
//  aMed
//
//  Created by MacBarhaug on 19.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreatmentMethod.h"
#import "Therapists.h"
#import "retrieveData.h"
#import "TherapistTableViewController.h"
#import "NewsInfoViewController.h"
#import "NewsViewController.h"

/**
 *  Controls the Treatment info view. 
 *  Has a webview with treatment info, and a table view with associated therapists.
 *  Segue to associated therapists info. 
 */
@interface TreatmentInfoViewController : UIViewController <UIAlertViewDelegate>


@property(nonatomic, strong) TreatmentMethod *currentMethod;
@property(nonatomic, strong) NSString *htmlString;
@property(nonatomic, strong) NSMutableArray *allTherapists;
@property(nonatomic, strong) NSMutableArray *associatedTherapists;
@property(nonatomic, strong) RetrieveData *rd;
@property (strong, nonatomic) IBOutlet UITableView *tableView;




#pragma marks
#pragma mark Methods

- (void) getThreatmentMethod:(id)threatmentObject;
- (void) setWebView;

@end
