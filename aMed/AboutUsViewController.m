//
//  AboutUsViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 21/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imageView];
    [self firstLabel];
    [self secondLabel];
    [self ThirdLabel];
    [self addFacebookButton];
    [self addTwitterButton];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) imageView{
    
    UIImageView *pinImage = [ [UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, 200)];
    pinImage.image = [UIImage imageNamed:@"ic_amed_logo"];
    [self.contentView addSubview:pinImage];
    
}

-(void) firstLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 200.0, self.view.frame.size.width, 100) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.numberOfLines = 10 ;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Amed.no er et samlested for folk med interesse innen alternativ medisin og behandling. Amed inneholder informasjon om alternativ behandling,kurs/messer/festivaler innenfor alternativ medisin, nyheter, behandlingsmetoder og mye mer. Man kan også finne de alternative behandlerne som er registrert hos oss!"];
}

-(void) secondLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 300.0, self.view.frame.size.width, 200) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.numberOfLines = 115 ;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat: @"Applikasjonen aMed er en mobilvennlig versjon av nettsiden amed.no, og ble utviklet våren 2013. Nettstedet ble forøvrig introdusert for Internett i februar 2012.\n\nDet dukker stadig vekk opp nye nettsted innenfor alternativ behandling. Vi har som målsetting å være en av de mest oppdaterte sidene innenfor emnet.\n\nHar du forslag til endringer, eller reagerer du over noe på nettstedet? Ta kontakt!\nSå langt det er mulig vil vi gjøre det vi kan for at din feedback kommer brukerne av nettstedet til gode."];
}

-(void) ThirdLabel{
    UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 500.0, 100, 40) ];
    label.textAlignment =  NSTextAlignmentLeft;
    label.numberOfLines = 2;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat:@"Følg oss på:"];
}

- (void)addFacebookButton{    // Method for creating button, with background image and other properties
    
    UIButton *faceBookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    faceBookButton.frame = CGRectMake(110.0, 500, 40, 40);
    faceBookButton.backgroundColor = [UIColor clearColor];
    UIImage *buttonImageNormal = [UIImage imageNamed:@"facebook"];
    UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [faceBookButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"facebook_clicked"];
    UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [faceBookButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];
    [faceBookButton addTarget:self action:@selector(facebookAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:faceBookButton];
}
- (void)addTwitterButton{    // Method for creating button, with background image and other properties
    
    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    twitterButton.frame = CGRectMake(180.0, 500, 40, 40);
    twitterButton.backgroundColor = [UIColor clearColor];
    UIImage *buttonImageNormal = [UIImage imageNamed:@"twitter"];
    UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [twitterButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"twitter_clicked"];
    UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [twitterButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];
    [twitterButton addTarget:self action:@selector(twitterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twitterButton];
}


-(IBAction)facebookAction:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://m.facebook.com/pages/Amedno-Nettsted-for-aktuell-og-alternativ-medisin/151872066743"]];
}

-(IBAction)twitterAction:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/amedno"]];
}


@end
