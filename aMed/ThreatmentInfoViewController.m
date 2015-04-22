//
//  behInfoViewController.m
//  aMed
//
//  Created by MacBarhaug on 19.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "ThreatmentInfoViewController.h"

static NSString *CellIdentifier = @"newTherapistCell";

@interface ThreatmentInfoViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ThreatmentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWebView];
    self.rd = [[RetrieveData alloc] init];
    self.allTherapists = [self.rd retrieveTherapists];
    [self findAssociatedTherapists];
    //if(self.associatedTherapists.count != 0){
        self.tableView = [self makeTableView];
        [self.view addSubview:self.tableView];
    //}
    //else{
        //[self.view addSubview:[self makeLabel]];
        // make a label telling theres no ssociated therapists with this treatment method.
    //}
}



#pragma marks
#pragma mark Methods

- (void) getThreatmentMethod:(id)threatmentObject{
    self.currentMethod=threatmentObject;
}

/* Puts the introtext made of html inside the webview
 * Some adjustments to the string has to be made to display well.
 */
- (void) setWebView{
    self.htmlString = self.currentMethod.introText; // stores the introtext in an own variable
    
    /* If the image path is bad, for example: "images/...", replace it with the full path: */
    if ([self.htmlString rangeOfString:@"images"].location != NSNotFound) { // If the substring "images" is found
        self.htmlString = [self.currentMethod.introText stringByReplacingOccurrencesOfString:@"images" withString:@"https://www.amed.no/images"];
    }
    
    /* Amed.no (the website) has a custom backbutton used on the pages for the
     * treatment methods. This has to be removed from the text: */
    self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"{backbutton}" withString:@""];
    
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
    
}

/* This method finds the associated therapists with the current threatmentmethod */
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

//Creates the tableview.
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
        //cell.textLabel.text = name;

        NSString *imagepath = [NSString stringWithFormat:@"https://www.amed.no/images/comprofiler/%@", therapist.avatar];

        cell.imageView.image = [UIImage imageNamed:imagepath];
        NSString *therapistTreatments = [[therapist.treatmentMethods valueForKey:@"description"] componentsJoinedByString:@", "];
        NSString *noAvatar = @"https://www.amed.no/components/com_comprofiler/plugin/templates/default/images/avatar/nophoto_n.png";
        if([therapist.avatar isEqual:[NSNull null]]){
            NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:noAvatar]];
            cell.imageView.image = [UIImage imageWithData:image];
            
    
        } else {
            NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagepath]];
            cell.imageView.image = [UIImage imageWithData:image];
    
        }
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.text = therapist.company;
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.font = font;
        NSString *description = [NSString stringWithFormat:@"%@\r%@", name, therapistTreatments];
        cell.detailTextLabel.text = description;
        return cell;
}


//Method which creates the tableView

-(UITableView *)makeTableView
{
    double number = 139;
    number = 139;
    CGFloat x = 0;
    CGFloat y = 400;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = number;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    tableView.rowHeight = 50;
    tableView.sectionHeaderHeight = 22;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    
    return tableView;
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
