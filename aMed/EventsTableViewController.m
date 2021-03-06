//
//  EventsTableViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 21/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "EventsTableViewController.h"

#define getEventsURL @"http://www.amed.no/AmedApplication/getEvents.php"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *eventID = @"eventID";
NSInteger COURSE = 66; // blue
NSInteger FESTIVAL = 71; //red
NSInteger EXHIBITION = 70; //green
NSInteger EXHIBITION_2 = 86; //green

/**
 *  This controller shows a tableView with a list of all upcomming events.
 */


@interface EventsTableViewController ()

@end

@implementation EventsTableViewController


//Retrieves data from database, uses exception handling incase of no network connection.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initiating the activity indicator and set it as subview. Appears as a “gear” that is spinning in the middle of the screen.
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.spinner];
    [self.spinner setColor:UIColorFromRGB(0x602167)];
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.spinner startAnimating];
    [self.navigationController.navigationBar setTranslucent:NO];

    @try {
        self.rd = [[RetrieveData alloc] init];
        self.eventArray = [self.rd retrieveEvents];
    }
    @catch (NSException *exception) {
    }
    [self filterArrayID];
   
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filterArray count];
}

//Adds content to the table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventID" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:eventID];
    }
    
    Events *event = nil;
    event = [self.filterArray objectAtIndex:indexPath.row];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
    cell.textLabel.font = font;
    
    //Text label will be the name of the event.
    
    NSString *start_date = event.start_date;
    NSDate *formatted = [[self dateFormatterWithTime] dateFromString:start_date];
    NSString *formattedDateNorwegian = [[self dateFormatterNorwegianWithTime] stringFromDate:formatted];
    cell.textLabel.text = event.summary;
    cell.detailTextLabel.text= formattedDateNorwegian;

    //Sets image to a spesific color. Depending on the type of event.
    if(event.category_id == COURSE){
        cell.imageView.image = [UIImage imageNamed:@"event_blue"];
    } else if (event.category_id == FESTIVAL){
        cell.imageView.image = [UIImage imageNamed:@"event_red"];
    } else if (event.category_id == EXHIBITION || event.category_id == EXHIBITION_2){
        cell.imageView.image = [UIImage imageNamed:@"event_green"];
    } else{
        cell.imageView.image = [UIImage imageNamed:@"event_green"];
    }


    
    
    
    return cell;
}

//Method for filtering the events. Adds the first day of the event to filterArray.
-(void) filterArrayID{
    int k = 0;
    self.filterArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.eventArray.count; i++) {
        Events *method = nil;
        Events *method2 = nil;
        method = [self.eventArray objectAtIndex:i];
        method2 = [self.eventArray objectAtIndex:(i-k)];
        if (i == 0 || method.event_id != method2.event_id) {
            [self.filterArray addObject:method];
        }
        k = 1;
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"PushSelectedEvent"]){
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = CGPointMake(160, 240);
        [self.view addSubview:spinner];
        [spinner startAnimating];
        NSIndexPath *indexPath = nil;
        Events *method = nil;
        NSString *title = method.summary;
        
        NSLog(@"metode overgang");
        indexPath = [self.tableView indexPathForCell:sender];
        method = [self.filterArray objectAtIndex:indexPath.row];
        
        SelectedEventViewController *destViewController = segue.destinationViewController; // Getting new view controller
        destViewController.navigationItem.title = title; // Setting title in the navigation bar of next view
        [destViewController getEventObject:method]; // Passing object to ThreamentInfoController
            [spinner stopAnimating];

    }
}


@end
