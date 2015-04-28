//
//  EventsTableViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 21/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "EventsTableViewController.h"

#define getEventsURL @"http://www.amed.no/AmedApplication/getEvents.php"

static NSString *eventID = @"eventID";
NSInteger COURSE = 66; // blue
NSInteger FESTIVAL = 71; //red
NSInteger EXHIBITION = 70; //green
NSInteger EXHIBITION_2 = 86; //green

@interface EventsTableViewController ()

@end

@implementation EventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rd = [[RetrieveData alloc] init];
    self.eventArray = [self.rd retrieveEvents];
    [self filterArrayID];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filterArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventID" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:eventID];
    }
    
    Events *method = nil;
    method = [self.filterArray objectAtIndex:indexPath.row];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
    cell.textLabel.font = font;
    
    cell.textLabel.text = method.summary;

    if(method.category_id == COURSE){
        cell.imageView.image = [UIImage imageNamed:@"event_blue"];
    } else if (method.category_id == FESTIVAL){
        cell.imageView.image = [UIImage imageNamed:@"event_red"];
    } else if (method.category_id == EXHIBITION || method.category_id == EXHIBITION_2){
        cell.imageView.image = [UIImage imageNamed:@"event_green"];
    }


    
    
    
    return cell;
}
-(void) filterArrayID{
    int k = 0;
    self.filterArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.eventArray.count; i++) {
        Events *method = nil;
        Events *method2 = nil;
        method = [self.eventArray objectAtIndex:i];
        method2 = [self.eventArray objectAtIndex:(i-k)];
        if (i == 0 || method.event_id != method2.event_id) {
            [self.filterArray addObject:method];
        }
        k = 1;
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"PushSelectedEvent"]){
        
        NSIndexPath *indexPath = nil;
        Events *method = nil;
        NSString *title = method.summary;
        
        NSLog(@"metode overgang");
        indexPath = [self.tableView indexPathForCell:sender];
        method = [self.filterArray objectAtIndex:indexPath.row];
        
        SelectedEventViewController *destViewController = segue.destinationViewController; // Getting new view controller
        destViewController.navigationItem.title = title; // Setting title in the navigation bar of next view
        [destViewController getEventObject:method]; // Passing object to ThreamentInfoController

    }
}


@end
