//
//  RatingControl.m
//  FoodTracker
//
//  Created by ad on 01/10/2016.
//  Copyright © 2016 1. All rights reserved.
//

#import "RatingControl.h"
@interface RatingControl()


@end


@implementation RatingControl

#define Spacing 5
#define starCount 5

#pragma mark -Initialization

-(void) setRating:(NSInteger)rating
{
    _rating = rating;
    [self setNeedsLayout];  //layout update
}

-(instancetype) initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
        _ratingButtons = [[NSMutableArray alloc] init];
        
        // 添加rating图片
        UIImage *filledStarImage = [UIImage imageNamed:@"filledStar"];
        UIImage *emptyStarImage = [UIImage imageNamed:@"emptyStar"];
        
        for(int i=0; i<starCount; ++i)
        {
            // 设置rating图片
            UIButton *button = [[UIButton alloc] init];
            [button setImage:filledStarImage forState:UIControlStateSelected];
            [button setImage:emptyStarImage forState:UIControlStateNormal];
            [button setImage:filledStarImage forState:UIControlStateHighlighted];
            
            button.backgroundColor = [UIColor redColor];
            
            button.adjustsImageWhenHighlighted = false;
            [button addTarget:self action:@selector(ratingButtonTapped:) forControlEvents:UIControlEventTouchDown];
            [_ratingButtons addObject:button];
            [self addSubview:button];
        }
    }
    return self;
}

-(void) layoutSubviews
{
    // 设置button的width/heigh为square frame的height
    CGFloat buttonSize = self.frame.size.height;
    CGRect buttonFrame = CGRectMake(0, 0, buttonSize, buttonSize);
    
    // 每一个button的origin为(length+Spacing)*origin
    for(UIButton *button in _ratingButtons)
    {
       
        buttonFrame = CGRectMake(([_ratingButtons indexOfObject:button])*(Spacing+buttonSize), 0, buttonSize, buttonSize);
        button.frame = buttonFrame;
    }
    [self updateButtonSelectionState];
}

-(CGSize) intrinsicContentSize
{
    CGFloat buttonSize = self.frame.size.height;
    int width = (buttonSize*starCount)+((starCount-1)*Spacing);
    return CGSizeMake(width, buttonSize);
}

#pragma mark -Actions-
-(void) ratingButtonTapped:(UIButton *)ButtonTapped
{
    NSLog(@"Button Tapped");
    _rating = [_ratingButtons indexOfObject:ButtonTapped]+1;
    [self updateButtonSelectionState];
}

-(void) updateButtonSelectionState
{
    for (UIButton *button in _ratingButtons)
    {
        button.selected = false;
        if ([_ratingButtons indexOfObject:button] < _rating)
        {
            button.selected = true;
        }
    }
}



@end
