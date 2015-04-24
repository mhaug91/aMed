//
//  Address.m
//  aMed
//
//  Created by Kristofer Myhre on 08/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "Address.h"

@implementation Address

-(id) initWithStreet:(NSString *)street andCity:(NSString *)city andState:(NSString *)state andPostcode:(NSInteger *)postcode andCountry:(NSString *)country{
    self = [super init];
    if (self){
        self.street = street;
        self.city = city;
        self.state = state;
        self.postcode = *postcode;
        self.country = country;
    }
    return self;
}
-(id) initWithStreet:(NSString *)street andCity:(NSString *)city andPostcode:(NSInteger *)postcode{
    self = [super init];
    if (self){
        self.street = street;
        self.city = city;
        self.postcode = *postcode;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@, %@, %@, %ld, %@", _street, _city, _state, _postcode, _country];
}

@end
