//
//  Meal.h
//  FoodTracker
//
//  Created by ad on 04/10/2016.
//  Copyright © 2016 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Meal : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *photo;
@property (assign, nonatomic) NSUInteger rating;

-(void) setName:(NSString *)name :(UIImage *)photo :(NSUInteger)rating;
+(NSString *)filePath;

@end
