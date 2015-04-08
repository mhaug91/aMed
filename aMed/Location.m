//
//  Location.m
//  aMed
//
//  Created by Kristofer Myhre on 08/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "Location.h"

@implementation Location

-(id)initWithLocation_id:(NSNumber *)location_id andTitle:(NSString *)title andAddress:(Address *)address andGeo_longitude:(NSNumber *)geo_longitude andGeo_latitude:(NSNumber *)geo_latitude{
    self = [super init];
    if(self){
        self.location_id = location_id;
        self.title = title;
        self.address = address;
        self.geo_longitude = geo_longitude;
        self.geo_latitude = geo_latitude;
    }
    return self;
}

@end
