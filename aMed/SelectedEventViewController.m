//
//  SelectedEventViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 22/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "SelectedEventViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

NSInteger sCOURSE = 66; // blue
NSInteger sFESTIVAL = 71; //red
NSInteger sEXHIBITION = 70; //green
NSInteger sEXHIBITION_2 = 86; //green

@interface SelectedEventViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SelectedEventViewController

GMSMapView *mapView_;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    @try {
        self.rd = [[RetrieveData alloc] init];
        self.eventArray = [self.rd retrieveEvents];
    }
    @catch (NSException *exception) {
        
    }

    
    [self filterAssociated];
    [self filterSameEvents];
    
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
    
    self.title = self.selectedEvent.summary;
    [self mapView];
    
    self.tableView = [self makeTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TreatmentMethods"];
    [self.view addSubview:self.tableView];
}

- (void) viewDidAppear:(BOOL)animated{
    @try {
        if (self.eventArray.count == 0) {
            self.rd = [[RetrieveData alloc] init];
            self.eventArray = [self.rd retrieveEvents];
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
        [self.view setNeedsDisplay];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getEventObject:(id)eventObject{
    self.selectedEvent = eventObject;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( 0 == buttonIndex ){ //cancel button
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    } else if ( 1 == buttonIndex ){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
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
    if(self.day == 0){
        self.day = 1;
    }
    NSString *summary = self.selectedEvent.summary;
    NSString *summaryDay = [NSString stringWithFormat:@"%@, dag %d", summary, self.day];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake
                      (self.view.frame.size.width/3, 20.0, (self.view.frame.size.width/1.5), 80)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ArialMT" size:(16.0)];
    [self.contentView addSubview:label];
    label.text = summaryDay;
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
    CGFloat height = number+20;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    tableView.rowHeight = 40;
    tableView.sectionFooterHeight = 10;
    tableView.sectionHeaderHeight = 20;
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
    
    [self daySubEvents];
    NSString *title = [NSString stringWithFormat:@"%@, dag %@", method.summary, self.daySub[indexPath.row]];
    NSString *date = [NSString stringWithFormat:@"%@", method.start_date];
    
    
    if(method.category_id == sCOURSE){
        cell.imageView.image = [UIImage imageNamed:@"event_blue"];
    } else if (method.category_id == sFESTIVAL){
        cell.imageView.image = [UIImage imageNamed:@"event_red"];
    } else if (method.category_id == sEXHIBITION || method.category_id == sEXHIBITION_2){
        cell.imageView.image = [UIImage imageNamed:@"event_green"];
    }
    
    
    cell.textLabel.numberOfLines = 2;
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
    cell.textLabel.font = font;
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.font = font;
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = date;
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if(self.associatedArray.count != 0){
        return @"Øvrige dager knyttet til arrangementet";
    }
    else{
        return @"Ingen tilknyttede arrangement funnet";
    }
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    Events *method = nil;
    method = [self.associatedArray objectAtIndex:indexPath.row];
    self.selectedEvent = method;
    
    for (int i = 0; i<self.filterArray.count; i++) {
        Events *method2 = [self.filterArray objectAtIndex:i];
        if ([self.selectedEvent.start_date isEqualToString:method2.start_date]) {
            self.day = i + 1;
        }
    }
    [self viewDidLoad];
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
-(void) filterSameEvents{
    self.filterArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.eventArray.count; i++) {
        Events *method = nil;
        method = [self.eventArray objectAtIndex:i];
        if (self.selectedEvent.event_id == method.event_id) {
            [self.filterArray addObject:method];
        }
    }
}
-(void) daySubEvents{
    self.daySub = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.filterArray.count; i++) {
        if (i+1 != self.day) {
            [self.daySub addObject:[NSNumber numberWithInteger:i+1]];
        }
    }
}

@end
