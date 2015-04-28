//
//  GoogleLicenseViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 28/04/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "GoogleLicenseViewController.h"

@interface GoogleLicenseViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation GoogleLicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setWebView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setWebView{
    self.htmlString = [GMSServices openSourceLicenseInfo]; // stores the introtext in an own variable
    
    self.lisensString = @"Under følger en utfyllende lisens fra Google Inc. som gjør det mulig, for oss som utviklere, å ta i bruk Google Maps Api i denne applikasjonen. Dette gjør at du som bruker ikke behøver å gå ut av applikasjonen for å se på et kart for å finne nærmeste behandler eller kommende arrangementer. Det er ikke nødvendig å lese lisensen, den er der kun for opphavsrettighetens skyld. Om det skulle være ønskelig å lese mer om opphavsrettene, kan du trykke på linkene som er markert med blå tekst.<br><br>";
    
    self.combinedString = [NSString stringWithFormat:@"<b>Google Lisens</b><br><br>%@ %@", self.lisensString, self.htmlString];

    [self.webView loadHTMLString:self.combinedString baseURL:nil];
    
}


@end
