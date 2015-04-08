//
//  Location.h
//  aMed
//
//  Created by Kristofer Myhre on 08/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

@interface Location : NSObject

@property(strong, nonatomic)NSNumber *location_id;
@property(strong, nonatomic)NSString *title;
@property(strong, nonatomic)Address *address;
@property(strong, nonatomic)NSNumber *geo_longitude;
@property(strong, nonatomic)NSNumber *geo_latitude;

-(id) initWithLocation_id: (NSNumber *) location_id andTitle: (NSString *) title andAddress: (Address *) address andGeo_longitude: (NSNumber *) geo_longitude andGeo_latitude: (NSNumber *) geo_latitude;

@end
