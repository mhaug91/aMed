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
#define getEventsURL @"http://www.amed.no/AmedApplication/getEvents.php"




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


-(NSMutableArray *) retrieveTherapists {
    
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
        }
        NSString *comment = [[self.jsonArray objectAtIndex:i] objectForKey:(@"cb_ajaxtekst")];
        NSString *treatmentMethodString = [[self.jsonArray objectAtIndex:i] objectForKey:(@"cb_behandlingsmetode6")];
        
        //Splitting string of treatment methods into an array.
        tr_methods = [treatmentMethodString componentsSeparatedByString:(@"|*|")];
        
        address = [[Address alloc] initWithStreet:street andCity:city andState:state andPostcode:&postcode andCountry:country];
        therapist = [[Therapists alloc] initWithFirstName:firstName andLastName:lastName andAvatar:avatar andWebsite:website andOccupation:occupation andCompany:company andAddress:address andPhone:&phone andComment:comment andTreatmentMethods:tr_methods andTreatmentMethodString:treatmentMethodString];
        
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
        [newsArray addObject:[[News alloc]initWithTitle:title andAlias:alias]];
        
    }
    return newsArray;
}

- (NSMutableArray *) retrieveEvents{
    NSInteger event_id, eventdetail_id, category_id, location_id, postcode;
    
    NSNumber *geo_longitude, *geo_latitude;
    
    NSURL *url = [NSURL URLWithString:getEventsURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    Events *event = [[Events alloc] init];
    Address *address = [[Address alloc] init];
    Location *location = [[Location alloc] init];
    NSMutableArray *eventArray = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i<self.jsonArray.count; i++) {
        //Address
        @try {
            postcode = [[[self.jsonArray objectAtIndex:i] objectForKey:(@"postcode")] integerValue];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception:s %@", exception.reason);
        }
        @finally {
            NSLog(@"finally");
        }
        NSString *street = [[self.jsonArray objectAtIndex:i] objectForKey:(@"street")];
        NSString *city = [[self.jsonArray objectAtIndex:i] objectForKey:(@"city")];
        //Location
        @try {
            location_id = [[[self.jsonArray objectAtIndex:i] objectForKey:(@"loc_id")] integerValue];
            double dob_longitude = [[[self.jsonArray objectAtIndex:i] objectForKey:(@"geolon")] doubleValue];
            geo_longitude = [NSNumber numberWithDouble:dob_longitude];
            double dob_latitude = [[[self.jsonArray objectAtIndex:i] objectForKey:(@"geolat")] doubleValue];
            geo_latitude = [NSNumber numberWithDouble:dob_latitude];

        }
        @catch (NSException *exception) {
            NSLog(@"Exception:h %@", exception.reason);
        }
        @finally {
            NSLog(@"Finally");
        }
        NSString *title = [[self.jsonArray objectAtIndex:i] objectForKey:(@"title")];
        //Events
        @try {
            event_id = [[[self.jsonArray objectAtIndex:i] objectForKey:(@"eventid")] integerValue];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception:event %@", exception.reason);
        }
        @finally {
        }
        @try {
            eventdetail_id = [[[self.jsonArray objectAtIndex:i] objectForKey:(@"eventdetail_id")] integerValue];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception:detail %@", exception.reason);
        }
        @finally {
        }
        @try {
            category_id = [[[self.jsonArray objectAtIndex:i] objectForKey:(@"catid")] integerValue];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception:category %@", exception.reason);
        }
        @finally {
        }
        NSString *start_date = [[self.jsonArray objectAtIndex:i] objectForKey:(@"startrepeat")];
        NSString *end_date = [[self.jsonArray objectAtIndex:i] objectForKey:(@"endrepeat")];
        NSString *summary = [[self.jsonArray objectAtIndex:i] objectForKey:(@"summary")];
        
        address = [[Address alloc] initWithStreet:street andCity:city andPostcode:&postcode];
        
        location = [[Location alloc] initWithLocation_id:&location_id andTitle:title andAddress:address andGeo_longitude:geo_longitude andGeo_latitude:geo_latitude];
        
        event = [[Events alloc]initWithEvent_id:&event_id andEventdetail_id:&eventdetail_id andStart_date:start_date andEnd_date:end_date andSummary:summary andLocation:location andCategory_id:&category_id];
        [eventArray addObject:event];
            
    }
    return eventArray;

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
