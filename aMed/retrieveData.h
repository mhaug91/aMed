//
//  retrieveData.h
//  aMed
//
//  Created by MacBarhaug on 27.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThreatmentMethod.h"

@interface RetrieveData : NSObject

@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *threatmentsArray;


#pragma marks
#pragma mark - Class methods

- (NSString *) retrieveThreatmentInfoData: (NSString *) alias;
- (NSMutableArray *) retrieveThreatmentsData;



@end
