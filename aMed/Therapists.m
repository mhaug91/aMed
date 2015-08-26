//
//  Therapists.m
//  aMed
//
//  Created by Kristofer Myhre on 07/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "Therapists.h"

@implementation Therapists{
    NSURLConnection *conn;
}

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
        
        //self.picture =[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        [self findPicture]; //Method for fetching the picture through an unsecure connection

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

#pragma mark Unsecure connection methods.

/**
* These methods are not finished.
* Only work for displaying 1 picture
* Not in the table views where there is several. 
*/
- (void) findPicture{
    conn = [[NSURLConnection alloc] initWithRequest:
            [NSURLRequest requestWithURL:[NSURL URLWithString:self.pictureURL]] delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.picture appendData:data];
}


- (BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge.protectionSpace.authenticationMethod
         isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        // instead of XXX.XXX.XXX, add the host URL,
        // if this didn't work, print out the error you receive.
        //if ([challenge.protectionSpace.host isEqualToString:@"XXX.XXX.XXX"]) {
            NSLog(@"Allowing bypass...");
            NSURLCredential *credential = [NSURLCredential credentialForTrust:
                                           challenge.protectionSpace.serverTrust];
            [challenge.sender useCredential:credential
                 forAuthenticationChallenge:challenge];
       // }
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


@end
