//
//  ContactTableViewController.m
//  aMed
//
//  Created by MacBarhaug on 23.04.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "ContactTableViewController.h"

/**
 *  Controls the contact us view
 *
 */
@interface ContactTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextView *requestField;
@property (weak, nonatomic) IBOutlet UITableViewCell *sendCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *resetCell;

@end

@implementation ContactTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBorderOfRequestField]; // Have to manually set the border of the requestfield
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; // Creates an infobutton.
    [infoButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside]; // Adds action to the button.
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton]; // Inits the button as a barButton.
    self.navigationItem.rightBarButtonItem = infoButtonItem; // Plces the button in the navigation bar.
    //self.tableView.tableFooterView = [UIView new];
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
    return 5;
}


- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCellClicked = [self.tableView cellForRowAtIndexPath:indexPath];
    if(theCellClicked == self.resetCell){
        [self resetFields];
    }
    
    if(theCellClicked == self.sendCell){
        // Email Subject
        NSString *errorMessage = [self validateFields];
        if(errorMessage){
            [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            return;
        }
        else{
            NSString *emailTitle = @"Kontakt amed.no";
            NSString *nameString=@"";
            if([self.nameField.text length] != 0 ){
                nameString = [NSString stringWithFormat:@"Navn: %@ %@", self.nameField.text, @"\n"];
            }
            NSString *phoneString=@"";
            if([self.phoneField.text length] != 0 ){
                phoneString = [NSString stringWithFormat:@"Telefonnr: %@ %@", self.phoneField.text, @"\n"];

            }
            NSString *requestText = self.requestField.text;
            // Email Content
            NSString *messageBody = [NSString stringWithFormat: @"%@ %@ %@ %@ %@", nameString, phoneString, @"\nHenvendelse: ",requestText, @"\n\n Sendt Fra iOS enhet. "];
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
}

/**
 *  Validating a textfield
 *
 *  @return errorMessage
 */
- (NSString *) validateFields{
    NSString *errorMessage;
    if([self.requestField.text length] == 0){
        errorMessage = @"Henvendelse må fylles inn";
        [self.requestField.layer setBorderColor:[[[UIColor redColor] colorWithAlphaComponent:1] CGColor]];

    }
    return errorMessage;
}

- (void) resetFields{
    self.nameField.text=@"";
    self.phoneField.text=@"";
    self.requestField.text=@"";

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

- (void) setBorderOfRequestField{
    //To make the border look very close to a UITextField
    [self.requestField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.2] CGColor]];
    [self.requestField.layer setBorderWidth:1.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.requestField.layer.cornerRadius = 5;
    self.requestField.clipsToBounds = YES;
}

- (void) buttonAction:(id) sender{
    NSString *title = @"Kontakt oss";
    NSString *info = @"Her kan du kontakte oss ved å fylle ut skjemaet. Vi vil se gjennom din henvendelse og kontakte deg så fort som mulig. Personinfo ikke påkrevd.";
    [[[UIAlertView alloc] initWithTitle:title message:info delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}


@end
