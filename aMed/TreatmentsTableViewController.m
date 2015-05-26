//
//  BehListeTableViewController.m
//  aMed
//
//  Created by MacBarhaug on 16.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "TreatmentsTableViewController.h"


/**
 *  Identifier of cell made in the storyboard.
 */
static NSString *SimpleTableIdentifier = @"MetodeCell";



@implementation TreatmentsTableViewController{
    /**
     *  Array of threatments that corresponds with the search.
     */
    NSArray *searchResults;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // Load data
    @try {
        self.rd = [[RetrieveData alloc] init];
        self.threatmentsArray = [self.rd retrieveThreatmentsData]; // Fills up the threatmentsarray with threatments from the database. (See RetrieveData.m).
    }
    @catch (NSException *exception) {
    }
}

/**
 *  This method is only in use when viewDidLoad doesnt retrieve data from database.
 *
 */
- (void) viewDidAppear:(BOOL)animated{
    @try {
        if (self.threatmentsArray.count == 0) {
            self.rd = [[RetrieveData alloc] init];
            self.threatmentsArray = [self.rd retrieveThreatmentsData];
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
        [self.tableView reloadData];
    }
}


/**
 *  Handles the alertview that shows when no internet or other exception.
 *
 *
 */
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( 0 == buttonIndex ){ //cancel button
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    } else if ( 1 == buttonIndex ){ /// Ok button
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return [self.threatmentsArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier]; //forIndexPath:indexPath];
    
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SimpleTableIdentifier];
    }
    TreatmentMethod *metode = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) { /// if the searchcontroller is active..
        metode = [searchResults objectAtIndex:indexPath.row]; /// Fetches the threatmentmethod from searchresults array corresponding with the index in the table view.
    } else {
        metode = [self.threatmentsArray objectAtIndex:indexPath.row]; /// Fetches the threatmentmethod in the whole threatmentsarray corresponding with the index in the table view.
    }
    
    cell.textLabel.text = metode.title; // Sets the title of the cell with the right object.
    return cell;
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



/**
 *  Filters the array based on searchText.
 *
 *  @param searchText input from user in searchbar.
 *  @param scope
 
 *  @note This method is called every time the user does something in the searchbar. (input, backspace with more).
 */
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    /* The predicate object searches through all the Threatments and returns the matched objects.
     * it returns true or false.
     * Filter the threatments using "title" as the search criteria.
     * [c] means case in-sensitive. 
     */
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"title contains[c] %@",
                                    searchText];
    searchResults = [self.threatmentsArray filteredArrayUsingPredicate:resultPredicate];
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller
  didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:SimpleTableIdentifier];
}






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    /// checks if the segue is equal to the segue specified in the storyboard.
    if([[segue identifier] isEqualToString:@"pushThreatmentInfo"])         {
            
        NSIndexPath *indexPath = nil;
        TreatmentMethod *method = nil;
            
        if (self.searchDisplayController.active) { // if searchbar is active..
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow]; // Fetch the indexpath selected by the user.
            method = [searchResults objectAtIndex:indexPath.row]; // Fetch the right Treatment method object to pass to destination view controller. Fetched from searchResults array.
        }
         else { // Same as if the searchbar is active. But fetch method from the threatmentsarray.
            indexPath = [self.tableView indexPathForCell:sender];
            method = [self.threatmentsArray objectAtIndex:indexPath.row];
        }
        TreatmentInfoViewController *destViewController = segue.destinationViewController; // Setting the destination view controller
        destViewController.navigationItem.title = method.title; // Setting title of selected method in the navigation bar of the next view.
        [destViewController getThreatmentMethod:method]; // Passing object to ThreamentInfoController. (See ThreatmentInfoViewController.m)
            @try {
                NSString *introtext = [self.rd retrieveThreatmentInfoData:method.alias]; // Retrieve introtext from selected treatment. (The introtext is the article text about the treatment).
                [method setIntroText:introtext]; /// Set the method's introtext.
            }
            @catch (NSException *exception) {

            }
        }
}





@end