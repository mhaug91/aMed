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

@interface TherapistViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TherapistViewController



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
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;

    tableView.delegate = self;
    tableView.dataSource = self;
    
    return tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(100, 200, 250,300)]; [[scrollView layer] setCornerRadius:10]; [[scrollView layer] setBorderColor: [[UIColor blackColor] CGColor]];
    [[scrollView layer] setBorderWidth:0.50];*/

    
    
    self.rd = [[RetrieveData alloc] init];
    self.therapists = [self.rd retrieveTherapists];
    self.threatmentsArray = [self.rd retrieveThreatmentsData];
    //UINavigationBar
    [self firstLabel];
    [self imageView];
    [self secondLabel];
   // [self addTreatmentMethods];
    [self textField];
    [self thirdlabel];
    self.tableView = [self makeTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TreatmentMethods"];
    [self.view addSubview:self.tableView];
    
    //self.view.backgroundColor = [UIColor grayColor];
}

- (void) getTherapistObject:(id)therapistObject{
    self.currentTherapist = therapistObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) firstLabel{
    NSString *company = self.currentTherapist.company;
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 43) ];
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Firmanavn: %@", company];
}
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
-(void) secondLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 243.0, self.view.frame.size.width, 43) ];
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Behandlingsmetoder:"];
}

-(void) addTreatmentMethods{
    double number = 0;
    for (int i = 0; i < self.currentTherapist.treatmentMethods.count; i++){
        NSString *tmethod = self.currentTherapist.treatmentMethods[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(buttonTapped:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:tmethod forState:UIControlStateNormal];
        button.frame = CGRectMake(0.0, (286.0 + number), self.view.frame.size.width, 40.0);
        number += 40;
        button.layer.borderWidth = 1;
        [self.contentView addSubview:button];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

        return [self.currentTherapist.treatmentMethods count];
        
}

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



- (IBAction)buttonTapped:(UIButton *)sender{
    [self performSegueWithIdentifier:@"PushTreatmentInfo" sender:sender];
    NSLog(@"Button Tapped!");
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *sender = [self.tableView cellForRowAtIndexPath:indexPath];

    [self performSegueWithIdentifier:@"PushTreatmentInfo" sender:sender];
}

-(void) thirdlabel{
    double distance = (self.currentTherapist.treatmentMethods.count * 40);
    
    NSString *address = self.currentTherapist.address.street;
    NSString *zipcode = [NSString stringWithFormat:@"%ld", self.currentTherapist.address.postcode];
    NSString *city = self.currentTherapist.address.city;
    NSString *state = self.currentTherapist.address.state;
    NSString *phone = [NSString stringWithFormat:@"%ld", self.currentTherapist.phone];
    
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, (326.0 + distance), self.view.frame.size.width, 100) ];
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Addresse: %@ \n Postnummer: %@ \n Sted: %@ \n Fylke: %@ \n Telefon: %@ \n Epost: --",address, zipcode, city, state, phone];
    label.numberOfLines = 6;
}
-(void) textField{
    double distance = (self.currentTherapist.treatmentMethods.count * 40);
    NSString *url = self.currentTherapist.website;
    
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(0.0,(286 + distance), self.view.frame.size.width, 40);
    textView.scrollEnabled = NO;
    textView.text=[NSString stringWithFormat:@"Nettsted: %@", url];
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



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"PushTreatmentInfo"])
    {
        NSString *title = self.selectedTreatmentMethod.title;
        
        NSIndexPath *indexPath = nil;
        ThreatmentMethod *method = nil;
        
        indexPath = [self.tableView indexPathForCell:sender];
        method = [self.currentTherapist.treatmentMethods objectAtIndex:indexPath.row];
        
        ThreatmentInfoViewController *destViewController = segue.destinationViewController; // Getting new view controller
        destViewController.navigationItem.title = title; // Setting title in the navigation bar of next view
        [destViewController getThreatmentMethod:method]; // Passing object to ThreamentInfoController
        NSString *introtext = [self.rd retrieveThreatmentInfoData:method.alias]; // Passing the ThreatmentMethod objects alias to get its info
        [method setIntroText:introtext]; //

    }
}


@end
