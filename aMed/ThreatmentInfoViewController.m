//
//  behInfoViewController.m
//  aMed
//
//  Created by MacBarhaug on 19.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "ThreatmentInfoViewController.h"

static NSString *finnBehandlerID = @"TherapistCell";

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
    self.tableView = [self makeTableView];
    if(self.tableView == nil) NSLog(@"Tom tabell");
    else [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:finnBehandlerID];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.webView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    aWebView.scrollView.scrollEnabled = YES;    // Property available in iOS 5.0 and later
    CGRect frame = aWebView.frame;
    
    frame.size.width = self.view.frame.size.width;       // Your desired width here.
    frame.size.height = 400;        // Set the height to a small one.
    
    aWebView.frame = frame;       // Set webView's Frame, forcing the Layout of its embedded scrollView with current Frame's constraints (Width set above).
}

/* This method finds the associated therapists with the current threatmentmethod */
- (void) findAssociatedTherapists{
    if(self.allTherapists != nil){
        self.associatedTherapists = [[NSMutableArray alloc] init];
        for(Therapists *t in self.allTherapists){ // Short for- loop. Loops through all therapists
            for(NSString *s in t.treatmentMethods){ // Loops through the threatmentmethods of a therapist.
                if([self.currentMethod.title isEqualToString:s]){ // if current method is associated with therapist
                    NSLog(@"%@", t.firstName);
                    [self.associatedTherapists addObject:t]; // add the therapist to associated therapists array.
                }

            }
        }
    }
    
    
}

//Creates the tableview.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [self.associatedTherapists count];
    
}

//Defines each cell of the table view.
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Therapists *terapist = nil;
    
    terapist = [self.associatedTherapists objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@", terapist.firstName];
    cell.textLabel.text = title;
    
    
    return cell;
}
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                         finnBehandlerID forIndexPath:indexPath];
if(cell == nil){
    cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleSubtitle
            reuseIdentifier:finnBehandlerID];
}

Therapists *therapist = nil;
therapist = [self.associatedTherapists objectAtIndex:indexPath.row];
NSString *name = [NSString stringWithFormat:@"%@ %@", therapist.firstName, therapist.lastName];
cell.textLabel.text = name;

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
    



cell.textLabel.text = therapist.company;
cell.textLabel.font = [UIFont fontWithName:@"Calibri" size:12];
cell.textLabel.textAlignment = NSTextAlignmentRight;


NSString *description = [NSString stringWithFormat:@"%@\r%@", name, therapistTreatments];
cell.detailTextLabel.text = description;
cell.detailTextLabel.numberOfLines = 2;


return cell;
}


//Method which creates the tableView
-(UITableView *)makeTableView
{
    double number = 0;
    for (int i = 0 ; i<self.associatedTherapists.count; i++) {
        number += 40;
    }
    if(number == 0) return nil;
    
    CGFloat x = 0;
    CGFloat y = 440;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = number;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 400, width, 40)];
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, width, 40)];
    labelView.text = @"uhuh";
    labelView.backgroundColor = [UIColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.0];
    [headerView addSubview:labelView];
    tableView.tableHeaderView = headerView;
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






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
