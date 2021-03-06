//
//  BehListeTableViewController.h
//  aMed
//
//  Created by MacBarhaug on 16.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreatmentMethod.h"
#import "BehMetViewController.h"
#import "TreatmentInfoViewController.h"
#import "RetrieveData.h"


/**
 *  This controller controls the Threatments table view.
 *  Consists of a table view and a search bar. 
 */
@interface TreatmentsTableViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>


@property(strong, nonatomic) RetrieveData *rd; /// Object to retrieve data from the database. 
@property(strong, nonatomic) NSMutableArray *threatmentsArray; /// Array of threatment objects
@property(strong, nonatomic) UIActivityIndicatorView *spinner;//An activity indicator to show that a task is in progress.



@end
