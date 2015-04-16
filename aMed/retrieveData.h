//
//  retrieveData.h
//  aMed
//
//  Created by MacBarhaug on 27.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThreatmentMethod.h"
#import "Therapists.h"
#import "Address.h"
#import "Location.h"
#import "News.h"

@interface RetrieveData : NSObject

@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *threatmentsArray;
@property(strong, nonatomic) NSMutableArray *therapistArray;


#pragma marks
#pragma mark - Class methods

- (NSString *) retrieveThreatmentInfoData: (NSString *) alias;
- (NSMutableArray *) retrieveThreatmentsData;
- (NSMutableArray *) retrieveTherapists;

- (NSMutableArray *) retrieveNewsData;
- (NSString *) retrieveNewsInfoData: (NSString *) alias;



@end
