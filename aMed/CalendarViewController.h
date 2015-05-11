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
 *  This class creates a calendar by using the JTCalendar library. The library is found on the Pods file that is included in this project. We use a dependancy manager called Cocoa Pods to import the required libraries. To update the library you have to run some commands against cocoa pods. More details in the system documentation of our app. All credits to Jonathan Tribouharet for making the calendar.
 
 The class is found on https://github.com/jonathantribouharet/JTCalendar and we have customized it so we can use it in our application. It has events on the right dates of the calendar, and u can click one to display event info on that day. It has views for both month and week. Both views are scrollable so u can drag from periode to periode.
 */
@interface CalendarViewController : UIViewController<JTCalendarDataSource>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView; // the calendar menu view

@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView; // calendar content view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (weak, nonatomic) NSString *eventID;

@property(weak, nonatomic) Events *event; // 
@property(strong, nonatomic) RetrieveData *rd;
@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *eventArray;
@property(strong, nonatomic) NSMutableArray *filterArray;



@property (strong, nonatomic) JTCalendar *calendar;

@end
