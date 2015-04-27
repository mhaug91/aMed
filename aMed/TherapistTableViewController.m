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


@interface TherapistTableViewController ()

@property (copy, nonatomic) NSArray *behandlere;

@end

@implementation TherapistTableViewController{
    NSArray *searchResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rd = [[RetrieveData alloc] init];
    self.therapists = [self.rd retrieveTherapists];
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    tableView.rowHeight = 50;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else{
        return [self.therapists count];

    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             tableCellID forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:tableCellID];
    }
    Therapists *therapist = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        therapist =[searchResults objectAtIndex:indexPath.row];

    }
    else{
        therapist = [self.therapists objectAtIndex:indexPath.row];

    }
    NSString *name = [NSString stringWithFormat:@"%@ %@", therapist.firstName, therapist.lastName];

    NSString *imagepath = [NSString stringWithFormat:@"https://www.amed.no/images/comprofiler/%@", therapist.avatar];
    
    cell.imageView.image = [UIImage imageNamed:imagepath];
    NSString *therapistTreatments = [[therapist.treatmentMethods valueForKey:@"description"] componentsJoinedByString:@", "];
    NSString *noAvatar = @"https://www.amed.no/components/com_comprofiler/plugin/templates/default/images/avatar/nophoto_n.png";
    if([therapist.avatar isEqual:[NSNull null]]){
        NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:noAvatar]];
        cell.imageView.image = [UIImage imageWithData:image];
        CGSize itemSize = CGSizeMake(45, 50);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    

    } else {
        NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagepath]];
        cell.imageView.image = [UIImage imageWithData:image];
        CGSize itemSize = CGSizeMake(45, 50);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

    }
    

    
    cell.textLabel.text = therapist.company;
    //cell.textLabel.font = [UIFont fontWithName:@"Calibri" size:19];

    
    NSString *description = [NSString stringWithFormat:@"%@\r%@", name, therapistTreatments];
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
     * Filter the threatments using "title" as the search criteria.
     * [c] means case sensitive.
     */
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"firstName contains[c] %@",
                                    searchText];
    searchResults = [self.therapists filteredArrayUsingPredicate:resultPredicate];
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller
  didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:tableCellID];
}




/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier forIndexPath:indexPath];
 
 // Configure the cell...
 if (cell == nil) {
 cell = [[UITableViewCell alloc]
 initWithStyle:UITableViewCellStyleDefault
 reuseIdentifier:SimpleTableIdentifier];
 }
 cell.textLabel.text = self.metoder[indexPath.row];
 return cell;
 }*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



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


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 
     if([[segue identifier] isEqualToString:@"pushTherapist"]){
         NSIndexPath *indexPath = nil;
         Therapists *therapist = nil;
         
         if (self.searchDisplayController.active) {
             indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
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
         //Therapists  *Therapist = [self.rd retrieveTherapists:method.company]; // Passing the ThreatmentMethod objects alias to get its info
         //[method setIntroText:introtext]; //
     }
}

@end
