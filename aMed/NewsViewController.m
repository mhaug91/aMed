//
//  FirstViewController.m
//  aMed
//
//  Created by MacBarhaug on 09.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "NewsViewController.h"

static NSString *newsTableIdentifier = @"NewsTableIdentifier";

@interface NewsViewController ()

@property (copy, nonatomic) NSArray *dwarves;

@end

@implementation NewsViewController{
    NSMutableArray *filteredNames;
    NSArray *searchResults;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @try {
        self.rd = [[RetrieveData alloc] init];
        self.newsArray = [self.rd retrieveNewsData];
        [self.tableView reloadData];
    }
    @catch (NSException *exception) {
        
    }

}

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
/*
-(void)viewWillAppear:(BOOL)animated{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Feil"
                                                        message:@"kunne ikke hente data" delegate:self
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alertView show];

}*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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


#pragma marks
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
        return [self.newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:
                             newsTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:newsTableIdentifier];
    }
    News *news = [self.newsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = news.title;
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"pushNewsInfo"]) {
         NSLog(@"pushNewsInfo");
         
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
         News *news = [self.newsArray objectAtIndex:indexPath.row];
         NewsInfoViewController *destVC = segue.destinationViewController;
         @try {
             [news setIntroText:[self.rd retrieveNewsInfoData:news.alias]];
             destVC.navigationItem.title = news.title;
             [destVC getNewsObject:news];
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
