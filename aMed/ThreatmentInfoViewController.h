//
//  behInfoViewController.h
//  aMed
//
//  Created by MacBarhaug on 19.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreatmentMethod.h"
@interface ThreatmentInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *aliasLabel;

@property(nonatomic, strong) ThreatmentMethod *currentMethod;


#pragma marks
#pragma mark Methods

- (void) getThreatmentMethod:(id)threatmentObject;
- (void) setWebView;

@end
