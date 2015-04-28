//
//  FirstViewController.m
//  aMed
//
//  Created by MacBarhaug on 09.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import "NewsViewController.h"

static NSString *newsTableIdentifier = @"NewsTableIdentifier";

@interface NewsViewController ()

@property (copy, nonatomic) NSArray *dwarves;

@end

@implementation NewsViewController{
    NSMutableArray *filteredNames;
    NSArray *searchResults;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rd = [[RetrieveData alloc] init];
    self.newsArray = [self.rd retrieveNewsData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods


#pragma marks
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
        return [self.newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:
                             newsTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:newsTableIdentifier];
    }
    News *news = [self.newsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = news.title;
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"pushNewsInfo"]) {
         NSLog(@"pushNewsInfo");
         
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
         News *news = [self.newsArray objectAtIndex:indexPath.row];
         NewsInfoViewController *destVC = segue.destinationViewController;
         [news setIntroText:[self.rd retrieveNewsInfoData:news.alias]];
         destVC.navigationItem.title = news.title;
         [destVC getNewsObject:news];
         
         
    }
}




@end
