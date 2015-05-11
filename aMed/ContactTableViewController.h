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
    @property (weak, nonatomic) IBOutlet UITextField *nameField;
    @property (weak, nonatomic) IBOutlet UITextField *phoneField;
    @property (weak, nonatomic) IBOutlet UITextView *requestField;
    @property (weak, nonatomic) IBOutlet UITableViewCell *sendCell;
    @property (weak, nonatomic) IBOutlet UITableViewCell *resetCell;

@end
