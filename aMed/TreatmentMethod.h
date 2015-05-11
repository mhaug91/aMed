//
//  ThreatmentMetod.h
//  aMed
//
//  Created by MacBarhaug on 23.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreatmentMethod : NSObject

@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *alias;
@property(strong, nonatomic) NSString *introText;

- (id) initWithTitle: (NSString *) title andAlias: (NSString *) alias andIntroText: (NSString *) iText;
- (id) initWithTitle: (NSString *) title andAlias: (NSString *) alias;

- (id) initWithTitle: (NSString *) title;

@end
