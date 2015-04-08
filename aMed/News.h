//
//  News.h
//  aMed
//
//  Created by MacBarhaug on 08.04.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *alias;
@property(strong, nonatomic) NSString *introText;

- (id) initWithTitle: (NSString *) title andAlias: (NSString *) alias andIntroText: (NSString *) iText;
- (id) initWithTitle: (NSString *) title andAlias: (NSString *) alias;

@end
