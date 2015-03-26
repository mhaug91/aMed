//
//  BehListeTableViewController.m
//  aMed
//
//  Created by MacBarhaug on 16.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "ThreatmentsTableViewController.h"


#define getDataThreatmentsURL @"http://www.amed.no/AmedApplication/getTreatmentmethods.php"
#define getDataThreatmentInfoURL @"http://www.amed.no/AmedApplication/getTreatmentmethodInfo.php?alias="


static NSString *SimpleTableIdentifier = @"MetodeCell";

@interface ThreatmentsTableViewController ()

@property (copy, nonatomic) NSArray *metoder;

@end

@implementation ThreatmentsTableViewController{
    NSArray *searchResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.metoder = @[@"masasje", @"healing", @"åndelig veiledning", @"Heimler",
                     @"Akupunktur", @"thaimasasje", @"trene",
                     @"naprapati", @"onani", @"løping", @"klatring",
                     @"osteopati", @"psykoterapi", @"Mensendieck", @"Fysio",
                     @"Hopping", @"aping", @"sprøyter", @"stikk",
                     @"homeopati"];
    // Load data
    [self retrieveThreatmentsData];
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
    ThreatmentMethod *metode = nil;
    metode = [self.threatmentsArray objectAtIndex:indexPath.row];
    /*
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        metode = [searchResults objectAtIndex:indexPath.row];
    } else {
        metode = [self.threatmentsArray objectAtIndex:indexPath.row];
    }
     */
    cell.textLabel.text = metode.title/*self.metoder[indexPath.row] */;
    UIImage *image = [UIImage imageNamed:@"second"];
    cell.imageView.image = image;
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

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchResults = [self.metoder filteredArrayUsingPredicate:resultPredicate];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller
  didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:SimpleTableIdentifier];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *metode = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        metode = [searchResults objectAtIndex:indexPath.row];
    } else {
        metode = [self.metoder objectAtIndex:indexPath.row];
    }
    NSLog(@"valgte: %@", metode);
}
 */



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"pushThreatmentInfo"])
        {
            
        NSIndexPath *indexPath = nil;
        ThreatmentMethod *method = nil;
        /* Fortsatt litt rot med søkefeltet */
        /*if (self.searchDisplayController.active) {
            NSLog(@"søkeresultat overgang");
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            method = [searchResults objectAtIndex:indexPath.row];
        } */
            //else {
            NSLog(@"metode overgang");
            indexPath = [self.tableView indexPathForCell:sender];
            method = [self.threatmentsArray objectAtIndex:indexPath.row];
        //}
        ThreatmentInfoViewController *destViewController = segue.destinationViewController; // Getting new view controller
        destViewController.navigationItem.title = method.title; // Setting title in the navigation bar of next view
        [destViewController getThreatmentMethod:method]; // Passing object to ThreamentInfoController
        NSString *alias = method.alias;
        NSString *introtext = [self retreiveThreatmentInfoData:method.alias]; // Passing the ThreatmentMethod objects alias to get its info
        [method setIntroText:introtext]; //
            
        }
}

#pragma mark database methods
- (void) retrieveThreatmentsData{
    NSURL *url = [NSURL URLWithString:getDataThreatmentsURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    // setting up threatments Array
    self.threatmentsArray = [[NSMutableArray alloc] init];
    
    //Loop through json Array
    for (int i=0; i<self.jsonArray.count; i++) {
        //Create our threatment object
        NSString *title = [[self.jsonArray objectAtIndex:i] objectForKey:(@"title")];
        NSString *alias = [[self.jsonArray objectAtIndex:i] objectForKey:(@"alias")];
        
        //add the threatment object to our threatments array
        [self.threatmentsArray addObject:[[ThreatmentMethod alloc]initWithTitle:title andAlias:alias]];
        
    }
}

/* This method returns the information of a selected threatmentmethod from the database.
 * Takes an alias as the argument
 */
- (NSString *) retreiveThreatmentInfoData: (NSString *) alias
{
    NSString *info = nil;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", getDataThreatmentInfoURL, alias]; // makes the urlstring where the info is stored
    NSLog(urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.jsonArray =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    //Loop through json Array
    for (int i=0; i<self.jsonArray.count; i++) {
        info = [[self.jsonArray objectAtIndex:i] objectForKey:(@"introtext")];
        
    }

    
    
    return info;
}



@end