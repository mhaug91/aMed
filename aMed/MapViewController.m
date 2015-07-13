//
//  MapViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 18/03/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "MapViewController.h"
#import "GeoCoding.h"
#import <GoogleMapsM4B/GoogleMaps.h>

#define getDataTherapistsURL @"http://www.amed.no/AmedApplication/getTherapists.php"

/**
 *  This is the controller used for showing therapists on a map.
 *  Map used in this application is Google Maps.
 */

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize gc;
BOOL firstLocationUpdate_;
GMSMapView *mapView_;




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    //Initialzing geocoding.
    gc = [[GeoCoding alloc]init];
    NSLog(@"Current identifier: %@", [[NSBundle mainBundle] bundleIdentifier]);
    //Retrieves data from database, uses exception handling incase of no network connection.
    @try {
        self.rd = [[RetrieveData alloc] init];
        self.therapists = [self.rd retrieveTherapists];
    }
    @catch (NSException *exception) {
        
    }
    
    //Info button in the top right corner of the screen.
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = infoButtonItem;

    //Loading Google maps into the map View.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:63.4187362
                                                            longitude:22.1 zoom:12];
    
    //Setting camera, compassbutton, zoom and users location to show on the map.
    mapView_= [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.myLocationButton = YES;
    
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    self.view = mapView_;
    
    

    //Enabling the map to get the users location
    mapView_.myLocationEnabled = YES;
    
    //Dispatching a queue to add markers of the therapists on the map
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for(Therapists *t in self.therapists){
            [self addMarker:t];
        }
    });
    
}

// This method is only in use when viewDidLoad doesnt retrieve data from database.
- (void) viewDidAppear:(BOOL)animated{
    @try {
        if(self.therapists.count == 0){
            self.rd = [[RetrieveData alloc] init];
            self.therapists = [self.rd retrieveTherapists];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                for(Therapists *t in self.therapists){
                    [self addMarker:t];
                }
            });
        }
    }
    @catch (NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ingen tilgang til nettverk"
                                                            message:@"Slå på nettverk inne på innstillinger for å få tilgang til innhold" delegate:self
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:@"Innstillinger", nil];
        [alertView show];
        NSLog(@"Exception:s %@", exception.reason);
    }
    @finally {

    }
}
/**
 *  Method for adding markers on the map.
 *
 *  Uses the therapists address and geocodes it into coordinates.
 */
- (void) addMarker:(Therapists *) t{
    NSDate *startTime = [NSDate date];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [NSThread sleepForTimeInterval:.22];
    
    //Dispating new queue for geocoding.
    dispatch_async(queue, ^{
        NSString *therapistAddress = [NSString stringWithFormat:@"%@, %@, %@", t.address.street, t.address.city, t.address.state];
        [gc geocodeAddress:therapistAddress];
        double lat = [[gc.geocode objectForKey:@"lat"] doubleValue];
        double lng = [[gc.geocode objectForKey:@"lng"] doubleValue];
        
        //Dispatching main queue. Initializes marker and gives it attributes.
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

//Getting therapist object of the selected therapist.
- (void) getTherapistObject:(id)therapistObject{
    self.currentTherapist = therapistObject;
}

//Describes what the info putting is going to to when pressed.
- (void) buttonAction:(id) sender{
    [self performSegueWithIdentifier:@"PushMapInfo" sender:sender];
}

//Updates users location.
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (!firstLocationUpdate_){
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:12];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// This method is only in use when viewDidLoad doesnt retrieve data from database.
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( 0 == buttonIndex ){ //cancel button
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    } else if ( 1 == buttonIndex ){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
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
