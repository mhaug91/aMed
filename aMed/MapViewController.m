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
<<<<<<< HEAD
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = infoButtonItem;
=======
    /*UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self buttonAction: self.navigationItem.rightBarButtonItem];*/

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithTitle:@"Info" style:UIBarButtonItemStylePlain
                                               target:self action:@selector(buttonAction:)];

    
>>>>>>> Pikksaft
    //Laster inn kartet.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:63.4187362
                                                            longitude:22.1 zoom:12];
    
    mapView_= [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.myLocationButton = YES;
    CLLocation *l = mapView_.myLocation;
    
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    self.view = mapView_;
    
    for(Therapists *t in self.therapists){
            NSString *therapistAddress = [NSString stringWithFormat:@"%@, %@, %@", t.address.street, t.address.city, t.address.state];
        [gc geocodeAddress:therapistAddress];
        double lat = [[gc.geocode objectForKey:@"lat"] doubleValue];
        double lng = [[gc.geocode objectForKey:@"lng"] doubleValue];
        [NSThread sleepForTimeInterval:.2];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(lat, lng);
        marker.title = t.company;
        marker.snippet = t.address.street;
        marker.map = mapView_;
        
    }
    //Metode for å legge inn behandlere på kartet.
    /*NSArray *behandlere = @[@"Beate", @"Kjell", @"Knut"];
    double koordinater[6] = {-33.86, 151.20, -37.4849, 144.5747, -35.1827, 149.0727};
    NSInteger tall = 0;
    for (int i=0; i<behandlere.count; i++) {
            GMSMarker *marker = [[GMSMarker alloc]init];
            marker.position = CLLocationCoordinate2DMake(koordinater[tall], koordinater[1+tall]);
            marker.title = behandlere[i];
            marker.map = mapView_;
        tall+=2;
    }*/
//63.4187362,10.4387621
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
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
        
        NSIndexPath *indexPath = nil;

        //MapInfoViewController *destViewController = segue.destinationViewController; // Getting new view controller
        //destViewController.navigationItem.title = method.title; // Setting title in the navigation bar of next view
        
    }
}


@end
