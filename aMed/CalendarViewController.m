//
//  CalendarViewController.m
//  aMed
//
//  Created by MacBarhaug on 07.05.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "CalendarViewController.h"



@interface CalendarViewController (){
    NSInteger eventIndex;
    NSMutableDictionary *eventsByDate;
    
}




@end

#define getEventsURL @"http://www.amed.no/AmedApplication/getEvents.php"



@implementation CalendarViewController

- (void)viewDidLoad
{
    eventIndex = 0;
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


- (IBAction)didGoTodayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
}

- (IBAction)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
}


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

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    if([self calendarHaveEvent:calendar date:date]){
        NSLog(@"Date: %@", date);
        [self performSegueWithIdentifier:@"pushSelectedDate" sender:date];
        
    }
}



/*
- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date

{
    Events *e = nil;
    e = [self.eventArray objectAtIndex:eventIndex];
    
    // *dateString = e.start_date;
    NSString *dateString = [e.start_date substringToIndex:10];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *kalenderDatoString = [formatter stringFromDate:date];
    NSString *eksDate = @"2015-02-26";
    if([kalenderDatoString isEqualToString:eksDate]){
        if(eventIndex < self.eventArray.count-1){
            eventIndex++;
            return YES;
        }
    }

            return NO;
}



- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date

{
    
    if([self calendarHaveEvent:calendar date:date]){
        NSLog(@"Date: %@", date);
        [self performSegueWithIdentifier:@"pushSelectedDate" sender:date];
        
    }
    
}
 */

- (void)createEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < self.eventArray.count; ++i){
        // Generate 30 random dates between now and 60 days later
        Events *e = nil;
        e = [self.eventArray objectAtIndex:i];
        
        NSString *dateString = e.start_date;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *randomDate = [dateFormat dateFromString:dateString];
        
        //NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:randomDate];
        
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

- (void) infoPressed:(id) sender{
    NSString *title = @"Kalender";
    NSString *info = @"Arrangements kalender";
    [[[UIAlertView alloc] initWithTitle:title message:info delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

- (Events *) findEventForDate:(NSString *) date{
    Events *event = nil;
    NSString *dateString;
    for(int i=0; i<self.eventArray.count; ++i){
        event = [self.eventArray objectAtIndex:i];
        dateString = [event.start_date substringToIndex:10];
        //dateString = [[self dateFormatter] ]
        if([dateString isEqualToString:date]){
            //event = [self.eventArray]
            event = [self.eventArray objectAtIndex:i];
            return event;
        }
        //[formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return nil;

}

-(void) filterSameEvents{
    self.filterArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.eventArray.count; i++) {
        Events *method = nil;
        method = [self.eventArray objectAtIndex:i];
        if (self.event.event_id == method.event_id) {
            [self.filterArray addObject:method];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"pushSelectedDate"]){
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
