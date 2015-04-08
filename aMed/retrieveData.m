//
//  retrieveData.m
//  aMed
//
//  Created by MacBarhaug on 27.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "RetrieveData.h"

#define getDataThreatmentsURL @"http://www.amed.no/AmedApplication/getTreatmentmethods.php"
#define getDataThreatmentInfoURL @"http://www.amed.no/AmedApplication/getTreatmentmethodInfo.php?alias="

#define getNewsDataURL @"http://www.amed.no/AmedApplication/getNews.php"
#define getNewsInfoURL @"http://www.amed.no/AmedApplication/getNewsInfo.php?alias="




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





@end
