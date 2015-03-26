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


@property(nonatomic, strong) ThreatmentMethod *currentMethod;
@property(nonatomic, strong) NSString *htmlString;


#pragma marks
#pragma mark Methods

- (void) getThreatmentMethod:(id)threatmentObject;
- (void) setWebView;

@end
