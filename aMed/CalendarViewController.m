//
//  CalendarViewController.m
//  aMed
//
//  Created by MacBarhaug on 07.05.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "CalendarViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



static NSString *eventCellIdentifier = @"eventCell";


@interface CalendarViewController (){
    NSMutableDictionary *eventsByDate; // Events sorted by date
    __weak IBOutlet UITableView *tableView;
}

@end




@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.COURSE=66;
    self.FESTIVAL=71;
    self.EXHIBITION=70;
    self.EXHIBITION_2=86;
    self.eventsOnSelectedDate = [[NSArray alloc] init];
    self.eventArray = [[NSMutableArray alloc] init];
    
    /* The activity indicator. Appears as a “gear” that is spinning in the middle of the screen. */
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.spinner];
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.spinner setColor:UIColorFromRGB(0x602167)];
    [self.spinner startAnimating];
    
    [self.navigationController.navigationBar setTranslucent:NO];
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
}

// This method is only in use when viewDidLoad doesnt retrieve data from database.
- (void)viewDidAppear:(BOOL)animated

{
    
   
    @try {
        self.rd = [[RetrieveData alloc] init];
        if(!([self.rd.retrieveEvents isEqual:@""])){
            self.eventArray = [self.rd retrieveEvents];
        }
    }
    
    @catch (NSException *exception) {
    }
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
    //[self didGoTodayTouch];
    [super viewDidAppear:animated];
    //[self.calendar reloadData]; // Must be called in viewDidAppear
    // Uncertain how this works. But when called it will remove some of the dots marking that the date has some event(s)!
    [self createEventsDictionary];
    //[self.calendar setCurrentDate:[NSDate date]];
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

#pragma mark Buttons
/**
 *  Runs when infoButton is pressed
 *
 *  @param sender infobutton
 *  @warning not in use in version 1.1
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

#pragma mark dateformatters

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}

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

#pragma mark Transition
/**
 *  Transition between week an month mode
 * The height of the content view is changed between the two modes.
 */
- (void)transitionExample
{
    CGFloat newHeight = 200; // Used to set the new height of the content view.
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

#pragma mark event methods
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
 *  Method for finding one event on a date. NOT IN USE.
 *
 *  @param date selected date
 *
 *  @return the first event that has startdate matching selected date
 *  @note This method returns only ONE event and is from the 1.0 Version.
 *  @warning NOT IN USE
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
    if(self.numberOfEventsForSelectedDate>0){
        return @"Hendelser";
        
    } else{
        return @"Ingen hendelser";
    }
    
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
        /* Lager derfor ei ny celle. */
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:eventCellIdentifier];
    }
    Events *eventOnSelectedDate = [self.eventsOnSelectedDate objectAtIndex:indexPath.row];
    NSString *start_date = eventOnSelectedDate.start_date;
    NSDate *formatted = [[self dateFormatterWithTime] dateFromString:start_date];
    NSString *formattedDateNorwegian = [[self dateFormatterNorwegianWithTime] stringFromDate:formatted];
    cell.textLabel.text = eventOnSelectedDate.summary;
    cell.detailTextLabel.text = formattedDateNorwegian;
    //cell.textLabel
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
    cell.textLabel.font = font;
    //Sets image to a spesific color. Depending on the type of event.
    if(eventOnSelectedDate.category_id == self.COURSE){
        cell.imageView.image = [UIImage imageNamed:@"event_blue"];
    } else if (eventOnSelectedDate.category_id == self.FESTIVAL){
        cell.imageView.image = [UIImage imageNamed:@"event_red"];
    } else if(eventOnSelectedDate.category_id == self.EXHIBITION || eventOnSelectedDate.category_id == self.EXHIBITION_2){
        cell.imageView.image = [UIImage imageNamed:@"event_green"];
    } else{
        cell.imageView.image = [UIImage imageNamed:@"event_green"];
    }
    return cell;
}


- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedEventCell = [self->tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"PushEventInfo" sender:selectedEventCell];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)selectedEventCell {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"PushEventInfo"]){ // check if the segue matches the one in the storyboard.
        
        NSIndexPath *indexPath = [tableView indexPathForCell:selectedEventCell]; // Fetch the indexpath selected by the user.
        
        Events *selectedEvent = [self.eventsOnSelectedDate objectAtIndex:indexPath.row]; // Fetch events object from newsarray at the indexpath's row.
        SelectedEventViewController *destViewController = segue.destinationViewController;  // Setting the destination view controller
        destViewController.navigationItem.title = @"event"; // Setting title in the navigation bar of next view
        [destViewController getEventObject:selectedEvent];    // Sets the eventobject in the destination view controller. (See Selected Event View Controller).
        /* Here we find the associated events with the one selected. */
        [self filterSameEvents:selectedEvent.event_id];
        int dayIndex=1;                   // Used to set the day of the event in the next view. One event can have many days.
        for(Events *e in self.filterArray){         // Loops through the events in the filtered array.
            if (e.start_date == selectedEvent.start_date ) { // if the event in filtered array has same date as selected...
                [destViewController setDay:dayIndex];           // Set the dayIndex
            }
            ++dayIndex;

        }

        
    }
}


@end
