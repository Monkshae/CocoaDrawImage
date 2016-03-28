//
//  FirstViewController.m
//  CocoaDrawImage
//
//  Created by Mabye on 13-12-23.
//  Copyright (c) 2013年 Maybe. All rights reserved.
//

#import "FirstViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FirstViewController ()
{
    CIContext *_context;
    CIFilter *_filter;
    CIImage *_beginImage;
    UIImageView *_imageView;
    UIImageOrientation _orientation; // New!
}
@property(nonatomic,retain)UIImageView *imageView;
@end

@implementation FirstViewController
@synthesize imageView  = _imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"DrwaImage";
    if ([[UIDevice currentDevice]systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100,320,213)];
    [self.view addSubview:self.imageView];
//    UIImage *image = [UIImage imageNamed:@"night_comment_zan_icon_pre"];
//    CGSize sz = [image size];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//    imageView.frame = CGRectMake(50, 0, sz.width, sz.height);
//    [self.view addSubview:imageView];
    
    
    //[self drawImage];
    //[self drawCGImage];
   //[self drawCIFilterAndCIImage];
  //  [self logAllFilters];
    _filter = [CIFilter filterWithName:@"CISepiaTone"];
    UIImage *gotImage = [UIImage imageNamed:@"image"];
    _beginImage = [CIImage imageWithCGImage:gotImage.CGImage];
    CIImage *outputImage = [self oldPhoto:_beginImage withAmount:.4];
    CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    // 显示图片
    self.imageView.image = newImg;
}

//UIimage绘图
- (void)drawImage
{
    UIImage *image = [UIImage imageNamed:@"1"];
    CGSize sz = [image size];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*2, sz.height), NO, 0);
    [image drawAtPoint:CGPointMake(0, 0)];
    [image drawAtPoint:CGPointMake(sz.width, 0)];
    UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageView *imageView = [[UIImageView alloc]initWithImage:im];
    imageView.frame = CGRectMake(0, 0, sz.width*2, sz.height);
    [self.view addSubview:imageView];

    //使用Mutltiply模式
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*2, sz.height*2), NO, 0);
    [image drawInRect:CGRectMake(0, 0, sz.width*2, sz.height*2)];
    [image drawInRect:CGRectMake(sz.width/2, sz.height/2, sz.width, sz.height) blendMode:kCGBlendModeMultiply alpha:1.0];
    UIImage *im1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:im1];
    imageView1.frame = CGRectMake(100, 100,sz.width*2,sz.height*2);
    [self.view addSubview:imageView1];
    //显示图片的一半
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width/2, sz.height), NO, 0);
    [image drawAtPoint:CGPointMake(-sz.width/2, 0)];
    UIImage *im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:im2];
    imageView2.frame = CGRectMake(100, 100,sz.width/2,sz.height);
    [self.view addSubview:imageView2];
}

//CGImage绘图(是翻转的)
- (void)drawCGImage
{
    UIImage *image = [UIImage imageNamed:@"night_comment_zan_icon_pre"];
    CGSize sz = image.size;
//    int scale =image.scale;
    CGImageRef imageLeft = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, sz.width/2*image.scale, sz.height*image.scale));
    CGImageRef imageRight = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(sz.width/2.0*image.scale, 0, sz.width/2*image.scale, sz.height*image.scale));
    //draw each CGimage into an image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*1.5*image.scale, sz.height*image.scale), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*（推荐使用①和③）*/
    /*①矩阵变换翻转*/
    CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, sz.height*image.scale), 1, -1));
    CGContextDrawImage(context, CGRectMake(0, 0, sz.width/2, sz.height), imageLeft);
    CGContextDrawImage(context, CGRectMake(sz.width, 0, sz.width/2, sz.height), imageRight);
    
    /*②翻转工具翻转，不会动态改变Scale(在二倍分辨率下面图片会模糊 会花掉)*/
//    CGContextDrawImage(context, CGRectMake(0, 0, sz.width/2, sz.height), flip(imageLeft));
//    CGContextDrawImage(context, CGRectMake(sz.width/2, 0, sz.width/2, sz.height), flip(imageRight));
    
   /*③动态改变Scale*/
//    [[UIImage imageWithCGImage:imageLeft scale:image.scale orientation:UIImageOrientationUp] drawAtPoint:CGPointMake(0, 0)];
//    [[UIImage imageWithCGImage:imageRight scale:image.scale orientation:UIImageOrientationUp] drawAtPoint:CGPointMake(sz.width/2, 0)];//image方法的scale会自适应

    UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRight);
    CGImageRelease(imageLeft);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:im];
    imageView.frame = CGRectMake(50, 100,sz.width*1.5*image.scale,sz.height*image.scale);
    [self.view addSubview:imageView];
}


//翻转工具实质是类似负负得正的思想，在进行重画
CGImageRef flip (CGImageRef im){
    CGSize sz =  CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im));
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, sz.width, sz.height), im);
    CGImageRef result = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    UIGraphicsEndImageContext();
    return result;
}


/*创建一个具有蓝色圆圈的uiimage。可以在任何时候和任何类中完成*/
- (void)drawImgaeText
{
# if 0
    //首先使用UIKit,scale传入0表示自适应主屏幕的分辨率
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)];
    [[UIColor blueColor] setFill];
    [path fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
#else
    //Core Graphics
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, 100, 100));
    CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
#endif
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:imageView];
}



/*CIFilter和CIImage*/
- (void)drawCIFilterAndCIImage
{
    //这部分代码 现在运行不出来结果
//    UIImage *moi = [UIImage imageNamed:@"girl.jpg"];
//    CGSize sz = moi.size;
//    CIImage *moi2 = [[CIImage alloc]initWithCGImage:moi.CGImage];
//    CIFilter *grad = [CIFilter filterWithName:@"CIRadialGradient"];
//    CIVector *center = [CIVector vectorWithX:moi.size.width/2 Y:moi.size.height/2];
//    [grad setValue:center forKey:@"inputCenter"];
//    CIFilter *dark = [CIFilter filterWithName:@"CIDarkenBlendMode" keysAndValues:@"inputImgae",grad.outputImage,@"inputBackgroundImage",moi2, nil];
//    CIContext *con = [CIContext contextWithOptions:nil];
//    CGImageRef moi3 = [con createCGImage:dark.outputImage fromRect:moi2.extent];
//    UIImage *moi4 = [UIImage imageWithCGImage:moi3 scale:moi.scale orientation:moi.imageOrientation];
//    CGImageRelease(moi3);
    
    
/*
    CIAdditionCompositing     //影像合成
    CIAffineTransform           //仿射变换
    CICheckerboardGenerator       //棋盘发生器
    CIColorBlendMode              //CIColor混合模式
    CIColorBurnBlendMode          //CIColor燃烧混合模式
    CIColorControls
    CIColorCube                   //立方体
    CIColorDodgeBlendMode         //CIColor避免混合模式
    CIColorInvert                 //CIColor反相
    CIColorMatrix                 //CIColor矩阵
    CIColorMonochrome             //黑白照
    CIConstantColorGenerator      //恒定颜色发生器
    CICrop                        //裁剪
    CIDarkenBlendMode             //亮度混合模式
    CIDifferenceBlendMode         //差分混合模式
    CIExclusionBlendMode          //互斥混合模式
    CIExposureAdjust              //曝光调节
    CIFalseColor                  //伪造颜色
    CIGammaAdjust                 //灰度系数调节
    CIGaussianGradient            //高斯梯度
    CIHardLightBlendMode          //强光混合模式
    CIHighlightShadowAdjust       //高亮阴影调节
    CIHueAdjust                   //饱和度调节
    CIHueBlendMode                //饱和度混合模式
    CILightenBlendMode
    CILinearGradient              //线性梯度
    CILuminosityBlendMode         //亮度混合模式
    CIMaximumCompositing          //最大合成
    CIMinimumCompositing          //最小合成
    CIMultiplyBlendMode           //多层混合模式
    CIMultiplyCompositing         //多层合成
    CIOverlayBlendMode            //覆盖叠加混合模式
    CIRadialGradient              //半径梯度
    CISaturationBlendMode         //饱和度混合模式
    CIScreenBlendMode             //全屏混合模式
    CISepiaTone                   //棕黑色调
    CISoftLightBlendMode          //弱光混合模式
    CISourceAtopCompositing
    CISourceInCompositing
    CISourceOutCompositing
    CISourceOverCompositing
    CIStraightenFilter            //拉直过滤器
    CIStripesGenerator            //条纹发生器
    CITemperatureAndTint          //色温
    CIToneCurve                   //色调曲线
    CIVibrance                    //振动
    CIVignette                    //印花
    CIWhitePointAdjust            //白平衡调节
 */
    
    
    
    UIImage *moi = [UIImage imageNamed:@"image"];
    _beginImage = [[CIImage alloc]initWithCGImage:moi.CGImage];
#if 0
    //自我不推荐这种用法
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"];
//    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
//     CIImage *beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    
    /*创建CIFilter对象。一个 CIFilter 构造函数有两个输入，分别是滤镜的名字，还有规定了滤镜属性的键值和取值的字典。这里CISepiaTone是滤镜的名字*/
    //每一个滤镜会有它自己唯一的键值和一组有效的取值。CISepiaTone 滤镜只能选两个值： KCIInputImageKey (一个CIImage) 和 @”inputIntensity”。
    //后者是一个封装成NSNumber (用新的文字型语法)的浮点小数，取值在0和1 之间。大部分的滤镜有默认值，只有CIImage是个例外。你必须提供一个值给它，因为
    //它没有默认值。从滤镜中导出CIImage很简单，只需要用outputImage方法
     _filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, beginImage, @"inputIntensity", @0.8, nil];
    CIImage *outputImage = [filter outputImage];
    UIImage *newImage = [UIImage imageWithCIImage:outputImage];

#else
    
    //把它放在上下文中
   /* 在进行下一步之前，有一个优化的方法很实用。我前面提到过，你需要一个CIContext来进行CIFilter，但是在上面的例子中我们没有提到这个对象。因为我们调用的
    UIImage方法(imageWithCIImage)已经自动地为我们完成了这个步骤。它生成了一个CIContext并且用它来处理图像的过滤。这使得调用Core Image的接口变得很
    简单。但是，有一个主要的问题是，它的每次调用都会生成一个CIContext。CIContext本来是可以重用以便提高性能和效率的。比如下面我们要谈到的例子，如果你想用滑动条来选择过滤参数取值，每次改变滤镜参数都会自动生成一个CIContext， 使得性能非常差。*/
    
    
    //创建了CIContext对象。CIContext 构造函数的输入是一个NSDictionary。 它规定了各种选项，包括颜色格式以及内容是否应该运行在CPU或是GPU上。对于这个应用程序，默认值是可以用的。所以你只需要传入nil作为参数就好了。
    _context = [CIContext contextWithOptions:nil];
    _filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, _beginImage, @"inputIntensity", @0.8, nil];
    CIImage *outputImage = [_filter outputImage];
    //在这里你用上下文对象里的一个方法来画一个CGImage。 调用上下文中的createCGImage:fromRect:和提供的CIImage可以生成一个CGImageRe
    CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    //开放 CGImageRef接口。CGImage 是一个C接口，即使有ARC，也需要你自己来做内存管理。
    //在这个例子中，添加CIContext的创建 和你自己来创建的区别不大。但是在下一部分中，你将会看到当你实现动态改变滤镜参数的时候的重大性能差别.
    CGImageRelease(cgimg);
#endif
    self.imageView.image = newImage;
}
- (IBAction)amountSliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    float slideValue = slider.value;
    [_filter setValue:@(slideValue) forKey:@"inputIntensity"];
    CIImage *outputImage = [_filter outputImage];
    CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    //保存图片的方向
    UIImage *newImage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:_orientation];
   // UIImage *newImage = [UIImage imageWithCGImage:cgimg];
     self.imageView.image = newImage;
    CGImageRelease(cgimg);
}

- (IBAction)loadPhotoClicked:(UIButton *)sender {
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];
}

- (IBAction)savePhotoClick:(id)sender {
    
    CIImage *saveToSave = [_filter outputImage];
    //创建一个新的、基于软件的CIContext
    CIContext *softwareContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)} ];
    //生成CGImageRef
     CGImageRef cgImg = [softwareContext createCGImage:saveToSave fromRect:[saveToSave extent]];
    //保存CGImageRef 到图片库
     ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgImg metadata:[saveToSave properties] completionBlock:^(NSURL *assetURL, NSError *error) {
        CGImageRelease(cgImg);
    }];
    
}

#pragma mark - PickerViewDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    _orientation = gotImage.imageOrientation;
    _beginImage = [CIImage imageWithCGImage:gotImage.CGImage];
    [_filter setValue:_beginImage forKey:kCIInputImageKey];
    [self amountSliderValueChanged:self.amountSlider];
    
    NSLog(@"%@", info);
}
- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//滤镜的名字，滤镜的分类，滤镜的输入以及输入的默认值和可接受的值范围等信息
-(void)logAllFilters {
    NSArray *properties = [CIFilter filterNamesInCategory: kCICategoryBuiltIn];
    NSLog(@"%@", properties);
    for (NSString *filterName in properties) {
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        NSLog(@"%@", [fltr attributes]);
    }
}

-(CIImage *)oldPhoto:(CIImage *)img withAmount:(float)intensity {
    
    // 1
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
    [sepia setValue:img forKey:kCIInputImageKey];
    [sepia setValue:@(intensity) forKey:@"inputIntensity"];
    // 2
    CIFilter *random = [CIFilter filterWithName:@"CIRandomGenerator"];
    // 3
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:random.outputImage forKey:kCIInputImageKey];
    [lighten setValue:@(1 - intensity) forKey:@"inputBrightness"];
    [lighten setValue:@0.0 forKey:@"inputSaturation"];
    // 4
    CIImage *croppedImage = [lighten.outputImage imageByCroppingToRect:[_beginImage extent]];

    CIFilter *composite = [CIFilter     filterWithName:@"CIHardLightBlendMode"];
    [composite setValue:sepia.outputImage forKey:kCIInputImageKey];
    [composite setValue:croppedImage    forKey:kCIInputBackgroundImageKey];
    
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
    [vignette setValue:composite.outputImage forKey:kCIInputImageKey];
     [vignette setValue:@(intensity * 2) forKey:@"inputIntensity"];
     [vignette setValue:@(intensity * 30) forKey:@"inputRadius"];
     
     UIImage *filteredImage = [croppedImage imageWithCIImage:vignette.outputImage];
     return filteredImage.CIImage;

    
}



@end
