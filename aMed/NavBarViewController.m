//
//  NavBarViewController.m
//  aMed
//
//  Created by Kristofer Myhre on 09/03/15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "NavBarViewController.h"

@interface NavBarViewController ()
@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation NavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController = [self.storyboard
                             instantiateViewControllerWithIdentifier:@"TabBar"];
    [self.view insertSubview:self.tabBarController.view atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
