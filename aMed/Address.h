//
//  Address.h
//  aMed
//
//  Created by Kristofer Myhre on 08/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property(strong, nonatomic)NSString *street;
@property(strong, nonatomic)NSString *city;
@property(strong, nonatomic)NSString *state;
@property NSInteger postcode;
@property(strong, nonatomic)NSString *country;

-(id) initWithStreet: (NSString *) street andCity: (NSString *) city andState: (NSString *) state andPostcode:  (NSInteger  *) postcode andCountry: (NSString *) country;

@end
