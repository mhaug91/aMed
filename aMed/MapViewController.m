//
//  MapViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 18/03/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "MapViewController.h"
#import "GeoCoding.h"
#import <GoogleMaps/GoogleMaps.h>

#define getDataTherapistsURL @"http://www.amed.no/AmedApplication/getTherapists.php"


@interface MapViewController ()

@end

@implementation MapViewController

@synthesize gc;
BOOL firstLocationUpdate_;
GMSMapView *mapView_;




- (void)viewDidLoad {
    [super viewDidLoad];

    gc = [[GeoCoding alloc]init];
    
    self.rd = [[RetrieveData alloc] init];
    self.therapists = [self.rd retrieveTherapists];
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = infoButtonItem;

    //Laster inn kartet.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:63.4187362
                                                            longitude:22.1 zoom:12];
    
    mapView_= [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.myLocationButton = YES;
    
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    self.view = mapView_;
    
    

    
    mapView_.myLocationEnabled = YES;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for(Therapists *t in self.therapists){
            [self addMarker:t];
        }
    });
    
}
- (void) viewDidAppear:(BOOL)animated{

}
- (void) addMarker:(Therapists *) t{
    NSDate *startTime = [NSDate date];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [NSThread sleepForTimeInterval:.2];
    dispatch_async(queue, ^{
        NSString *therapistAddress = [NSString stringWithFormat:@"%@, %@, %@", t.address.street, t.address.city, t.address.state];
        [gc geocodeAddress:therapistAddress];
        double lat = [[gc.geocode objectForKey:@"lat"] doubleValue];
        double lng = [[gc.geocode objectForKey:@"lng"] doubleValue];
        //[NSThread sleepForTimeInterval:.2];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(lat, lng);
            marker.title = t.company;
            marker.snippet = t.address.street;
            marker.map = mapView_;
        });
        
        NSDate *endTime = [NSDate date];
        NSLog(@"Completed in %f seconds", [endTime timeIntervalSinceDate:startTime]);
    });
}

- (void) getTherapistObject:(id)therapistObject{
    self.currentTherapist = therapistObject;
}

- (void) buttonAction:(id) sender{
    [self performSegueWithIdentifier:@"PushMapInfo" sender:sender];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (!firstLocationUpdate_){
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:12];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


                          

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"PushMapInfo"])
    {

        //MapInfoViewController *destViewController = segue.destinationViewController; // Getting new view controller
        //destViewController.navigationItem.title = method.title; // Setting title in the navigation bar of next view
        
    }
}


@end
