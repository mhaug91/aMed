//
//  SelectedEventViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 22/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "SelectedEventViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SelectedEventViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SelectedEventViewController

GMSMapView *mapView_;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rd = [[RetrieveData alloc] init];
    self.eventArray = [self.rd retrieveEvents];
    
    [self filterAssociated];
    
    [self firstLabel];
    [self secondLabel];
    [self lineLabel];
    [self thirdLabel];
    [self fourthLabel];
    [self fifthLabel];
    [self sixthLabel];
    [self seventhLabel];
    [self eigthLabel];
    [self ninthLabel];
    [self tenthLabel];
    [self mapLabel];
    
    
    [self mapView];
    
    self.tableView = [self makeTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TreatmentMethods"];
    [self.view addSubview:self.tableView];
   // [[UILabel appearance] setBackgroundColor:[UIColor grayColor]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getEventObject:(id)eventObject{
    self.selectedEvent = eventObject;
}

-(void) firstLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 20.0, self.view.frame.size.width/3, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:(18.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Sammendrag: "];
    [label sizeToFit];
}

-(void) secondLabel{
    NSString *summary = self.selectedEvent.summary;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake
                      (self.view.frame.size.width/3, 20.0, (self.view.frame.size.width/1.5), 80)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ArialMT" size:(16.0)];
    [self.contentView addSubview:label];
    label.text = summary;
    label.numberOfLines = 0;
    [label sizeToFit];
}

-(void) lineLabel{
    NSString *summary = self.selectedEvent.summary;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake
                      (0.0 , 80.0, self.view.frame.size.width, 1)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor blackColor];
    //[[UILabel appearance] setBackgroundColor:UIColorFromRGB(0x602167)];
    label.font = [UIFont fontWithName:@"ArialMT" size:(16.0)];
    [self.contentView addSubview:label];
    label.text = summary;
    label.numberOfLines = 0;
}

-(void) thirdLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 105.0, self.view.frame.size.width/3, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:(18.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Sted: "];
    [label sizeToFit];
}

-(void) fourthLabel{
    NSString *title = self.selectedEvent.location.title;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake
                      (self.view.frame.size.width/3, 105.0, (self.view.frame.size.width/1.5), 80)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ArialMT" size:(16.0)];
    [self.contentView addSubview:label];
    if([title isEqual:[NSNull null]] || [title isEqualToString:@""]){
        title = @"--";
    }
    label.text = title;
    label.numberOfLines = 0;
    [label sizeToFit];
}

-(void) fifthLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 165.0, self.view.frame.size.width/3, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:(18.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Adresse: "];
    [label sizeToFit];
}

-(void) sixthLabel{
    NSString *street = self.selectedEvent.location.address.street;
    NSString *city = self.selectedEvent.location.address.city;
   // NSInteger post = self.selectedEvent.location.address.postcode;
    NSString *postCode = [NSString stringWithFormat:@"%ld",self.selectedEvent.location.address.postcode ];
    NSString *place = [NSString stringWithFormat:@"%@, %@", city, postCode];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake
                      (self.view.frame.size.width/3, 165.0, (self.view.frame.size.width/1.5), 80)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ArialMT" size:(16.0)];
    [self.contentView addSubview:label];
    label.numberOfLines = 0;
    
    if([street isEqual:[NSNull null]] || [street isEqualToString:@""]){
        street = @"--";
    }
    if ([city isEqual:[NSNull null]] || [city isEqualToString:@""]){
        place = @"--";
    }
    /*if ([postCode isEqual:[NSNull null]] || [postCode isEqualToString:@"0"]) {
        postCode = @"--";
        
    }*/
    label.text = [NSString stringWithFormat:@"%@\n\n%@", street, place];
    [label sizeToFit];
}
-(void) seventhLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 245.0, self.view.frame.size.width/3, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:(18.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Startdato: "];
    [label sizeToFit];
}

-(void) eigthLabel{
    NSString *startDate = self.selectedEvent.start_date;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake
                      (self.view.frame.size.width/3, 245.0, (self.view.frame.size.width/1.5), 40)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ArialMT" size:(16.0)];
    [self.contentView addSubview:label];
    if([startDate isEqual:[NSNull null]] || [startDate isEqualToString:@""]){
        startDate = @"--";
    }
    label.text = startDate;
    label.numberOfLines = 0;
    [label sizeToFit];
}

-(void) ninthLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 285.0, self.view.frame.size.width/3, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:(18.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Sluttdato: "];
    [label sizeToFit];
}

-(void) tenthLabel{
    NSString *endDate = self.selectedEvent.end_date;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake
                      (self.view.frame.size.width/3, 285.0, (self.view.frame.size.width/1.5), 40)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ArialMT" size:(16.0)];
    [self.contentView addSubview:label];
    if([endDate isEqual:[NSNull null]] || [endDate isEqualToString:@""]){
        endDate = @"--";
    }
    label.text = endDate;
    label.numberOfLines = 0;
    [label sizeToFit];
}

-(void) mapLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 325.0, self.view.frame.size.width/3, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:(18.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Kart: "];
    [label sizeToFit];
}

-(void) mapView{
    
    NSString *title = self.selectedEvent.location.title;
    NSNumber *geoLat = self.selectedEvent.location.geo_latitude;
    double doubleLat = [geoLat doubleValue];
    
    NSNumber *geoLong = self.selectedEvent.location.geo_longitude;
    double doubleLong = [geoLong doubleValue];
    
    if ([title isEqual:[NSNull null]] || [title isEqualToString:@""]) {
        title = @"--";
        doubleLat = 0,0;
        doubleLong = 0,0;
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:doubleLat
                                                            longitude:doubleLong
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(10.0, 345, self.view.frame.size.width-20, 150.0) camera:camera];
    mapView_.settings.zoomGestures = YES;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(doubleLat, doubleLong);
    marker.title = title;
    marker.map = mapView_;
    
    [self.view addSubview: mapView_];
    
    
}
-(UITableView *)makeTableView
{
    double number = 0;
    for (int i = 0 ; i<self.associatedArray.count; i++) {
        number += 40;
    }
    
    CGFloat x = 0;
    CGFloat y = 500;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = number;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    tableView.rowHeight = 40;
    tableView.sectionFooterHeight = 10;
    tableView.sectionHeaderHeight = 10;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    return tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [self.associatedArray count];
    
}


//Defines each cell of the table view.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TreatmentMethods";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Events *method = nil;
    
    method = [self.associatedArray objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@", method.summary];
    cell.textLabel.text = title;
    
    
    return cell;
}

- (void) filterAssociated{
    self.associatedArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<self.eventArray.count; i++) {
        
        Events *method = nil;
        
        method = [self.eventArray objectAtIndex:i];
        
        if (method.event_id == self.selectedEvent.event_id && ![method.start_date isEqualToString:self.selectedEvent.start_date]) {
            [self.associatedArray addObject:method];
        }
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}
*/
@end