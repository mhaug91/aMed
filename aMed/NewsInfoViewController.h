//
//  NyhetsVisningController.h
//  aMed
//
//  Created by MacBarhaug on 18.03.15.
//  Copyright (c) 2015 MacBarhaug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
/**
 *  Controlling the newsinfo view. 
 * Contains a webwiev with article.
 */
@interface NewsInfoViewController : UIViewController <UIAlertViewDelegate>

@property(strong, nonatomic) News *currentNews;

- (void) getNewsObject: (id) newsObject;

@end
