//
//  ViewController.m
//  FoodTracker
//
//  Created by ad on 01/10/2016.
//  Copyright © 2016 1. All rights reserved.
//

#import "ViewController.h"
@interface ViewController()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet RatingControl *ratingControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;


@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [_ratingControl layoutIfNeeded];
    
    _nameTextField.delegate = self;
    _photoImageView.userInteractionEnabled = true;
    _nameTextField.userInteractionEnabled = true;
    
    // 如果来自meallist，加载meal数据
    if (_meal != nil)
    {
        self.nameTextField.text = _meal.name;
        self.photoImageView.image = _meal.photo;
        self.ratingControl.rating = _meal.rating;
    }
    
    [self checkValidMealName];
}

#pragma mark -Actions-
- (IBAction)selectImageFromPhotoLibrary:(UITapGestureRecognizer *)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    // 复制图片
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:true completion:nil];
}


#pragma mark -Delegate=
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    // textField开始输入时禁用saveButton
    _saveButton.enabled = false;
}

-(void)checkValidMealName
{
    // 移除_nameTextField.text两端的whitespace
    _nameTextField.text = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // 在_nameTextField.text为空时 禁用saveButton
    ([_nameTextField.text isEqualToString:@""]) ? (_saveButton.enabled = false) : (_saveButton.enabled = true);
}

// 点击view其他区域时隐藏键盘
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_nameTextField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  true;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [self checkValidMealName];
    
    self.navigationController.title = _nameTextField.text;
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 选择照片页cancel的实现
    [self dismissViewControllerAnimated:true completion:nil];
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 选取photo
    _photoImageView.image = info[UIImagePickerControllerOriginalImage];
    
    // Dismiss the picker.
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark -Navigation-
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (_saveButton == sender)
    {
        _meal = [Meal new];
        
        NSString *name = _nameTextField.text;
        UIImage *photo = _photoImageView.image;
        NSInteger rating = _ratingControl.rating;
        
        [_meal setName:name :photo :rating];
    }
}

- (IBAction)cancelBarButtonTapped:(UIBarButtonItem *)sender
{
    // 根据弹出方式退出
    if ([self.presentingViewController isKindOfClass:[UINavigationController class]])
        [self dismissViewControllerAnimated:true completion:nil];
    else
        [self.navigationController popViewControllerAnimated:true];
}

@end
