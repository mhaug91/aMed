//
//  FirstViewController.m
//  aMed
//
//  Created by MacBarhaug on 09.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "NewsViewController.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**
 *  Identifier of cell made in the storyboard.
 */
static NSString *newsTableCellIdentifier = @"NewsTableIdentifier";

@interface NewsViewController ()


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initiating the activity indicator and set it as subview. Appears as a “gear” that is spinning in the middle of the screen.
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.spinner];
    [self.spinner setColor:UIColorFromRGB(0x602167)];
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.spinner startAnimating];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    

}

/**
 *  This method is only in use when viewDidLoad doesnt retrieve data from database.
 *
 */
- (void) viewDidAppear:(BOOL)animated{
    @try {
        self.rd = [[RetrieveData alloc] init];
        self.newsArray = [self.rd retrieveNewsData]; // Fills up the newstsarray with threatments from the database. (See RetrieveData.m).
        
        
    }
    @catch (NSException *exception) {
        
    }
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
    [self.spinner stopAnimating];
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
         // Initiating the activity indicator and set it as subview. Appears as a “gear” that is spinning in the middle of the screen.
                  NSIndexPath *indexPath = [self.tableView indexPathForCell:sender]; // Fetch the indexpath selected by the user.

         News *news = [self.newsArray objectAtIndex:indexPath.row]; // Fetch news object from newsarray at the indexpath's row.
         NewsInfoViewController *destVC = segue.destinationViewController; // Setting the destination view controller
         @try {
             //NSString *alias = [self.rd retrieveNewsInfoData:news.alias];
             //[news setIntroText:alias]; // Setting the introtext (article text), in news object. (See Retrievedata.m).
             destVC.navigationItem.title = news.title; // Setting the new's title in the navigation bar of the next view. 
             //[destVC getNewsObject:news];// Passing object to destination view controller. (See NewsInfoViewController).
             [destVC getAlias:news.alias];

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
