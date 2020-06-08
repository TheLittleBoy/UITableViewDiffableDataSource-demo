//
//  DetailViewController.h
//  test2
//
//  Created by Mac on 2020/6/8.
//  Copyright © 2020 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

