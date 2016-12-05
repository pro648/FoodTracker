//
//  ViewController.m
//  FoodTracker
//
//  Created by ad on 01/10/2016.
//  Copyright © 2016 1. All rights reserved.
//

#import "ViewController.h"
@interface ViewController()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet RatingControl *ratingControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) UITapGestureRecognizer *tapOne;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapTwo;
@property (strong, nonatomic) UITapGestureRecognizer *singleClick;
@property (strong, nonatomic) UITapGestureRecognizer *doubleClick;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

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
    
    // 添加scrollView和imageView用来放大图片
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.delegate = self;
    _scrollView.bouncesZoom = YES;
    _scrollView.contentMode = UIViewContentModeScaleAspectFit;
    _scrollView.contentSize = _scrollView.frame.size;
    _scrollView.minimumZoomScale = 1.0;
    [self.view addSubview:_scrollView];
    [self.view sendSubviewToBack:_scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;     //禁止View Controller自动调整scrollView布局，否则会出现图片偏下。
    
    _imageView = [[UIImageView alloc] initWithFrame:_photoImageView.frame];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    [_scrollView addSubview:_imageView];
    
    _tapTwo.numberOfTapsRequired = 2;
    
    // photoImageView上添加单击手势
    _tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAct:)];
    [_photoImageView addGestureRecognizer:_tapOne];
    [_tapOne requireGestureRecognizerToFail:_tapTwo];
    
    // imageView上添加单击手势
    _singleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClickAct:)];
    [_scrollView addGestureRecognizer:_singleClick];
    
    // imageView上添加双击手势
    _doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClickAct:)];
    _doubleClick.numberOfTapsRequired = 2;
    [_scrollView addGestureRecognizer:_doubleClick];
    [_singleClick requireGestureRecognizerToFail:_doubleClick];
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

-(void)tapOneAct:(UITapGestureRecognizer *)tapOne  //photoImageView单击手势
{
    [self.view bringSubviewToFront:_scrollView];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.userInteractionEnabled = YES;
    self.navigationController.navigationBarHidden = YES;
    
    [self performSelector:@selector(setAnimation ) withObject:nil afterDelay:0.3];
}

-(void)setAnimation
{
    // 获取图片
    UIImage *image = _photoImageView.image;
    _imageView.image = image;
    
    float viewHeight = self.view.frame.size.height;
    float viewWidth = self.view.frame.size.width;
    
    if (image)
    {
        //判断缩放比
        float scaleX = viewWidth / image.size.width;
        float scaleY = viewHeight / image.size.height;
        
        if (scaleX <= scaleY)
        {
            // X先到边缘
            float imageHeight = image.size.height * scaleX;
            _scrollView.maximumZoomScale = viewHeight / imageHeight;
            CGRect rect = CGRectMake(0, viewHeight/2 - imageHeight/2, viewWidth, imageHeight);
            [UIView animateWithDuration:0.3 animations:^{
                _imageView.frame = rect;
            }];
        }
        else if (scaleX > scaleY)
        {
            // Y先到边缘
            float imageWidth = image.size.width * scaleY;
            _scrollView.maximumZoomScale = viewWidth / imageWidth;
            CGRect rect = CGRectMake(viewWidth/2 - imageWidth/2, 0, imageWidth, viewHeight);
            [UIView animateWithDuration:0.3 animations:^{
                _imageView.frame = rect;
            }];
        }
    }
}

-(void)singleClickAct:(UITapGestureRecognizer *)singleClick     //imageView单击弹出的图片返回
{
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = NO;
        [self.view sendSubviewToBack:_scrollView];
        _scrollView.userInteractionEnabled = NO;
        _imageView.frame = _photoImageView.frame;
        [_imageView setImage:nil];
    }];
    
    // 大图单击直接返回时，缩放值初始化
    _scrollView.zoomScale = 1.0;
}

-(void)doubleClickAct:(UITapGestureRecognizer *)doubleClick     //imageView双击操作
{
     if (_scrollView.zoomScale == _scrollView.minimumZoomScale)
         
        //缩放值为空或者1.0时，双击将图片最大化
        [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
    
    else if (_scrollView.zoomScale > _scrollView.minimumZoomScale)
    
        // 缩放值大于最小值1.0时，双击将图片缩放到最小值
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
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

#pragma mark scrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGPoint centerPoint = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
    
    if (_imageView.frame.size.width <= scrollView.frame.size.width)
    {
        centerPoint.x = scrollView.frame.size.width/2;
    }
    
    if (_imageView.frame.size.height <= scrollView.frame.size.height)
    {
        centerPoint.y = scrollView.frame.size.height/2;
    }
    _imageView.center = centerPoint;
    
    NSLog(@"scrollView.ZoomScale = %f", scrollView.zoomScale);  //输出当前缩放比
}

@end
