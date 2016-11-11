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

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"MealNameKey"];
    [aCoder encodeObject:_photo forKey:@"MealPhotoKey"];
    [aCoder encodeInteger:_rating forKey:@"MealRatingKey"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    _name = [aDecoder decodeObjectForKey:@"MealNameKey"];
    _photo = [aDecoder decodeObjectForKey:@"MealPhotoKey"];
    _rating = [aDecoder decodeIntegerForKey:@"MealRatingKey"];
    
    return self;
}

+(NSString *)filePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *documentDirectoryPath = [path objectAtIndex:0];
    NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:@"componentData"];
    
    return filePath;
}

@end
