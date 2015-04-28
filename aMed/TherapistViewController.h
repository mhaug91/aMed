//
//  TherapistViewController.h
//  aMed
//
//  Created by Kristofer Myhre on 14/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TherapistTableViewController.h"
#import "retrieveData.h"
#import "ThreatmentInfoViewController.h"
#import "ThreatmentMethod.h"
#import "Therapists.h"

@interface TherapistViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property(strong, nonatomic) RetrieveData *rd;
@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *therapists;
@property(strong, nonatomic) Therapists *currentTherapist;
@property(strong, nonatomic) ThreatmentMethod *selectedTreatmentMethod;
@property(strong, nonatomic) NSMutableArray *threatmentsArray;
@property(nonatomic, strong) NSMutableArray *associatedMethods;


- (void) getTherapistObject: (id) therapistObject;
@end
