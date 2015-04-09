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
@interface ThreatmentInfoViewController : UIViewController


@property(nonatomic, strong) ThreatmentMethod *currentMethod;
@property(nonatomic, strong) NSString *htmlString;
@property(nonatomic, strong) NSMutableArray *allTherapists;
@property(nonatomic, strong) NSMutableArray *associatedTherapists;
@property(nonatomic, strong) RetrieveData *rd;


#pragma marks
#pragma mark Methods

- (void) getThreatmentMethod:(id)threatmentObject;
- (void) setWebView;

@end
