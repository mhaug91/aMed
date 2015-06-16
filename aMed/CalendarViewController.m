//
//  CalendarViewController.m
//  aMed
//
//  Created by MacBarhaug on 07.05.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "CalendarViewController.h"

static NSString *eventCellIdentifier = @"eventCellID";
/*
NSInteger COURSE = 66; // blue
NSInteger FESTIVAL = 71; //red
NSInteger EXHIBITION = 70; //green
NSInteger EXHIBITION_2 = 86; //green
*/
@interface CalendarViewController (){
    NSMutableDictionary *eventsByDate; // Events sorted by date
    __weak IBOutlet UITableView *tableView;
}

@end




@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eventsOnSelectedDate = [[NSArray alloc] init];
    self.eventArray = [[NSMutableArray alloc] init];
    @try {
        self.rd = [[RetrieveData alloc] init];
        if(!([self.rd.retrieveEvents isEqual:@""])){
            self.eventArray = [self.rd retrieveEvents];
        }
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
    [self createEventsDictionary];
    

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
 *  Transition between week an month mode
 * The height of the content view is changed between the two modes.
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
 *  Checks if a date has an event
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
    
    return NO; /// Return NO
}

#pragma mark My methods
/**
 *  Runs when a date is selected. If it has one or more events: display a table of the event(s)
 *
 *  @param calendar our calendar
 *  @param date     selected date
 *  @note Does nothing if there's no events that date
 */
- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
        [self displayEventsTableOnDate:date];
        //[self performSegueWithIdentifier:@"pushSelectedDate" sender:date];
}







/**
 *  Method for finding an event on date.
 *
 *  @param date selected date
 *
 *  @return the first event that has startdate matching selected date
 *  @note This method returns only ONE event and is from the 1.0 Version. NOT in use in version 1.1.
 *
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
 */

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
 *  creates a dictionary of events.
 Takes the events from the events array and fills an events by date- dictionary.
 The dictionary is used to display the events on the right date in the calendar.
 */
- (void)createEventsDictionary
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
        
        [eventsByDate[key] addObject:e]; // Adds object to the events by date- dictionary.
        
    }
}

/**
 *  Displays a table of events on a selected date
 *
 *  @param date The date selected by the user
 */
- (void) displayEventsTableOnDate:(NSDate *) date{
    NSString *dateKey = [[self dateFormatter] stringFromDate:date]; // Retrieves dateString from date selected.
    
    /**
     *  Her er feilen. Kallet til eventsByDate(dateKey) returnerer en tabell med datoer, ikke events som jeg først trodde.
     */
    self.eventsOnSelectedDate = eventsByDate[dateKey]; // Finds all events for that dateString and stores in an array
    
    self.numberOfEventsForSelectedDate = self.eventsOnSelectedDate.count;
    NSMutableArray *tempArray = [[NSMutableArray alloc]init]; // Makes a new temporarily array to help us display the events in our tableview.
    for (int i=0; i<self.eventsOnSelectedDate.count;i++) {
        [tempArray addObject:[NSIndexPath indexPathForRow:i inSection:0]]; //Fills the temp array.
    }
    NSLog(@"Date: %@ - %ld events", date, (unsigned long)[self.eventsOnSelectedDate count]);
    /**
     *  This part helps us remove all rows from the tableview. We set the flagvariable: cleartable, to Yes.
     *  Then we reload data. The numberOfRowsInSection method will be called and number of rows will be set
     *  to 0. All rows will then be removed from the tableview.
     */
    self.clearTable = YES;
    [tableView reloadData];
    self.clearTable = NO;
    
    /**
     *  This part fills the tableview with new rows.
     */
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:(NSArray *)tempArray withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
}


#pragma mark - table view delegate

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return @"Arrangementer";
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if(self.clearTable){ // If the flagvariable: cleartable, is set to YES we set the number of rows to 0 and all rows will be removed from the tableview.
        return 0;
    }
    return self.numberOfEventsForSelectedDate;

    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* Bruker egentlig ikke denne cella. Den kommer ikke til å vises. */
    UITableViewCell *cell = [self->tableView dequeueReusableCellWithIdentifier:
                             eventCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:eventCellIdentifier];
    }
    //Events *eventOnSelectedDate = [self.eventsOnSelectedDate objectAtIndex:indexPath.row];
    //cell.textLabel.text = eventOnSelectedDate.description;
    cell.textLabel.text=@"Event her";
    return cell;
}

/*
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedEventCell = [self->tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"PushEventInfo" sender:selectedEventCell];
}
*/




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)selectedEventCell {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if([[segue identifier] isEqualToString:@"PushEventInfo"]){ // check if the segue matches the one in the storyboard.
        NSIndexPath *indexPath = [tableView indexPathForCell:selectedEventCell]; // Fetch the indexpath selected by the user.
        
        //Events *selectedEvent = [self.eventsOnSelectedDate objectAtIndex:indexPath.row]; // Fetch events object from newsarray at the indexpath's row.
        //SelectedEventViewController *destViewController = segue.destinationViewController;  // Setting the destination view controller
        //NSString *dateKey = [[self dateFormatter] stringFromDate:date]; // Retrieves dateString from date selected.
        
        /**
         *  The code uncommented is required if we want to display all the events on a selected date.
         *  Our solution just displays 1 event a day. 
         *  To fix this we need to create a new view beneath our calendar that displays a list of the:
         *  eventsByDate[dateKey];
         */
        /*NSArray *events = eventsByDate[dateKey];                    // Finds all events for that dateString
        NSLog(@"Date: %@ - %ld events", sender, [events count]);            // Logs it
         */
        //Events *eventOnDate = [self findEventForDate:dateKey];              // Finds event for that day
        SelectedEventViewController *destViewController = segue.destinationViewController; // Getting new view controller
        destViewController.navigationItem.title = @"event"; // Setting title in the navigation bar of next view
        //[destViewController getEventObject:selectedEvent];    // Sets the eventobject in the destination view controller. (See Selected Event View Controller.
        /*
        [self filterSameEvents:selectedEvent.event_id];
        int dayIndex=1;                   // Used to set the day of the event in the next view. One event can have many days.
        for(Events *e in self.filterArray){         // Loops through the events in the filtered array.
            if (e.start_date == selectedEvent.start_date ) { // if the event in filtered array has same date as selected...
                [destViewController setDay:dayIndex];           // Set the dayIndex
            }
            ++dayIndex;

        }
         */

        
    }
}


@end
