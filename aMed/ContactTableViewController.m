//
//  ContactTableViewController.m
//  aMed
//
//  Created by MacBarhaug on 23.04.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "ContactTableViewController.h"

/**
 *  Controls the contact us view.
 *  The view displays a contact form. 
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
    [infoButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside]; // Adds action to the button. See method: buttonAction. 
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton]; // Inits the button as a barButton.
    self.navigationItem.rightBarButtonItem = infoButtonItem; // Places the button in the navigation bar.
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
    
    if(theCellClicked == self.resetCell){ /// If clicked cell is the reset cell...
        [self resetFields]; /// reset the form
    }
    
    if(theCellClicked == self.sendCell){ /// If clicked cell is the send cell...
        // Email Subject
        NSString *errorMessage = [self validateFields]; /// Check if the form is correct filled. Create an errorstring if not.
        if(errorMessage){ /// Display errormessage if form is not filled correct.
            [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            return;
        }
        else{ /// If filled correct..
            NSString *emailTitle = @"Kontakt amed.no"; // Create title
            NSString *nameString=@"";   // Create namestring..
            if([self.nameField.text length] != 0 ){ /// But only if name is filled in form
                nameString = [NSString stringWithFormat:@"Navn: %@ %@", self.nameField.text, @"\n"];
            }
            NSString *phoneString=@""; // Same as nameString..
            if([self.phoneField.text length] != 0 ){
                phoneString = [NSString stringWithFormat:@"Telefonnr: %@ %@", self.phoneField.text, @"\n"];

            }
            NSString *requestText = self.requestField.text; // Create requestString
            // Email Content
            NSString *messageBody = [NSString stringWithFormat: @"%@ %@ %@ %@ %@", nameString, phoneString, @"\nHenvendelse: ",requestText, @"\n\n"]; // Create messagebody from name, phone and request.
            NSArray *toRecipents = [NSArray arrayWithObject:@"post@amed.no"];
        
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init]; /// initialize mailcontroller
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle]; // set subject
            [mc setMessageBody:messageBody isHTML:NO]; // set messagebody
            [mc setToRecipients:toRecipents]; // SetRecipient
        
            if (mc != nil) { /// if the device supports mail..
                [self presentViewController:mc animated:YES completion:NULL]; // Present the mail controller
            }else{ // if not. Make alert that says the user have to set up mail settings.
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
 *  Check if requestField is filled
 *
 *  @return errorMessage if field is empty.
 *  @code
    if([self.requestField.text length] == 0){
        errorMessage = @"Henvendelse må fylles inn";
        [self.requestField.layer setBorderColor:[[[UIColor redColor] colorWithAlphaComponent:1] CGColor]];
    }

 *  @endcode
 */
- (NSString *) validateFields{
    NSString *errorMessage;
    if([self.requestField.text length] == 0){
        errorMessage = @"Henvendelse må fylles inn";
        [self.requestField.layer setBorderColor:[[[UIColor redColor] colorWithAlphaComponent:1] CGColor]];

    }
    return errorMessage;
}

/**
 *  resets form.
 */
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

/**
 *  Sets the border of requestField
 *  Called in viewDidLoad.
 */
- (void) setBorderOfRequestField{
    //To make the border look very close to a UITextField
    [self.requestField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.2] CGColor]];
    [self.requestField.layer setBorderWidth:1.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.requestField.layer.cornerRadius = 5;
    self.requestField.clipsToBounds = YES;
}

/**
 *  info button action
 *
 *  @param info button
 */
- (void) buttonAction:(id) sender{
    NSString *title = @"Kontakt oss";
    NSString *info = @"Her kan du kontakte oss ved å fylle ut skjemaet. Vi vil se gjennom din henvendelse og kontakte deg så fort som mulig. Personinfo ikke påkrevd.";
    [[[UIAlertView alloc] initWithTitle:title message:info delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}


@end
