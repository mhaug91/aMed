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
#import "TreatmentInfoViewController.h"
#import "TreatmentMethod.h"
#import "Therapists.h"

@interface TherapistViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIAlertViewDelegate>

@property(strong, nonatomic) RetrieveData *rd;
@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *therapists;
@property(strong, nonatomic) Therapists *currentTherapist;
@property(strong, nonatomic) TreatmentMethod *selectedTreatmentMethod;
@property(strong, nonatomic) NSMutableArray *threatmentsArray;
@property(nonatomic, strong) NSMutableArray *associatedMethods;

/**
 *  Sets the currentTherapist object.
 *
 *  @param therapistObject
 *  @note In our app we use this method in the therapist table view controller
 */

- (void) getTherapistObject: (id) therapistObject;
@end
