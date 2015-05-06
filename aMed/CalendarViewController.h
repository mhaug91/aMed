//
//  KalenderViewController.h
//  aMed
//
//  Created by MacBarhaug on 06.05.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

// #import <Pods/JTCalendar.h>




@interface CalendarViewController : UIViewController<JTCalendarDataSource>


@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@property (strong, nonatomic) JTCalendar *calendar;

@end
