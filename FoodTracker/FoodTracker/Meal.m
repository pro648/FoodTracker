//
//  Meal.m
//  FoodTracker
//
//  Created by ad on 04/10/2016.
//  Copyright © 2016 1. All rights reserved.
//

#import "Meal.h"

@implementation Meal

-(void) setName:(NSString *)name :(UIImage *)photo :(NSUInteger)rating
{
    _name = name;
    _photo = photo;
    _rating = rating;
}

@end
