//
//  CalendarViewController.m
//  aMed
//
//  Created by MacBarhaug on 07.05.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    
    
    self.calendar = [JTCalendar new];
    
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    
    [self.calendar setContentView:self.calendarContentView];
    
    [self.calendar setDataSource:self];
}


- (void)viewDidAppear:(BOOL)animated

{
    
    [super viewDidAppear:animated];
    
    
    
    [self.calendar reloadData]; // Must be call in viewDidAppear
    
}



- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date

{
    
    return NO;
    
}



- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date

{
    
    NSLog(@"%@", date);
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
