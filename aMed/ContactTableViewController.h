//
//  ContactTableViewController.h
//  aMed
//
//  Created by MacBarhaug on 23.04.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

/**
 *  Controls the contact view.
 *  Consists of a static table view that makes a form. 
 */
@interface ContactTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

/**
  *  Textfields for name, phone, and requests. 
 */
    @property (weak, nonatomic) IBOutlet UITextField *nameField;
    @property (weak, nonatomic) IBOutlet UITextField *emailField;
    @property (weak, nonatomic) IBOutlet UITextView *requestField;
    @property (weak, nonatomic) IBOutlet UITableViewCell *sendCell; // User can select press this cell (works as a button), to confirm info in written in fields and move on to the mail view.
    @property (weak, nonatomic) IBOutlet UITableViewCell *resetCell; // User can press this cell to reset all the fields. 

@end
