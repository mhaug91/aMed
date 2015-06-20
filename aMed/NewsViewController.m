//
//  FirstViewController.m
//  aMed
//
//  Created by MacBarhaug on 09.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "NewsViewController.h"


/**
 *  Identifier of cell made in the storyboard.
 */
static NSString *newsTableCellIdentifier = @"NewsTableIdentifier";

@interface NewsViewController ()


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    @try {
        self.rd = [[RetrieveData alloc] init];
        self.newsArray = [self.rd retrieveNewsData]; // Fills up the newstsarray with threatments from the database. (See RetrieveData.m).


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
        if (self.newsArray.count == 0) {
            self.rd = [[RetrieveData alloc] init];
            self.newsArray = [self.rd retrieveNewsData];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    } else if ( 1 == buttonIndex ){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

    }
}

#pragma mark -
#pragma mark Table View Data Source Methods


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
        return [self.newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:
                             newsTableCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:newsTableCellIdentifier];
    }
    News *news = [self.newsArray objectAtIndex:indexPath.row];/// Fetches the news object at corresponding index in the table view.
    cell.textLabel.text = news.title; /// Set the title of the cell from the news object. 
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
    /// checks if the segue is equal to the segue specified in the storyboard.
     if ([segue.identifier isEqualToString:@"pushNewsInfo"]) {
         UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         
         spinner.center = CGPointMake(160, 240);
         
         [self.view addSubview:spinner];
         
         [spinner startAnimating];
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender]; // Fetch the indexpath selected by the user.

         News *news = [self.newsArray objectAtIndex:indexPath.row]; // Fetch news object from newsarray at the indexpath's row.
         NewsInfoViewController *destVC = segue.destinationViewController; // Setting the destination view controller
         @try {
             [news setIntroText:[self.rd retrieveNewsInfoData:news.alias]]; // Setting the introtext (article text), in news object. (See Retrievedata.m).
             destVC.navigationItem.title = news.title; // Setting the new's title in the navigation bar of the next view. 
             [destVC getNewsObject:news];
               [spinner stopAnimating];// Passing object to destination view controller. (See NewsInfoViewController).
         }
         @catch (NSException *exception) {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ingen tilgang til nettverk"
                                                                 message:@"Slå på nettverk inne på innstillinger for å få tilgang til innhold" delegate:self
                                                       cancelButtonTitle:@"Ok" otherButtonTitles:@"Innstillinger", nil];
             [alertView show];
             
         }

         
         
    }
}




@end
