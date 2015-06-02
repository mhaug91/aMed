//
//  CalendarViewController.m
//  aMed
//
//  Created by MacBarhaug on 07.05.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "CalendarViewController.h"

static NSString *eventCellIdentifier = @"eventCellID";


@interface CalendarViewController (){
    NSMutableDictionary *eventsByDate; // Events sorted by date
    __weak IBOutlet UITableView *tableView;
}

@end




@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    @try {
        self.rd = [[RetrieveData alloc] init];
        self.eventArray = [self.rd retrieveEvents];
    }
    @catch (NSException *exception) {
    }
    [self.navigationController.navigationBar setTranslucent:NO];

    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(infoPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = infoButtonItem;

    
    self.calendar = [JTCalendar new];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 1.;
    }
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    [self createEvents];
    

}

// This method is only in use when viewDidLoad doesnt retrieve data from database.
- (void)viewDidAppear:(BOOL)animated

{
    
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

    [super viewDidAppear:animated];
    [self.calendar reloadData]; // Must be call in viewDidAppear
    
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

/**
 *  Takes u back to today's date
 */
- (IBAction)didGoTodayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
}


/**
 *  Change between week and month view
 */
- (IBAction)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
}


/**
 *  Transition between week an month views
 * The height of the content view is changed between them.
 */
- (void)transitionExample
{
    CGFloat newHeight = 300; // Used to set the new height of the content view.
    if(self.calendar.calendarAppearance.isWeekMode){
        
        newHeight = 75.;
        
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight; // Sets the constant of the calendarContentViewHeight constraint declared in header. 
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
}


 /**
 *  Checks if a date has a event
 *
 *  @param calendar our calendar.
 *  @param date
 *
 *  @return Yes if it has events. No if it doesn't.
 */
- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
   
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    return YES; /// Return NO
}

/**
 *  Runs when a date is selected
 *
 *  @param calendar our calendar
 *  @param date     selected date
 *  @note Does nothing if there's no events that date
 */
- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    if([self calendarHaveEvent:calendar date:date]){
        [self displayEventsTable:date];
        //[self performSegueWithIdentifier:@"pushSelectedDate" sender:date];
        
    }
}







- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}

/**
 *  Runs when infoButton is pressed
 *
 *  @param sender infobutton
 */
- (void) infoPressed:(id) sender{
    NSString *title = @"Kalender";
    NSString *info = @"Arrangements kalender";
    [[[UIAlertView alloc] initWithTitle:title message:info delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

/**
 *  Method for finding an event on date.
 *
 *  @param date selected date
 *
 *  @return the first event that has startdate matching selected date
 *  @note This method returns only ONE event.
 */
- (Events *) findEventForDate:(NSString *) date{
    Events *event = nil;
    NSString *dateString;
    for(int i=0; i<self.eventArray.count; ++i){
        event = [self.eventArray objectAtIndex:i];
        dateString = [event.start_date substringToIndex:10];
        if([dateString isEqualToString:date]){
            event = [self.eventArray objectAtIndex:i];
            return event;
        }
    }
    return nil;

}

/**
 *  Fills an array with events with the same event id.
 */
-(void) filterSameEvents:(NSInteger) eventId{
    self.filterArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.eventArray.count; i++) {
        Events *e = nil;
        e = [self.eventArray objectAtIndex:i];
        if (eventId == e.event_id) {
            [self.filterArray addObject:e];
        }
    }
}

/**
 *  creates events.
 Takes the events from the events array and fills an events by date- dictionary.
 The dictionary is used to display the events on the right date in the calendar.
 */
- (void)createEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < self.eventArray.count; ++i){ // Loops through the events array
        Events *e = nil;
        e = [self.eventArray objectAtIndex:i];
        
        NSString *dateString = e.start_date; // Fetches the startdate
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *randomDate = [dateFormat dateFromString:dateString]; // Changes the format of the startdate of the event
        
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:randomDate]; // Adds object to the events by date- dictionary.
        
    }
}

- (void) displayEventsTable:(NSDate *) date{
    NSString *dateKey = [[self dateFormatter] stringFromDate:date]; // Retrieves dateString from date selected.
    
    NSArray *events = eventsByDate[dateKey];                    // Finds all events for that dateString
    NSLog(@"Date: %@ - %ld events", date, (unsigned long)[events count]);
    // Continue this later.
    self.numberOfEventsForSelectedDate = events.count;
}


#pragma mark - table view delegate

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return @"Arrangementer";
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    //self.numberOfEventsForSelectedDate = 1;
    return self.numberOfEventsForSelectedDate;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self->tableView dequeueReusableCellWithIdentifier:
                             eventCellIdentifier];
    //tableview.backgroundView.textInputContextIdentifier
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:eventCellIdentifier];
    }
    cell.textLabel.text = @"Sett inn arrangement";
    return cell;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)date {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if([[segue identifier] isEqualToString:@"pushSelectedDate"]){ // check if the segue matches the one in the storyboard. 
        NSString *dateKey = [[self dateFormatter] stringFromDate:date]; // Retrieves dateString from date selected.
        
        /**
         *  The code uncommented is required if we want to display all the events on a selected date.
         *  Our solution just displays 1 event a day. 
         *  To fix this we need to create a new view beneath our calendar that displays a list of the:
         *  eventsByDate[dateKey];
         */
        /*NSArray *events = eventsByDate[dateKey];                    // Finds all events for that dateString
        NSLog(@"Date: %@ - %ld events", sender, [events count]);            // Logs it
         */
        Events *eventOnDate = [self findEventForDate:dateKey];              // Finds event for that day
        SelectedEventViewController *destViewController = segue.destinationViewController; // Getting new view controller
        destViewController.navigationItem.title = @"event"; // Setting title in the navigation bar of next view
        [destViewController getEventObject:eventOnDate];    // Sets the eventobject in the destination view controller. (See Selected Event View Controller.
        
        [self filterSameEvents:eventOnDate.event_id];
        int dayIndex=1;                   // Used to set the day of the event in the next view. One event can have many days.
        for(Events *e in self.filterArray){         // Loops through the events in the filtered array.
            if (e.start_date == eventOnDate.start_date ) { // if the event in filtered array has same date as selected...
                [destViewController setDay:dayIndex];           // Set the dayIndex
            }
            ++dayIndex;

        }

        
    }
}

@end
