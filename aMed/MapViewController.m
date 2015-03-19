//
//  MapViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 18/03/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController ()

@end

@implementation MapViewController

BOOL firstLocationUpdate_;
GMSMapView *mapView_;




- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    //Laster inn kartet.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
    
    mapView_= [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    self.view = mapView_;

    //Metode for å legge inn behandlere på kartet.
    NSArray *behandlere = @[@"Beate", @"Kjell", @"Knut"];
    double koordinater[6] = {-33.86, 151.20, -37.4849, 144.5747, -35.1827, 149.0727};
    NSInteger tall;
    for (int i=0; i<behandlere.count; i++) {
            GMSMarker *marker = [[GMSMarker alloc]init];
            marker.position = CLLocationCoordinate2DMake(koordinater[tall], koordinater[1+tall]);
            marker.title = behandlere[i];
            marker.map = mapView_;
        tall+=2;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (!firstLocationUpdate_){
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:14];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
