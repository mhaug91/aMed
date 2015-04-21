//
//  Events.m
//  aMed
//
//  Created by Kristofer Myhre on 21/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "Events.h"

@implementation Events

-(id) initWithEvent_id:(NSInteger *)event_id andEventdetail_id:(NSInteger *)eventdetail_id andStart_date:(NSString *)start_date andEnd_date:(NSString *)end_date andSummary:(NSString *)summary andCategory_id:(NSInteger *)category_id{
    self = [super init];
    if (self) {
        self.event_id = event_id;
        self.eventdetail_id = eventdetail_id;
        self.start_date = start_date;
        self.end_date = end_date;
        self.summary = summary;
        self.category_id = category_id;
    }
    return self;
}
@end
