//
//  Therapists.h
//  aMed
//
//  Created by Kristofer Myhre on 07/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

@interface Therapists : NSObject

@property(strong, nonatomic)NSString *firstName;
@property(strong, nonatomic)NSString *lastName;
@property(strong, nonatomic)NSString *avatar;
@property(strong, nonatomic)NSString *website;
@property(strong, nonatomic)NSString *occupation;
@property(strong, nonatomic)NSString *company;
@property(strong, nonatomic)Address *address;
@property NSInteger phone;
@property(strong, nonatomic)NSString *comment;
@property(strong, nonatomic)NSArray *treatmentMethods;

-(id) initWithFirstName: (NSString * ) firstName andLastName: (NSString *) lastName andAvatar: (NSString *) avatar andWebsite: (NSString *) website andOccupation: (NSString *) occupation andCompany: (NSString *) company andAddress: (Address *) address andPhone: (NSInteger *) phone andComment: (NSString *) comment andTreatmentMethods: (NSArray *) treatmentMethods;

-(id) initWithFirstName: (NSString *) firstName andLastName: (NSString *) lastName andAddress:(Address *) address;
@end
