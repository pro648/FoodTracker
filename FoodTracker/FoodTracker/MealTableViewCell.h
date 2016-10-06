//
//  MealTableViewCell.h
//  FoodTracker
//
//  Created by ad on 05/10/2016.
//  Copyright © 2016 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingControl.h"
#import "ViewController.h"

@interface MealTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet RatingControl *ratingControl;


@end
