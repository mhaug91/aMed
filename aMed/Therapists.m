//
//  Therapists.m
//  aMed
//
//  Created by Kristofer Myhre on 07/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "Therapists.h"

@implementation Therapists

-(id) initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andAvatar:(NSString *)avatar andWebsite:(NSString *)website andOccupation:(NSString *)occupation andCompany:(NSString *)company andAddress:(Address *)address andPhone:(NSInteger *)phone andComment:(NSString *)comment andTreatmentMethods:(NSArray *)treatmentMethods{
    self = [super init];
    if (self){
        self.firstName = firstName;
        self.lastName = lastName;
        self.avatar = avatar;
        self.website = website;
        self.occupation = occupation;
        self.company = company;
        self.address = address;
        self.phone = *phone;
        self.comment = comment;
        self.treatmentMethods = treatmentMethods;
    }
    return self;
}

-(id) initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andAddress:(Address *)address{
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.address = address;
    }
    return self;
}

@end
