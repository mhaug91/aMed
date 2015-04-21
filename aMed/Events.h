//
//  Events.h
//  aMed
//
//  Created by Kristofer Myhre on 21/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Events : NSObject

@property NSInteger *event_id;
@property NSInteger *eventdetail_id;
@property(strong, nonatomic) NSString *start_date;
@property(strong, nonatomic) NSString *end_date;
@property(strong, nonatomic) NSString *summary;
@property NSInteger *category_id;

- (id) initWithEvent_id: (NSInteger *) event_id andEventdetail_id: (NSInteger *) eventdetail_id andStart_date: (NSString *) start_date andEnd_date: (NSString *) end_date andSummary: (NSString *) summary andCategory_id: (NSInteger *) category_id;

@end
