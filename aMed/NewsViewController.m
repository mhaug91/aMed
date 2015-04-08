//
//  FirstViewController.m
//  aMed
//
//  Created by MacBarhaug on 09.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "NewsViewController.h"

static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";

@interface NewsViewController ()

@property (copy, nonatomic) NSArray *dwarves;

@end

@implementation NewsViewController{
    NSMutableArray *filteredNames;
    NSArray *searchResults;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dwarves = @[@"Sleepy", @"Sneezy", @"Bashful", @"Happy",
                     @"Doc", @"Grumpy", @"Dopey",
                     @"Thorin", @"Dorin", @"Nori", @"Ori",
                     @"Balin", @"Dwalin", @"Fili", @"Kili",
                     @"Oin", @"Gloin", @"Bifur", @"Bofur",
                     @"Bombur"];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods


#pragma marks
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
        return [self.dwarves count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SimpleTableIdentifier];
    }
    cell.textLabel.text = self.dwarves[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowValue = nil;
        rowValue = self.dwarves[indexPath.row];
    NSString *message = [[NSString alloc] initWithFormat:
                         @"You selected %@", rowValue];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Row Selected!"
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"Yes I Did"
                          otherButtonTitles:nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:SimpleTableIdentifier]) {
         NSIndexPath *indexPath = nil;
         NSString *dwarf = nil;
        indexPath =[self.tableView indexPathForCell:sender];
        dwarf = self.dwarves[indexPath.row];
         UIViewController *nyVC = segue.destinationViewController;
   
        //nyVC.navigationItem.title = self.dwarves[indexPath.row];
    //} else {
         //nyVC.navigationItem.title = searchResults[indexPath.row];
         nyVC.navigationItem.title = dwarf;
    }
}




@end
