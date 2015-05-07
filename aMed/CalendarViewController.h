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



@interface CalendarViewController : UIViewController<JTCalendarDataSource>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;

@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (weak, nonatomic) NSString *eventID;// = @"eventID";
//@property (strong, nonatomic) NSInteger COURSE;// = 66; // blue
//@property (weak, nonatomic) NSInteger FESTIVAL;// = 71; //red
//@property (weak, nonatomic) NSInteger EXHIBITION;// = 70; //green
//@property (weak, nonatomic) NSInteger EXHIBITION_2;// = 86; //green


@property(strong, nonatomic) RetrieveData *rd;
@property(strong, nonatomic) NSMutableArray *jsonArray;
@property(strong, nonatomic) NSMutableArray *eventArray;
@property(strong, nonatomic) NSMutableArray *filterArray;



@property (strong, nonatomic) JTCalendar *calendar;

@end
