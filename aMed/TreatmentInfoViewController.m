//
//  behInfoViewController.m
//  aMed
//
//  Created by MacBarhaug on 19.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "TreatmentInfoViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


/**
 *  Cell identifier.
 @note This cell is not made in the storyboard. It is used to create new cells programatically.
 */
static NSString *CellIdentifier = @"newTherapistCell";

@interface TreatmentInfoViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation TreatmentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.spinner];
    [self.spinner setColor:UIColorFromRGB(0x602167)];
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.spinner startAnimating];
    self.rd = [[RetrieveData alloc] init];
     @try {
         self.allTherapists = [self.rd retrieveTherapists];
     }
    @catch (NSException *exception) {
    }


    [self findAssociatedTherapists]; /// Finds the associated therapists.

}



#pragma marks
#pragma mark Methods
/*
NSString *introtext = [self.rd retrieveThreatmentInfoData:method.alias]; // Retrieve introtext from selected treatment. (The introtext is the article text about the treatment).
[method setIntroText:introtext]; /// Set the method's introtext.
*/

/**
 *  This method is only in use when viewDidLoad doesnt retrieve data from database.
 *
 */
- (void) viewDidAppear:(BOOL)animated{
    @try {
            self.introText = [self.rd retrieveThreatmentInfoData:self.currentMethod.alias];
    
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
    [self setWebView];
    
    [self.spinner stopAnimating];
}



- (void) getThreatmentMethod:(id)threatmentObject{
    self.currentMethod=threatmentObject;
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
    self.htmlString = self.introText; // stores the introtext in an own variable
    NSString *videoSize = [NSString stringWithFormat:@"width=\"%f\" height=\"%f\"", self.contentView.frame.size.width/2, self.contentView.frame.size.width/2];
    
    /* If the image path is bad, for example: "images/...", replace it with the full path: */
    if ([self.htmlString rangeOfString:@"https://www.amed.no/OLD/images"].location == NSNotFound) { // If the substring "images" is not found
        
        self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"images" withString:@"https://www.amed.no/OLD/images"];
        
    }
    
    /* Scales the video image to be smaller. */
    if([self.htmlString rangeOfString:@"width=\"560\" height=\"315\""].location != NSNotFound){
        self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"width=\"560\" height=\"315\"" withString:videoSize];
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

        

        NSString *therapistTreatments = [[therapist.treatmentMethods valueForKey:@"description"] componentsJoinedByString:@", "];
        if([therapist.avatar isEqual:[NSNull null]]){
            cell.imageView.image = [UIImage imageNamed:@"emptyProfil"];
            CGSize itemSize = CGSizeMake(45, 50);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
    
        } else {
            /* Tror dette skal være riktig. Ikke inkludert i nyeste versjon av appen */
            NSString *imagepath = [NSString stringWithFormat:@"https://www.amed.no/OLD/images/comprofiler/%@", therapist.avatar];
            NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagepath]];
            cell.imageView.image = [UIImage imageWithData:image];
            //cell.imageView.image = [UIImage imageWithData:image];
            CGSize itemSize = CGSizeMake(45, 50);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
    
        }
        cell.textLabel.numberOfLines = 1;
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
        return @"Ingen behandlere funnet";
    }
}



/** Creates a label saying there's no associated therapists.
* @note Method not in use .
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



@end
