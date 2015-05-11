//
//  behInfoViewController.m
//  aMed
//
//  Created by MacBarhaug on 19.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "TreatmentInfoViewController.h"


/**
 *  Cell identifier.
 @note This is not made in the storyboard. It is used to create new cells programatically.
 */
static NSString *CellIdentifier = @"newTherapistCell";

@interface TreatmentInfoViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation TreatmentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWebView];
    @try {
        self.rd = [[RetrieveData alloc] init];
        self.allTherapists = [self.rd retrieveTherapists]; /// Fills array with all therapists from DB. (See RetrieveData.m).
    }
    @catch (NSException *exception) {

    }

    [self findAssociatedTherapists]; /// Finds the associated therapists. 
}



#pragma marks
#pragma mark Methods

- (void) getThreatmentMethod:(id)threatmentObject{
    self.currentMethod=threatmentObject;
}


/**
 *  This method is only in use when viewDidLoad doesnt retrieve data from database.
 *
 */
- (void) viewDidAppear:(BOOL)animated{
    @try {
        if (self.allTherapists.count == 0) {
            self.rd = [[RetrieveData alloc] init];
            self.allTherapists = [self.rd retrieveTherapists];
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
        [self.view setNeedsDisplay];
    }
}


/**
 *  Handles the alertview that shows when no internet or other exception.
 *
 *
 */
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
 *  Inserts the introtext (the article text) of the treatment inside the webview.
 Some adjustments has to be made to display as we want it.
 
 @note The introtext from the database is in HTML format. We save it in an own variable htmlString.
 */
- (void) setWebView{
    self.htmlString = self.currentMethod.introText; // stores the introtext in an own variable
    NSString *videoSize = [NSString stringWithFormat:@"width=\"%f\" height=\"%f\"", self.contentView.frame.size.width/2, self.contentView.frame.size.width/2];
    
    /* If the image path is bad, for example: "images/...", replace it with the full path: */
    if ([self.htmlString rangeOfString:@"images"].location != NSNotFound) { // If the substring "images" is found
        self.htmlString = [self.currentMethod.introText stringByReplacingOccurrencesOfString:@"images" withString:@"https://www.amed.no/images"];
    }
    
    /* Scales the video image to be smaller. */
    if([self.htmlString rangeOfString:@"width=\"560\" height=\"315\""].location != NSNotFound){
        self.htmlString = [self.currentMethod.introText stringByReplacingOccurrencesOfString:@"width=\"560\" height=\"315\"" withString:videoSize];
    }
    
    /* Amed.no (the website) has a custom backbutton used on the pages for the
     * treatment methods. This has to be removed from the text: */
    self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"{backbutton}" withString:@""];
    
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
    
}

/**
 * This method finds the associated therapists with the current threatmentmethod 
 */
- (void) findAssociatedTherapists{
    if(self.allTherapists != nil){
        self.associatedTherapists = [[NSMutableArray alloc] init];
        for(Therapists *t in self.allTherapists){ // Short for- loop. Loops through all therapists
            for(NSString *s in t.treatmentMethods){ // Loops through the threatmentmethods of a therapist.
                if([self.currentMethod.title isEqualToString:s]){ // if current method is associated with therapist
                    [self.associatedTherapists addObject:t]; // add the therapist to associated therapists array.
                }

            }
        }
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.associatedTherapists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        Therapists *therapist = nil;
        therapist = [self.associatedTherapists objectAtIndex:indexPath.row];
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
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.text = therapist.company;
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.font = font;
        NSString *description = [NSString stringWithFormat:@"%@\r%@", name, therapistTreatments];
        cell.detailTextLabel.text = description;
        return cell;
}



- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if(self.associatedTherapists.count != 0){
        return @"Behandlere";
    }
    else{
        //tableView.tableHeaderVie
        return @"Ingen behandlere funnet";
    }
}



/* Creates a label saying there's no associated therapists.
*Method not in use .
*/
- (UILabel *) makeLabel
{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 400, self.view.frame.size.width, 139) ];
    label.textColor = [UIColor redColor];
    label.text = @"Ingen behandlere funnet";
    return label;
}

//Tells the application what to do when a table cell is pressed.
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *sender = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"pushTerapistInfo" sender:sender];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"pushTerapistInfo"])
    {
        
        NSIndexPath *indexPath = nil;
        Therapists *terapist = nil;
        NSString *title = terapist.company;
        
        indexPath = [self.tableView indexPathForCell:sender];
        terapist = [self.associatedTherapists objectAtIndex:indexPath.row];
        
        TherapistViewController *destViewController = segue.destinationViewController; // Getting new view controller
        destViewController.navigationItem.title = title; // Setting title in the navigation bar of next view
        [destViewController getTherapistObject:terapist];
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 
 //Tells the application what to do when a table cell is pressed.
 - (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *sender = [self.tableView cellForRowAtIndexPath:indexPath];
 
 [self performSegueWithIdentifier:@"PushTreatmentInfo" sender:sender];
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
 NSString *introtext = [self.rd retrieveThreatmentInfoData:method.alias]; // Passing the ThreatmentMethod objects alias to get its info
 [method setIntroText:introtext];
 
 }
 }


 */

@end
