//
//  FirstViewController.h
//  CocoaDrawImage
//
//  Created by Mabye on 13-12-23.
//  Copyright (c) 2013年 Maybe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *amountSlider;
- (IBAction)amountSliderValueChanged:(id)sender;
- (IBAction)loadPhotoClicked:(UIButton *)sender;
- (IBAction)savePhotoClick:(id)sender;

@end
