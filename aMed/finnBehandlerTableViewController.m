//
//  finnBehandlerTableViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 09/03/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "finnBehandlerTableViewController.h"

#define getDataTherapistsURL @"http://www.amed.no/AmedApplication/getTherapists.php"

static NSString *finnBehandlerID = @"finnBehandlerID";


@interface finnBehandlerTableViewController ()

@property (copy, nonatomic) NSArray *behandlere;

@end

@implementation finnBehandlerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rd = [[RetrieveData alloc] init];
    self.therapists = [self.rd retrieveTherapists];
    
    
    //Legger inn tabell av behandlere
    //self.behandlere = self.therapists;
    
    /*@[@"Liv Grete Olsen", @"Kärstin Irene Trygg", @"Kristbjørg Rasmussen",
     @"Nina Brandsdal", @"Linda Opedal Mokleiv", @"Liv Grete Olsen", @"Kärstin Irene Trygg",
     @"Kristbjørg Rasmussen",
     @"Nina Brandsdal", @"Linda Opedal Mokleiv", @"Liv Grete Olsen", @"Kärstin Irene Trygg", @"Kristbjørg Rasmussen",
     @"Nina Brandsdal", @"Linda Opedal Mokleiv"];*/
    //UITableView *tableView = (id)[self.view viewWithTag:1];
    
    // tableView.contentInset = UIEdgeInsetsMake(94, 0, 74, 0);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld", [self.therapists count]);
    return [self.therapists count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             finnBehandlerID forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:finnBehandlerID];
    }

    Therapists *method = nil;
    method = [self.therapists objectAtIndex:indexPath.row];
    NSString *name = [NSString stringWithFormat:@"%@ %@", method.firstName, method.lastName];
    cell.textLabel.text = name;

    NSString *imagepath = [NSString stringWithFormat:@"https://www.amed.no/images/comprofiler/%@", method.avatar];
    cell.imageView.image =  [UIImage imageNamed:imagepath];
    NSString *therapistTreatments = [[method.treatmentMethods valueForKey:@"description"] componentsJoinedByString:@", "];
    NSString *noAvatar = @"https://www.amed.no/components/com_comprofiler/plugin/templates/default/images/avatar/nophoto_n.png";
    if([method.avatar isEqual:[NSNull null]]){
        NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:noAvatar]];
        cell.imageView.image = [UIImage imageWithData:image];

    } else {
        NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagepath]];
        cell.imageView.image = [UIImage imageWithData:image];

    }
    
    cell.textLabel.text = method.company;
    cell.textLabel.font = [UIFont fontWithName:@"Calibri" size:12];
    
    NSString *description = [NSString stringWithFormat:@"%@\r%@", name, therapistTreatments];
    cell.detailTextLabel.text = description;
    cell.detailTextLabel.numberOfLines = 2;
    
    
    return cell;
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

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 #warning Potentially incomplete method implementation.
 // Return the number of sections.
 return 0;
 }*/


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
