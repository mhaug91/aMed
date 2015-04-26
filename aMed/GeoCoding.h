//
//  GeoCoding.h
//  aMed
//
//  Created by Kristofer Myhre on 20/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoCoding : NSObject

- (id)init;
- (void)geocodeAddress:(NSString *)address;
- (void)fetchedData:(NSData *)data;
@property (nonatomic, strong) NSDictionary *geocode;


@end
