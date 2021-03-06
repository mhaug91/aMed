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

/**
 *  This view controller displays the selected event the user has selected in EventsTableViewController.
 */

@interface SelectedEventViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SelectedEventViewController

//Initializing mapView.
GMSMapView *mapView_;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Initiating the activity indicator and set it as subview. Appears as a “gear” that is spinning in the middle of the screen.
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.spinner];
    [self.spinner setColor:UIColorFromRGB(0x602167)];
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
    [self.spinner startAnimating];
    //Retrieves data from database, uses exception handling incase of no network connection.
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
    [self.view addSubview:self.tableView];
    
}

// This method is only in use when viewDidLoad doesnt retrieve data from database.
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
    [self.spinner stopAnimating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark dateformatters
- (NSDateFormatter *)dateFormatterWithTime
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    return dateFormatter;
}

- (NSDateFormatter *)dateFormatterNorwegianWithTime
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy, HH:mm";
    }
    
    return dateFormatter;
}

//Getting the event Object that is selected.
- (void) getEventObject:(id)eventObject{
    self.selectedEvent = eventObject;
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


#pragma mark - labels


/**
 *  All the labels below (from one to ten and mapLabel), are labels that display information about the event.
 *  The labels either display a static string or a string from the database.
 */

-(void) firstLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(8.0, 20.0, self.view.frame.size.width/3, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(18.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Sammendrag: "];
    [label sizeToFit];
}


-(void) secondLabel{
    if(self.day == 0){
        self.day = 1;
    }
    NSString *summary = self.selectedEvent.summary;
    //NSString *summaryDay = [NSString stringWithFormat:@"%@, dag %d", summary, self.day];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake
                      ((self.view.frame.size.width/3)-8, 20.0, (self.view.frame.size.width/1.5), 80)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(16.0)];
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
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(16.0)];
    [self.contentView addSubview:label];
    label.text = summary;
    label.numberOfLines = 0;
}

-(void) thirdLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(8.0, 105.0, self.view.frame.size.width/3, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(18.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Sted: "];
    [label sizeToFit];
}

-(void) fourthLabel{
    NSString *title = self.selectedEvent.location.title;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake
                      ((self.view.frame.size.width/3-8), 105.0, (self.view.frame.size.width/1.5), 80)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(16.0)];
    [self.contentView addSubview:label];
    if([title isEqual:[NSNull null]] || [title isEqualToString:@""]){
        title = @"--";
    }
    label.text = title;
    label.numberOfLines = 0;
    [label sizeToFit];
}

-(void) fifthLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(8.0, 165.0, self.view.frame.size.width/3, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(18.0)];
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
                      ((self.view.frame.size.width/3-8), 165.0, (self.view.frame.size.width/1.5), 80)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(16.0)];
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
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(8.0, 245.0, self.view.frame.size.width/3, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(18.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Startdato: "];
    [label sizeToFit];
}

-(void) eigthLabel{
    NSString *start_date = self.selectedEvent.start_date;
    NSDate *formatted = [[self dateFormatterWithTime] dateFromString:start_date];
    NSString *formattedDateNorwegian = [[self dateFormatterNorwegianWithTime] stringFromDate:formatted];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake
                      ((self.view.frame.size.width/3-8), 245.0, (self.view.frame.size.width/1.5), 40)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(16.0)];
    [self.contentView addSubview:label];
    if([start_date isEqual:[NSNull null]] || [start_date isEqualToString:@""]){
        start_date = @"--";
    }
    label.text = formattedDateNorwegian;
    label.numberOfLines = 0;
    [label sizeToFit];
}

-(void) ninthLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(8.0, 285.0, self.view.frame.size.width/3, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(18.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Sluttdato: "];
    [label sizeToFit];
}

-(void) tenthLabel{
    NSString *endDate = self.selectedEvent.end_date;
    NSDate *formatted = [[self dateFormatterWithTime] dateFromString:endDate];
    NSString *formattedDateNorwegian = [[self dateFormatterNorwegianWithTime] stringFromDate:formatted];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake
                      ((self.view.frame.size.width/3-8), 285.0, (self.view.frame.size.width/1.5), 40)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(16.0)];
    [self.contentView addSubview:label];
    if([endDate isEqual:[NSNull null]] || [endDate isEqualToString:@""]){
        endDate = @"--";
    }
    label.text = formattedDateNorwegian;
    label.numberOfLines = 0;
    [label sizeToFit];
}

-(void) mapLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(8.0, 325.0, self.view.frame.size.width/3, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(18.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Kart: "];
    [label sizeToFit];
}


#pragma mark - other views
//Method for generating the map that displays the location of the event.
-(void) mapView{
    
    //Putting title and coordinates into variables.
    NSString *title = self.selectedEvent.location.title;
    NSNumber *geoLat = self.selectedEvent.location.geo_latitude;
    double doubleLat = [geoLat doubleValue];
    
    NSNumber *geoLong = self.selectedEvent.location.geo_longitude;
    double doubleLong = [geoLong doubleValue];
    
    //If the event doesn't have any coordinates, sets them to 0.
    if ([title isEqual:[NSNull null]] || [title isEqualToString:@""]) {
        title = @"--";
        doubleLat = 0,0;
        doubleLong = 0,0;
    }
    //Position and zoom of camera.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:doubleLat
                                                            longitude:doubleLong
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(10.0, 345, self.view.frame.size.width-20, 150.0) camera:camera];
    mapView_.settings.zoomGestures = YES;
    
    //Adds marker on the map, this marker uses the locations coordinates.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(doubleLat, doubleLong);
    marker.title = title;
    marker.map = mapView_;
    
    [self.view addSubview: mapView_];
    
    
}

//Creating tableView that contains the associated events.
-(UITableView *)makeTableView
{
    double number = 0;
    CGFloat viewHeight = 920; // Float variable uset to determine the height of the entire view
    for (int i = 0 ; i<self.associatedArray.count; i++) {
        number += 40;
        viewHeight+=40; // For each table cell the view has to grow 40 points to fit all content
    }
    
    CGFloat x = 0;
    CGFloat y = 500;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = number+20;
    self.viewHeight.constant = viewHeight; // Sets the height of the view.
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

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [self.associatedArray count];
    
}
/*
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    // ignore the style argument, use our own to override
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        // If you need any further customization
    }
    return self;
}
 */


/**
 * @warning - this method will not be able create cells with cellstyle: subtitle since the registerclass method
 * sends the default cellstyle by default
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
    }
    
    Events *event = [self.associatedArray objectAtIndex:indexPath.row];
    [self daySubEvents];
    //NSString *title = [NSString stringWithFormat:@"%@, dag %@", method.summary, self.daySub[indexPath.row]];
    //NSString *date = [NSString stringWithFormat:@"%@", method.start_date];
    
    
    NSString *start_date = event.start_date;
    NSDate *formatted = [[self dateFormatterWithTime] dateFromString:start_date];
    NSString *formattedDateNorwegian = [[self dateFormatterNorwegianWithTime] stringFromDate:formatted];
    
    //NSString *text = [NSString stringWithFormat:@"dag %@, %@", self.daySub[indexPath.row], formattedDateNorwegian];
    /* text er utelatt fordi dagnr. på arrangementet blir feil. */
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
    
    cell.textLabel.font = font;
    cell.textLabel.text = formattedDateNorwegian;
    if(event.category_id == sCOURSE){
        cell.imageView.image = [UIImage imageNamed:@"event_blue"];
    } else if (event.category_id == sFESTIVAL){
        cell.imageView.image = [UIImage imageNamed:@"event_red"];
    } else if (event.category_id == sEXHIBITION || event.category_id == sEXHIBITION_2){
        cell.imageView.image = [UIImage imageNamed:@"event_green"];
    } else{
        cell.imageView.image = [UIImage imageNamed:@"event_green"];
    }
    
    
    return cell;
}

# pragma mark - table view delegates

//Setting title of tableview.
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if(self.associatedArray.count != 0){
        return @"Øvrige dager knyttet til arrangementet";
    }
    else{
        return @"Ingen tilknyttede arrangement funnet";
    }
}

/**
 *  Defines what will happen if a cell is pressed.
 *  If a cell is pressed it changed set value of self.day.
 */
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

#pragma mark - other methods

//Method for filtering associated events with the selected one.
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

//Adds all events with the same event id to the filterarray.
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

//Changes the self.daySub Variable depending on the event selected in the tableview.
-(void) daySubEvents{
    self.daySub = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.filterArray.count; i++) {
        if (i+1 != self.day) {
            [self.daySub addObject:[NSNumber numberWithInteger:i+1]];
        }
    }
}

@end
