//
//  CalendarViewController.h
//  aMed
//
//  Created by MacBarhaug on 07.05.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>



@interface CalendarViewController : UIViewController

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;

@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;



@property (strong, nonatomic) JTCalendar *calendar;

@end
