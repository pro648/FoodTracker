//
//  MealTableViewCell.m
//  FoodTracker
//
//  Created by ad on 05/10/2016.
//  Copyright © 2016 1. All rights reserved.
//

#import "MealTableViewCell.h"
@interface MealTableViewCell()

@end

@implementation MealTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.ratingControl.userInteractionEnabled = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
