//
//  finnBehandlerTableViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 09/03/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "TherapistTableViewController.h"

#define getDataTherapistsURL @"http://www.amed.no/AmedApplication/getTherapists.php"

static NSString *tableCellID = @"finnBehandlerID";
//static NSString *headerCellID = @"HeaderCell";

//static NSString *loaderCellID = @"LoadCell";


/**
 *  This is the controller which displays the a list of all the therapists
 *  All therapists are shown in a table view.
 */

@interface TherapistTableViewController ()

//@property (copy, nonatomic) NSArray *behandlere;

@end

@implementation TherapistTableViewController{
    
    //Initializing an array of searchresults
    NSArray *searchResults;
    NSMutableArray *predicates;

}

- (void)viewDidLoad {
        [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    /* Adding an activity indicator to show that a task is in progress. 
     * It appears as a spinning gear in the middle of the screen. */
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.spinner];
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.spinner startAnimating];
}



// This method is only in use when viewDidLoad doesnt retrieve data from database.
- (void) viewDidAppear:(BOOL)animated{
    @try {
        self.rd = [[RetrieveData alloc] init];
        self.therapists = [self.rd retrieveTherapists];
    }
    @catch (NSException *exception) {
        
    }

    @try {
        //Retrieves data from database, uses exception handling incase of no network connection.
       
        if (self.therapists.count == 0) {
            self.rd = [[RetrieveData alloc] init];
            self.therapists = [self.rd retrieveTherapists];
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
    [self.spinner stopAnimating];
}

//Alert View which is shown when the user isn't connected to a network.
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( 0 == buttonIndex ){ //cancel button
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    } else if ( 1 == buttonIndex ){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
}

#pragma marks
#pragma mark table view data methods

/*Method for setting the amount of rows in the tableview.
 *That amount is either all therapists or the result of a search.
 */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }else{
        return [self.therapists count];
    }

}

//Sets the height of a row.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

// Method of what the cells in the table view should contain.
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:
                             tableCellID forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:tableCellID];
    }
    Therapists *therapist = nil;
    
    //Handling of search results.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        therapist =[searchResults objectAtIndex:indexPath.row];

    }
    else{
        therapist = [self.therapists objectAtIndex:indexPath.row];

    }
    //Name of the therapist put into one string.
    NSString *name = [NSString stringWithFormat:@"%@ %@", therapist.firstName, therapist.lastName];
    
    //Using description string for database to show the therapists treatment methods.
    NSString *therapistTreatments = [[therapist.treatmentMethods valueForKey:@"description"] componentsJoinedByString:@", "];
    
    /* Placing the image in the cell and scales it, to a preferred size. */
    //NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:therapist.pictureURL]];
    cell.imageView.image = [UIImage imageWithData:therapist.picture];
    CGSize itemSize = CGSizeMake(45, 50);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSString *description = [NSString stringWithFormat:@"%@\r%@", name, therapistTreatments];
    
    //Setting textLabel and detailTextLabel
    cell.textLabel.text = therapist.company;
    cell.detailTextLabel.text = description;
    cell.detailTextLabel.numberOfLines = 2;
    
    
    return cell;
}

#pragma mark - search delegate methods

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
    /* The predicate object searches through all the Threatments and returns the matched objects.
     * it returns true or false.
     * Filter the threatments using "..................." as the search criteria.
     * [c] means case in- sensitive.
     */
    predicates = [[NSMutableArray alloc] init];

    if(3>1){
        NSPredicate *firstNamePredicate= [NSPredicate predicateWithFormat:@"firstName contains[c] %@",
                          searchText];
        NSPredicate *lastNamePredicate= [NSPredicate predicateWithFormat:@"lastName contains[c] %@",
                                          searchText];
        [predicates addObject:firstNamePredicate];
        [predicates addObject:lastNamePredicate];
    }
    if(3>2){
        NSPredicate *compPredicate= [NSPredicate predicateWithFormat:@"company contains[c] %@",
                          searchText];
        [predicates addObject:compPredicate];

    }
    if(3>2){
        NSPredicate *cityPredicate= [NSPredicate predicateWithFormat:@"address.city contains[c] %@",
                                     searchText];
        [predicates addObject:cityPredicate];
        
    }
    if(3>2){
        NSPredicate *statePredicate= [NSPredicate predicateWithFormat:@"address.state contains[c] %@",
                                     searchText];
        [predicates addObject:statePredicate];
    }
    if(3>2){
        NSPredicate *methodPredicate= [NSPredicate predicateWithFormat:@"treatmentMethodString contains[c] %@",
                                      searchText];
        [predicates addObject:methodPredicate];
    }
    

    
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    
    searchResults = [self.therapists filteredArrayUsingPredicate:compoundPredicate];
    
}


- (void)searchDisplayController:(UISearchDisplayController *)controller
  didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:tableCellID];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if([[segue identifier] isEqualToString:@"pushTherapist"]){
         
         NSIndexPath *indexPath = nil;
         Therapists *therapist = nil;
         if (self.searchDisplayController.active) {
             indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
             therapist = [searchResults objectAtIndex:indexPath.row];
             
         }
         else {
             indexPath = [self.tableView indexPathForCell:sender];
             therapist = [self.therapists objectAtIndex:indexPath.row];
         }
         NSString *title = therapist.company;

         TherapistViewController *destViewController = segue.destinationViewController; // Getting new view controller
         destViewController.navigationItem.title = title; // Setting title in the navigation bar of next view
         [destViewController getTherapistObject:therapist]; // Passing object to ThreamentInfoController
     }
}

@end
