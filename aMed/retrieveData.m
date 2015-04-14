//
//  retrieveData.m
//  aMed
//
//  Created by MacBarhaug on 27.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "RetrieveData.h"
#import <CoreLocation/CoreLocation.h>

#define getDataThreatmentsURL @"http://www.amed.no/AmedApplication/getTreatmentmethods.php"
#define getDataThreatmentInfoURL @"http://www.amed.no/AmedApplication/getTreatmentmethodInfo.php?alias="
#define getDataTherapistsURL @"http://www.amed.no/AmedApplication/getTherapists.php"
#define getNewsDataURL @"http://www.amed.no/AmedApplication/getNews.php"
#define getNewsDataInfoURL @"http://www.amed.no/AmedApplication/getNewsInfo.php?alias="




@implementation RetrieveData

#pragma mark database methods

/* This method returns the information of a selected threatmentmethod from the database.
 * Takes an alias as the argument
 */

- (NSString *) retrieveThreatmentInfoData: (NSString *) alias
{
    NSString *info = nil;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", getDataThreatmentInfoURL, alias]; // makes the urlstring where the info is stored
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.jsonArray =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    //Loop through json Array
    for (int i=0; i<self.jsonArray.count; i++) {
        info = [[self.jsonArray objectAtIndex:i] objectForKey:(@"introtext")];
        
    }
    return info;
}


/* Returns all the ThreatmenMethods and put them
* in a ThreatmentMethod Array
 */
- (NSMutableArray *) retrieveThreatmentsData{
    NSURL *url = [NSURL URLWithString:getDataThreatmentsURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    // setting up threatments Array
    NSMutableArray *threatmentsArray = [[NSMutableArray alloc] init];
    
    //Loop through json Array
    for (int i=0; i<self.jsonArray.count; i++) {
        //Create our threatment object
        NSString *title = [[self.jsonArray objectAtIndex:i] objectForKey:(@"title")];
        NSString *alias = [[self.jsonArray objectAtIndex:i] objectForKey:(@"alias")];
        
        //add the threatment object to our threatments array
        [threatmentsArray addObject:[[ThreatmentMethod alloc]initWithTitle:title andAlias:alias]];
        
    }
    return threatmentsArray;
}

-(NSMutableArray *) retrieveTherapists{
    
    NSMutableArray *therapists = [[NSMutableArray alloc] init];
    Therapists *therapist = [[Therapists alloc] init];
    Address *address = [[Address alloc] init];
    NSArray *tr_methods = [[NSMutableArray alloc] init];
    
    NSInteger postcode, phone;
    
    
    NSURL *url = [NSURL URLWithString:getDataTherapistsURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
    for (int i = 0; i<self.jsonArray.count; i++) {
        
        //Address
        NSString *street = [[self.jsonArray objectAtIndex:i] objectForKey:(@"address")];
        NSString *city = [[self.jsonArray objectAtIndex:i] objectForKey:(@"city")];
        NSString *state = [[self.jsonArray objectAtIndex:i] objectForKey:(@"state")];
        NSString *country = [[self.jsonArray objectAtIndex:i] objectForKey:(@"country")];
        @try {
            postcode = [[[self.jsonArray objectAtIndex:i] objectForKey:(@"zipcode")] integerValue];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception.reason);
        }
        @finally {
            NSLog(@"Finally");
        }
        
        //Therapist
        NSString *firstName = [[self.jsonArray objectAtIndex:i] objectForKey:(@"firstname")];
        NSString *lastName = [[self.jsonArray objectAtIndex:i] objectForKey:(@"lastname")];
        NSString *avatar = [[self.jsonArray objectAtIndex:i] objectForKey:(@"avatar")];
        NSString *website = [[self.jsonArray objectAtIndex:i] objectForKey:(@"website")];
        NSString *occupation = [[self.jsonArray objectAtIndex:i] objectForKey:(@"cb_yrke")];
        NSString *company = [[self.jsonArray objectAtIndex:i] objectForKey:(@"company")];
        @try {
            phone = [[[self.jsonArray objectAtIndex:i] objectForKey:(@"phone")] integerValue];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception.reason);
        }
        @finally {
            NSLog(@"Finally");
        }
        NSString *comment = [[self.jsonArray objectAtIndex:i] objectForKey:(@"cb_ajaxtekst")];
        NSString *treatmentMethods = [[self.jsonArray objectAtIndex:i] objectForKey:(@"cb_behandlingsmetode6")];
        
        //Splitting string of treatment methods into an array.
        tr_methods = [treatmentMethods componentsSeparatedByString:(@"|*|")];
        
        address = [[Address alloc] initWithStreet:street andCity:city andState:state andPostcode:&postcode andCountry:country];
        therapist = [[Therapists alloc] initWithFirstName:firstName andLastName:lastName andAvatar:avatar andWebsite:website andOccupation:occupation andCompany:company andAddress:address andPhone:&phone andComment:comment andTreatmentMethods:tr_methods];
        
        [therapists addObject:therapist];
        
    }
    return therapists;
}

- (NSMutableArray *) retrieveNewsData{
    NSURL *url = [NSURL URLWithString:getNewsDataURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    // setting up threatments Array
    NSMutableArray *newsArray = [[NSMutableArray alloc] init];
    
    //Loop through json Array
    for (int i=0; i<self.jsonArray.count; i++) {
        //Create our threatment object
        NSString *title = [[self.jsonArray objectAtIndex:i] objectForKey:(@"title")];
        NSString *alias = [[self.jsonArray objectAtIndex:i] objectForKey:(@"alias")];
        
        //add the threatment object to our threatments array
        [newsArray addObject:[[ThreatmentMethod alloc]initWithTitle:title andAlias:alias]];
        
    }
    return newsArray;
}

- (NSString *) retrieveNewsInfoData: (NSString *) alias
{
    NSString *info = nil;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", getNewsDataInfoURL, alias]; // makes the urlstring where the info is stored
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.jsonArray =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    //Loop through json Array
    for (int i=0; i<self.jsonArray.count; i++) {
        info = [[self.jsonArray objectAtIndex:i] objectForKey:(@"introtext")];
        
    }
    return info;
}







@end
