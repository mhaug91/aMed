//
//  GoogleLicenseViewController.h
//  aMed
//
//  Created by Kristofer Myhre on 28/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GoogleLicenseViewController : UIViewController

@property(nonatomic, strong) NSString *htmlString;
@property(strong, nonatomic) NSString *lisensString;
@property(strong, nonatomic) NSString *combinedString;

- (void) setWebView;

@end
