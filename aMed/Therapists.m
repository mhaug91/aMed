//
//  Therapists.m
//  aMed
//
//  Created by Kristofer Myhre on 07/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "Therapists.h"

@implementation Therapists

-(id) initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andAvatar:(NSString *)avatar andWebsite:(NSString *)website andEmail:(NSString *)email andOccupation:(NSString *)occupation andCompany:(NSString *)company andAddress:(Address *)address andPhone:(NSInteger *)phone andComment:(NSString *)comment andTreatmentMethods:(NSArray *)treatmentMethods andTreatmentMethodString:(NSString *)treatmentMethodString andPictureURL:(NSString *) URL{
    self = [super init];
    if (self){
        self.firstName = firstName;
        self.lastName = lastName;
        self.avatar = avatar;
        self.website = website;
        self.email = email;
        self.occupation = occupation;
        self.company = company;
        self.address = address;
        self.phone = *phone;
        self.comment = comment;
        self.treatmentMethods = treatmentMethods;
        self.treatmentMethodString = treatmentMethodString;
        self.pictureURL=URL;
        self.picture =[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];

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
