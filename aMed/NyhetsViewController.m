//
//  FirstViewController.m
//  aMed
//
//  Created by MacBarhaug on 09.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "NyhetsViewController.h"
#import "NyhetsVisningController.h"

static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";

@interface NyhetsViewController ()

@property (copy, nonatomic) NSArray *dwarves;

@end

@implementation NyhetsViewController{
    NSMutableArray *filteredNames;
    UISearchDisplayController *searchController;
    NSArray *searchResults;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Hello Myhre");
    self.dwarves = @[@"Sleepy", @"Sneezy", @"Bashful", @"Happy",
                     @"Doc", @"Grumpy", @"Dopey",
                     @"Thorin", @"Dorin", @"Nori", @"Ori",
                     @"Balin", @"Dwalin", @"Fili", @"Kili",
                     @"Oin", @"Gloin", @"Bifur", @"Bofur",
                     @"Bombur"];
    UITableView *tableView = (id)[self.view viewWithTag:1];
    searchResults = [NSMutableArray array];
    UISearchBar *searchBar = [[UISearchBar alloc]
                              initWithFrame:CGRectMake(0, 0, 320, 44)];
    tableView.tableHeaderView = searchBar;
    searchController = [[UISearchDisplayController alloc]
                        initWithSearchBar:searchBar
                        contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;

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
    if(tableView.tag ==  1){
        return [self.dwarves count];
    } else {
        return [searchResults count];
    }
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
    if (tableView.tag == 1) {
        cell.textLabel.text = self.dwarves[indexPath.row];
    } else {
        cell.textLabel.text = searchResults[indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowValue = nil;
    if (tableView.tag == 1) {
        rowValue = self.dwarves[indexPath.row];
    } else {
        rowValue = searchResults[indexPath.row];
    }
    NSString *message = [[NSString alloc] initWithFormat:
                         @"You selected %@", rowValue];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Row Selected!"
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"Yes I Did"
                          otherButtonTitles:nil];
    [alert show];
    /*
     NSString *rowValue = self.dwarves[indexPath.row];
     NSString *message = [[NSString alloc] initWithFormat:
     @"You selected %@", rowValue];

    NSString *message = [[NSString alloc] initWithFormat:
                         @"You selected %@", rowValue];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Row Selected!"
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"Yes I Did"
                          otherButtonTitles:nil];
    [alert show];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller
  didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:SimpleTableIdentifier];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchResults = [self.dwarves filteredArrayUsingPredicate:resultPredicate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:SimpleTableIdentifier]) {
         NSIndexPath *indexPath = nil;
         NSString *dwarf = nil;
         if (searchController.active) {
             indexPath =[searchController.searchResultsTableView indexPathForCell:sender];
             dwarf = searchResults[indexPath.row];
         }else {
             indexPath =[self.tableView indexPathForCell:sender];
             dwarf = self.dwarves[indexPath.row];
         }
         UIViewController *nyVC = segue.destinationViewController;
   
        //nyVC.navigationItem.title = self.dwarves[indexPath.row];
    //} else {
         //nyVC.navigationItem.title = searchResults[indexPath.row];
         nyVC.navigationItem.title = dwarf;
    }
}




@end
