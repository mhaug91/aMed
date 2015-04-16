//
//  TherapistViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 14/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "TherapistViewController.h"

#define getDataTherapistsURL @"http://www.amed.no/AmedApplication/getTherapists.php"

@interface TherapistViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation TherapistViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(100, 200, 250,300)]; [[scrollView layer] setCornerRadius:10]; [[scrollView layer] setBorderColor: [[UIColor blackColor] CGColor]];
    [[scrollView layer] setBorderWidth:0.50];*/

    
    
    self.rd = [[RetrieveData alloc] init];
    self.therapists = [self.rd retrieveTherapists];
    //UINavigationBar
    [self firstLabel];
    [self imageView];
    [self secondLabel];
    [self addTreatmentMethods];
    [self textField];
    [self thirdlabel];
    
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


- (IBAction)buttonTapped:(UIButton *)sender{
    ThreatmentInfoViewController *viewController = [[ThreatmentInfoViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    NSLog(@"Button Tapped!");
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
