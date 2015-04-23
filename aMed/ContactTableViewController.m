//
//  ContactTableViewController.m
//  aMed
//
//  Created by MacBarhaug on 23.04.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "ContactTableViewController.h"

@interface ContactTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextView *requestField;
@property (weak, nonatomic) IBOutlet UITableViewCell *sendCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *resetCell;

@end

@implementation ContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 8;
}


- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCellClicked = [self.tableView cellForRowAtIndexPath:indexPath];
    if(theCellClicked == self.resetCell){
        NSLog(@"Fields have been resetted. ");
        self.nameField.text=@"";
        self.addressField.text=@"";
        self.phoneField.text=@"";
        self.stateField.text=@"";
        self.zipCodeField.text=@"";
        self.requestField.text=@"";

    }
    
    if(theCellClicked == self.sendCell){
        // Email Subject
        NSString *emailTitle = @"Kontakt amed.no";
        NSString *name = self.nameField.text;
        NSString *phone = self.phoneField.text;
        NSString *streetAddress = self.addressField.text;
        NSString *zipCode = self.zipCodeField.text;
        NSString *state = self.stateField.text;
        NSString *request = self.requestField.text;
        // Email Content
        NSString *messageBody = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@", @"Navn: ", name,  @"\nTelefonnr: ", phone, @"\nGateadresse: ", streetAddress, @"\nPostnummer: ", zipCode,  @"\nPoststed: ", state, @"\nLurer på: ", request, @"\n\n Sendt Fra iOS enhet. "];
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@"mhaug91@gmail.com"]; // For testformål
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        if (mc != nil) {
            [self presentViewController:mc animated:YES completion:NULL];
        }else{
            NSLog(@"Mail ikke sendt");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Konfigurer epost"
                                  message:@"Sett opp epost i epost instillingene på enheten for å kontakte oss"
                                  delegate:self
                                  cancelButtonTitle:@"ok!"
                                  otherButtonTitles:nil];
            
            [alert show];
            
        }
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //[MailAlert show];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

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
