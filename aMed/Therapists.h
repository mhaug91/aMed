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
<NSURLConnectionDelegate>

@property(strong, nonatomic)NSString *firstName;
@property(strong, nonatomic)NSString *lastName;
@property(strong, nonatomic)NSString *avatar;
@property(strong, nonatomic)NSString *website;
@property(strong, nonatomic)NSString *email;
@property(strong, nonatomic)NSString *occupation;
@property(strong, nonatomic)NSString *company;
@property(strong, nonatomic)Address *address;
@property NSInteger phone;
@property(strong, nonatomic)NSString *comment;
@property(strong, nonatomic)NSArray *treatmentMethods;
@property(strong, nonatomic)NSString *treatmentMethodString;
@property(strong, nonatomic) NSString *pictureURL;
@property(strong, nonatomic) NSMutableData *picture;





-(id) initWithFirstName: (NSString * ) firstName andLastName: (NSString *) lastName andAvatar: (NSString *) avatar andWebsite: (NSString *) website andEmail: (NSString *) email andOccupation: (NSString *) occupation andCompany: (NSString *) company andAddress: (Address *) address andPhone: (NSInteger *) phone andComment: (NSString *) comment andTreatmentMethods: (NSArray *) treatmentMethods andTreatmentMethodString: (NSString *) treatmentMethodString andPictureURL:(NSString *) URL;

-(id) initWithFirstName: (NSString *) firstName andLastName: (NSString *) lastName andAddress:(Address *) address;
@end
