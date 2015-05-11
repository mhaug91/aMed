//
//  TherapistViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 14/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "TherapistViewController.h"

#define getDataTherapistsURL @"http://www.amed.no/AmedApplication/getTherapists.php"
#define getDataThreatmentsURL @"http://www.amed.no/AmedApplication/getTreatmentmethods.php"
#define getDataThreatmentInfoURL @"http://www.amed.no/AmedApplication/getTreatmentmethodInfo.php?alias="

/**
 *  This is the controller used for showing a therapist which the user has selected in TherapistTableView.
 */


@interface TherapistViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TherapistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Retrieves data from database, uses exception handling incase of no network connection.
    @try {
        self.rd = [[RetrieveData alloc] init];
        self.therapists = [self.rd retrieveTherapists];
        self.threatmentsArray = [self.rd retrieveThreatmentsData];
    }
    @catch (NSException *exception) {

    }

    
    self.navigationItem.title = self.currentTherapist.company;
    
    //Initiating methods to make each label and tableview
    [self firstLabel];
    [self imageView];
    [self secondLabel];
    [self textField];
    [self thirdlabel];
    [self findAssociatedTherapists];
    self.tableView = [self makeTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TreatmentMethods"];
    [self.view addSubview:self.tableView];

}
// This method is only in use when viewDidLoad doesnt retrieve data from database.
- (void) viewDidAppear:(BOOL)animated{
    @try {
        if (self.therapists.count == 0) {
            self.rd = [[RetrieveData alloc] init];
            self.therapists = [self.rd retrieveTherapists];
            self.threatmentsArray = [self.rd retrieveThreatmentsData];
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
        [self.tableView setNeedsDisplay];
    }
}

- (void) getTherapistObject:(id)therapistObject{
    self.currentTherapist = therapistObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Method which creates the tableView

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( 0 == buttonIndex ){ //cancel button
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    } else if ( 1 == buttonIndex ){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
}

/**
 *  Creates the tableview with the gives description.
 *
 *  @return Return the tableview.
 */
-(UITableView *)makeTableView
{
    double number = 0;
    for (int i = 0 ; i<self.currentTherapist.treatmentMethods.count; i++) {
        number += 40;
    }
    
    CGFloat x = 0;
    CGFloat y = 280;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = number;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    tableView.rowHeight = 40;
    tableView.sectionFooterHeight = 10;
    tableView.sectionHeaderHeight = 10;
    tableView.scrollEnabled = NO;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    return tableView;
}

//First label of the view, shows the company name of the chosen therapist.
-(void) firstLabel{
    NSString *company = self.currentTherapist.company;
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 43) ];
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(16.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Firmanavn: %@", company];
}
//Finds and shows the image of the chosen therapist.
-(void) imageView{
    NSString *imagepath = [NSString stringWithFormat:@"https://www.amed.no/images/comprofiler/%@", self.currentTherapist.avatar];
    NSString *noAvatar = @"https://www.amed.no/components/com_comprofiler/plugin/templates/default/images/avatar/nophoto_n.png";
    

    UIImageView *avatarImage = [ [UIImageView alloc] initWithFrame:CGRectMake(0, 43, 200, 200)];
    if([self.currentTherapist.avatar isEqual:[NSNull null]]){
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:noAvatar]];
        avatarImage.image = [UIImage imageWithData:imageData];
        [self.contentView addSubview:avatarImage];
        CGPoint centerImageView = avatarImage.center;
        centerImageView = CGPointMake((self.view.frame.size.width / 2), 100 + 43);
        avatarImage.center = centerImageView;
    } else {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagepath]];
        avatarImage.image = [UIImage imageWithData:imageData];
        [self.contentView addSubview:avatarImage];
        CGPoint centerImageView = avatarImage.center;
        centerImageView = CGPointMake((self.view.frame.size.width / 2), 100 + 43);
        avatarImage.center = centerImageView;
    }

}
//Text label that is just a string.
-(void) secondLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 243.0, self.view.frame.size.width, 43) ];
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(16.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Behandlingsmetoder:"];
}

//Creates the tableview.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

        return [self.currentTherapist.treatmentMethods count];
        
}
//Defines each cell of the table view.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TreatmentMethods";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ThreatmentMethod *method = nil;
    
    method = [self.currentTherapist.treatmentMethods objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@", method];
    cell.textLabel.text = title;

    
    return cell;
}

//Tells the application what to do when a table cell is pressed.
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *sender = [self.tableView cellForRowAtIndexPath:indexPath];

    [self performSegueWithIdentifier:@"PushTreatmentInfo" sender:sender];
}
//Label which shows the contact information and address to the given therapist.
-(void) thirdlabel{
    double distance = (self.currentTherapist.treatmentMethods.count * 40);
    
    NSString *address = self.currentTherapist.address.street;
    NSString *zipcode = [NSString stringWithFormat:@"%ld", self.currentTherapist.address.postcode];
    NSString *city = self.currentTherapist.address.city;
    NSString *state = self.currentTherapist.address.state;
    NSString *phone = [NSString stringWithFormat:@"%ld", self.currentTherapist.phone];
    
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, (326.0 + distance), self.view.frame.size.width, 120) ];
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(16.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Addresse: %@ \n Postnummer: %@ \n Sted: %@ \n Fylke: %@ \n Telefon: %@ \n Epost: --",address, zipcode, city, state, phone];
    label.numberOfLines = 0;
}
//Show an url link to the therapists website.
-(void) textField{
    double distance = (self.currentTherapist.treatmentMethods.count * 40);
    NSString *url = self.currentTherapist.website;
    
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(0.0,(286 + distance), self.view.frame.size.width, 40);
    textView.scrollEnabled = NO;
    textView.text=[NSString stringWithFormat:@"Nettsted: %@", url];
    textView.font = [UIFont fontWithName:@"HelveticaNeue" size:(16.)];
    textView.editable = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    textView.textAlignment = NSTextAlignmentCenter;
    textView.delegate = self;
    [self.contentView addSubview:textView];
    
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0)
    {
        return YES;
}

//Compate the treatment methods of the therapist, to all the treatment methods existing in the database.
- (void) findAssociatedTherapists{
    if(self.threatmentsArray != nil){
        self.associatedMethods = [[NSMutableArray alloc] init];
        for(ThreatmentMethod *t in self.threatmentsArray){ // Short for- loop. Loops through all therapists
            for(NSString *s in self.currentTherapist.treatmentMethods){ // Loops through the threatmentmethods of a therapist.
                if([t.title isEqualToString:s]){ // if current method is associated with therapist
                   // NSLog(@"%@", t.title);
                    [self.associatedMethods addObject:t]; // add the therapist to associated therapists array.
                    NSLog(@"%lu", (unsigned long)self.associatedMethods.count);
                }
                
            }
        }
    }
    
}

#pragma mark - Navigation
//Segue that sends forward information from this view to the next.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"PushTreatmentInfo"])
    {
        
        NSIndexPath *indexPath = nil;
        


        
        indexPath = [self.tableView indexPathForCell:sender];
        ThreatmentMethod *method = self.associatedMethods[indexPath.row];
        
        ThreatmentInfoViewController *destViewController = segue.destinationViewController; // Getting new view controller
        destViewController.navigationItem.title = method.title; // Setting title in the navigation bar of next view
        [destViewController getThreatmentMethod:method]; // Passing object to ThreamentInfoController
        @try {
            NSString *introtext = [self.rd retrieveThreatmentInfoData:method.alias]; // Passing the ThreatmentMethod objects alias to get its info
            [method setIntroText:introtext];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }

    }
}


@end
