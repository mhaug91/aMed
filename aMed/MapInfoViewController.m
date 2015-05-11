//
//  MapInfoViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 21/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "MapInfoViewController.h"
/**
 *  This isn a simple view for dislplaying information about the Map view.
 */
@interface MapInfoViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MapInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self firstLabel];
    [self secondLabel];
    [self ThirdLabel];
    [self imageView];
    [self imageView2];
    [self FourthLabel];
    [self FifthLabel];
    [self SixthLabel];
    [self googleBtn];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  All of these labels are static textlabel.
 */
-(void) firstLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40) ];
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:(12.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Om nærmeste behandler:"];
}
-(void) secondLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 40.0, self.view.frame.size.width, 80) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 10;
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ArialMT" size:(12.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"På dette kartet vil du finne din egen posisjon(om dette er aktivert i dine innstillinger), du vil også finne de registrerte behandlerne som er aktive og som har registrert seg med addresse."];
}
-(void) ThirdLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 120.0, self.view.frame.size.width, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ArialMT" size:(12.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Symbolforklaring:"];
}

//Two imageViews thats show images of markers.
-(void) imageView{

    UIImageView *pinImage = [ [UIImageView alloc] initWithFrame:CGRectMake(0, 160, 30, 30)];

        pinImage.image = [UIImage imageNamed:@"glow-marker"];
        [self.contentView addSubview:pinImage];

}
-(void) imageView2{
    
    UIImageView *pinImage = [ [UIImageView alloc] initWithFrame:CGRectMake(0, 200, 30, 30)];
    
    pinImage.image = [UIImage imageNamed:@"blue-marker"];
    [self.contentView addSubview:pinImage];
    
}
-(void) FourthLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(80.0, 160.0, self.view.frame.size.width, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ArialMT" size:(12.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Registrert behandler:"];
}
-(void) FifthLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(80.0, 200.0, self.view.frame.size.width, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ArialMT" size:(12.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Din Posisjon:"];
}
-(void) SixthLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 240, self.view.frame.size.width, 80) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.numberOfLines = 10;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"ArialMT" size:(12.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Du kan ved å trykke på en av markørene finne ut hvem som er registrert på denne lokasjonen(hvis ingen markører vises frem i kartet, eller hvis du blir plassert på feil sted - prøv å starte om enheten!)."];
}

//Button sending the user to the google licensene view.
-(void) googleBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(googleLicense:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Se google lisens her" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 320.0, 160.0, 40.0);
    [self.contentView addSubview:button];
}

-(IBAction)googleLicense:(id)sender{
    [self performSegueWithIdentifier:@"showLicense" sender:sender];
}



@end
