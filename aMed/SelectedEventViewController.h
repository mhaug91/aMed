//
//  SelectedEventViewController.h
//  aMed
//
//  Created by Kristofer Myhre on 22/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "retrieveData.h"
#import "EventsTableViewController.h"
#import "Events.h"
#import <GoogleMaps/GoogleMaps.h>


@interface SelectedEventViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property(strong, nonatomic) Events *selectedEvent;
@property(strong, nonatomic) RetrieveData *rd;
@property(strong, nonatomic) NSMutableArray *eventArray;
@property(strong, nonatomic) NSMutableArray *associatedArray;
@property(strong, nonatomic) NSMutableArray *filterArray;
@property(strong, nonatomic) NSMutableArray *daySub;
@property int day;
@property(strong, nonatomic) UIActivityIndicatorView *spinner; ///An activity indicator to show that a task is in progress.


- (void) getEventObject: (id) eventObject;

@end
