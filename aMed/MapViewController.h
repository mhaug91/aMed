//
//  MapViewController.h
//  aMed
//
//  Created by Kristofer Myhre on 18/03/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeoCoding.h"
#import <GoogleMapsM4B/GoogleMaps.h>
#import "Therapists.h"
#import "RetrieveData.h"
#import "MapInfoViewController.h"


@interface MapViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) GeoCoding *gc;

@property(strong, nonatomic) RetrieveData *rd;
@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *therapists;
@property(strong, nonatomic) Therapists *currentTherapist;

- (void) getTherapistObject: (id) therapistObject;
- (void) buttonAction: (id) sender;

@end
