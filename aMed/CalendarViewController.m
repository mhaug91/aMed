//
//  CalendarViewController.m
//  aMed
//
//  Created by MacBarhaug on 07.05.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "CalendarViewController.h"



@interface CalendarViewController (){
    NSMutableDictionary *eventsByDate;
}

@end




@implementation CalendarViewController

- (void)viewDidLoad
{
    @try {
        self.rd = [[RetrieveData alloc] init];
        self.eventArray = [self.rd retrieveEvents];
    }
    @catch (NSException *exception) {
    }
    
    [super viewDidLoad];
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
    CGFloat newHeight = 300;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight;
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


- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
}

/**
 *  Runs when a date is selected
 *
 *  @param calendar the calendar in our storyboard
 *  @param date     selected date
 *  @note Does nothing if there's no events that date
 */
- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    if([self calendarHaveEvent:calendar date:date]){
        [self performSegueWithIdentifier:@"pushSelectedDate" sender:date];
        
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
 *  Method for finding event on date.
 *
 *  @param date selected date
 *
 *  @return the first event that has startdate matching selected date
 *  @note This method must be changed so that you can select between several events on a given date
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
 *  Filters events with the same event id.
 */
-(void) filterSameEvents{
    self.filterArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.eventArray.count; i++) {
        Events *e = nil;
        e = [self.eventArray objectAtIndex:i];
        if (self.event.event_id == e.event_id) {
            [self.filterArray addObject:e];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if([[segue identifier] isEqualToString:@"pushSelectedDate"]){ // check if the segue matches the one in the storyboard. 
        NSString *key = [[self dateFormatter] stringFromDate:sender];
        NSArray *events = eventsByDate[key];
        NSLog(@"Date: %@ - %ld events", sender, [events count]);
        self.event = [self findEventForDate:key];
        SelectedEventViewController *destViewController = segue.destinationViewController; // Getting new view controller
        destViewController.navigationItem.title = @"event"; // Setting title in the navigation bar of next view
        [destViewController getEventObject:self.event];
        
        [self filterSameEvents];
        Events *e = nil;
        for (int i = 0; i<self.filterArray.count; i++) {
            e =[self.filterArray objectAtIndex:i];
            if (e.start_date == self.event.start_date ) {
                [destViewController setDay:i+1];
            }
        }

        
    }
}

@end
