//
//  TherapistViewController.h
//  aMed
//
//  Created by Kristofer Myhre on 14/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "finnBehandlerTableViewController.h"
#import "retrieveData.h"
#import "ThreatmentInfoViewController.h"
#import "ThreatmentMethod.h"

@interface TherapistViewController : UIViewController

@property(strong, nonatomic) RetrieveData *rd;
@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *therapists;
@property(strong, nonatomic) Therapists *currentTherapist;
@property(strong, nonatomic) ThreatmentMethod *selectedTreatmentMethod;
@property(strong, nonatomic) NSMutableArray *threatmentsArray;

- (void) getTherapistObject: (id) therapistObject;
- (IBAction)buttonTapped:(UIButton *)sender;
@end
