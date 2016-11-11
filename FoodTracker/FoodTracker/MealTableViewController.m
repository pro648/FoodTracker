//
//  MealTableViewController.m
//  FoodTracker
//
//  Created by ad on 05/10/2016.
//  Copyright © 2016 1. All rights reserved.
//

#import "MealTableViewController.h"

@interface MealTableViewController ()

@property (nonatomic, strong) NSMutableArray *mealsArray;
@property (nonatomic, strong) NSMutableArray *deleteArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectBarButtonItem;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressCell;

@end

@implementation MealTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _deleteArray = [NSMutableArray new];
    _mealsArray = [NSMutableArray new];
    
    // 加载数据
    if ([self loadMealData] != nil)
    {
        NSArray *loadMealArray = [self loadMealData];
        [_mealsArray addObjectsFromArray:loadMealArray];
    }
    else
    {
        [self loadSampleMeals];
    }
        [self loadBarButtonItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadSampleMeals
{
    //示例数据
    
    UIImage *photo1 = [UIImage imageNamed:@"meal1"];
    UIImage *photo2 = [UIImage imageNamed:@"meal2"];
    UIImage *photo3 = [UIImage imageNamed:@"meal3"];
    
    Meal *meal1 = [[Meal alloc] init];
    Meal *meal2 = [Meal new];
    Meal *meal3 = [Meal new];
    
    [meal1 setName:@"Caprese Salad" :photo1 :4];
    [meal2 setName:@"Chicken and Potatoes" :photo2 :5];
    [meal3 setName:@"Pasta with Meatballs" :photo3 :3];
    
    _mealsArray = [[NSMutableArray alloc] initWithObjects:meal1, meal2, meal3, nil];
}

-(void) loadBarButtonItems
{
    _editBarButtonItem.title = @"编辑";
    _selectBarButtonItem.title = @"";
    _selectBarButtonItem.enabled = false;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mealsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MealTableViewCell";
    MealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    
    Meal *meal = [Meal new];
    meal = [_mealsArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = meal.name;
    cell.photoImageView.image = meal.photo;
    cell.ratingControl.rating = meal.rating;
    
    //长按手势
    _longPressCell = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(longPressAct:)];
    _longPressCell.minimumPressDuration = 1;
    [cell.contentView addGestureRecognizer:_longPressCell];
    
    return cell;
}


-(void) longPressAct:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        // 获取长按位置的indexPath
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        if (indexPath != nil)
        {
            self.tableView.editing = true;
            _editBarButtonItem.title = @"删除";
            _selectBarButtonItem.title = @"全选";
            _selectBarButtonItem.enabled = true;
            
            // 选中长按的row 同时加入_deleteArray
            [self.tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionTop];
            [_deleteArray addObject:[_mealsArray objectAtIndex:indexPath.row]];
        }
    }
}

#pragma mark edit

// 编辑按钮的功能
- (IBAction)editBarButtonItemTapped:(UIBarButtonItem *)sender
{
    if ([_editBarButtonItem.title isEqualToString:@"编辑"])
    {
        _editBarButtonItem.title = @"删除";
        _selectBarButtonItem.enabled = true;
        _selectBarButtonItem.title = @"全选";
        self.tableView.editing = true;
    }
    else if ([_editBarButtonItem.title isEqualToString:@"删除"])
    {
        _editBarButtonItem.title = @"编辑";
        _selectBarButtonItem.title = @"";
        _selectBarButtonItem.enabled = false;
        self.tableView.editing = false;
        
        [_mealsArray removeObjectsInArray:_deleteArray];
        [self saveMealData];
        [self.tableView reloadData];
    }
}

// 全选按钮的功能
- (IBAction)selectBarButtonItemTapped:(UIBarButtonItem *)sender
{
    if ([_selectBarButtonItem.title isEqualToString:@"全选"])
    {
        _selectBarButtonItem.title = @"取消全选";
        
        // 选中所有cell
        for (int row=0; row<_mealsArray.count; ++row)
        {
            NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:row
                                                              inSection:0];
            
            [self.tableView selectRowAtIndexPath:deleteIndexPath
                                        animated:true
                                  scrollPosition:UITableViewScrollPositionTop];
        }
        
        [_deleteArray addObjectsFromArray:_mealsArray];
    }
    else if ([_selectBarButtonItem.title isEqualToString:@"取消全选"])
    {
        _selectBarButtonItem.title = @"";
        _selectBarButtonItem.enabled = false;
        _editBarButtonItem.title = @"编辑";
        self.tableView.editing = false;
        
        [_deleteArray removeAllObjects];
    }
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete  |  UITableViewCellEditingStyleInsert;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing == true)     // important
        [_deleteArray addObject:[_mealsArray objectAtIndex:indexPath.row]];
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_deleteArray removeObject:[_mealsArray objectAtIndex:indexPath.row]];
}


#pragma mark - Navigation

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(self.tableView.editing != true)      // tableview处于编辑状态时禁用segue
        return true;
    else
        return false;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDetail"])
    {
        // segue为ShowDetail时，为meal准备数据
        ViewController *ShowDetailViewController = segue.destinationViewController;
        
        if (sender != nil)
        {
            MealTableViewCell *selectedMealCell = sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedMealCell];
            Meal *selectedMeal = [Meal new];
            selectedMeal = [_mealsArray objectAtIndex:indexPath.row];
            ShowDetailViewController.meal = selectedMeal;
        }
    }
    else if ([segue.identifier isEqualToString:@"AddItem"])
    {
        // Add a new meal.
    }
        
}

-(IBAction)unwindToMealList:(UIStoryboardSegue *)sender
{
    if (sender.sourceViewController != nil)
    {
        ViewController *sourceViewController = sender.sourceViewController;
        if (sourceViewController.meal != nil)
        {
            Meal *meal = sourceViewController.meal;
            
            if ([self.tableView indexPathForSelectedRow] != nil)
            {
                // 编辑已存在meal
                NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
                _mealsArray[selectedIndexPath.row] = meal;
                NSArray *selectedIndexPathArray = [NSArray arrayWithObject:selectedIndexPath];
                [self.tableView reloadRowsAtIndexPaths:selectedIndexPathArray
                                      withRowAnimation:UITableViewRowAnimationTop];
            }
            else
            {
                // 增加meal
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:_mealsArray.count inSection:0];
                [_mealsArray addObject:meal];
                
                NSArray *newIndexPathArray = [NSArray arrayWithObject:newIndexPath];
                [self.tableView insertRowsAtIndexPaths:newIndexPathArray
                                      withRowAnimation:UITableViewRowAnimationTop];
                
            }
            
            // Save Meal Data
            [self saveMealData];
        }
    }
}

#pragma mark -Save Data

-(void)saveMealData
{
    BOOL isSuccessfull = [NSKeyedArchiver archiveRootObject:_mealsArray toFile:[Meal filePath]];
    
    if (!isSuccessfull)
    {
        NSLog(@"Failed to save data");
    }
}

-(NSArray *)loadMealData
{
    if ([NSKeyedUnarchiver unarchiveObjectWithFile:[Meal filePath]] != nil)
    {
        NSArray *loadArr = [NSKeyedUnarchiver unarchiveObjectWithFile:[Meal filePath]];
        return loadArr;
    }
    
    else
        return nil;
}


@end
