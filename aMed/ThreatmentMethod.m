//
//  ThreatmentMetod.m
//  aMed
//
//  Created by MacBarhaug on 23.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "ThreatmentMethod.h"

@implementation ThreatmentMethod

- (id) initWithTitle: (NSString *) title andAlias: (NSString *) alias andIntroText: (NSString *) iText{
    self = [super init];
    if(self){
        self.title = title;
        self.alias = alias;
        self.introText = iText;
    }
    return self;
}

- (id) initWithTitle: (NSString *) title andAlias: (NSString *) alias{
    self = [super init];
    if(self){
        self.title = title;
        self.alias = alias;
    }
    return self;
}

@end
