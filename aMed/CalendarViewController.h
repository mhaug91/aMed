//
//  CalendarViewController.h
//  aMed
//
//  Created by MacBarhaug on 07.05.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>
#import "RetrieveData.h"
#import "SelectedEventViewController.h"


/**
 *  This class creates a calendar by using the JTCalendar library. The library is found on the Pods file that is included in this project. We use a dependancy manager called Cocoa Pods to import the required libraries. To update the library you have to run some commands against cocoa pods. More details in the system documentation of our app. All credits to Jonathan Tribouharet for making the calendar library.
 
 The class is found on https://github.com/jonathantribouharet/JTCalendar and we have customized it so we can use it in our application. It displays events on the right dates of the calendar, and u can click one event to display event info that day. It has views for both month and week. In both views you can swipe to display more dates. 
 */


@interface CalendarViewController : UIViewController<JTCalendarDataSource, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView; // the calendar menu view

@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView; // calendar content view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight; // Keeps the height of the content view. This is a constraint found in the storyboard on the calendar content view. 

@property(strong, nonatomic) RetrieveData *rd; // Object retrieving data from the database.
@property(strong, nonatomic) NSMutableArray *eventArray; // Array containing all the events retrieved from the database
@property(strong, nonatomic) NSMutableArray *filterArray; // Array containing events with the same event id as selected event.
@property(strong, nonatomic) NSArray *eventsOnSelectedDate; // Array containing all events on a selected date by the user
@property(assign, nonatomic) NSInteger numberOfEventsForSelectedDate; // the amount of events on the selected date
@property(assign, nonatomic) BOOL clearTable; // Flag variable to decide if the table shall be cleared or not. Initially set to NO.
@property(strong, nonatomic) UIActivityIndicatorView *spinner;// An activity indicator to show that a task is in progress. 


/* Integers to decide what kind of event is displayed. Same values are found in the database. */
@property(assign, nonatomic) int COURSE;
@property(assign, nonatomic) int FESTIVAL;
@property(assign, nonatomic) int EXHIBITION, EXHIBITION_2;


@property (strong, nonatomic) JTCalendar *calendar; // Library for calendar. 

@end
