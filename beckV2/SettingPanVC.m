//
//  SettingPanVC.m
//  Beck
//
//  Created by Aimy on 15/1/4.
//  Copyright (c) 2015年 Aimy. All rights reserved.
//

#import "SettingPanVC.h"
#import "UIImage+tool.h"

@interface SettingPanVC ()

@property (weak, nonatomic) IBOutlet UIButton *brightnessBtn;
@property (weak, nonatomic) IBOutlet UIButton *fontBtn;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) UIButton *selectedBtn;

@end

@implementation SettingPanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.brightnessBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [self.brightnessBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [self.brightnessBtn setBackgroundImage:[UIImage imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateSelected];
    
    [self.fontBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [self.fontBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [self.fontBtn setBackgroundImage:[UIImage imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateSelected];
    
    [self onPressedBtn:self.brightnessBtn];
}

- (IBAction)onPressedBtn:(UIButton *)sender {
    if (self.selectedBtn == sender) {
        return ;
    }
    
    self.selectedBtn.selected = NO;
    self.selectedBtn = sender;
    self.selectedBtn.selected = YES;
    
    if (self.selectedBtn == self.brightnessBtn) {
        self.slider.maximumValue = 1.f;
        self.slider.minimumValue = 0.f;
        self.slider.value = [UIScreen mainScreen].brightness;
        self.label.text = [NSString stringWithFormat:@"%d％",(int)(self.slider.value * 100)];
    }
    else {
        self.slider.maximumValue = 25.f;
        self.slider.minimumValue = 10.f;
        self.slider.value = [[NSUserDefaults standardUserDefaults] integerForKey:@"fontValue"];
        self.label.text = [NSString stringWithFormat:@"%d",(int)self.slider.value];
    }
}

- (IBAction)onValueChange:(UISlider *)sender {
    CGFloat value = self.slider.value;
    if (self.selectedBtn == self.brightnessBtn) {
        [UIScreen mainScreen].brightness = value;
        self.label.text = [NSString stringWithFormat:@"%d％",(int)(value * 100)];
    }
    else {
        self.label.text = [NSString stringWithFormat:@"%d",(int)value];
    }
}

- (IBAction)onPressedCancel:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)onPressedOK:(id)sender {
    CGFloat value = self.slider.value;
    if (self.selectedBtn == self.fontBtn) {
        [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"fontValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatefont" object:nil];
    [self onPressedCancel:nil];
}

- (IBAction)onPressedTap:(id)sender {
    [self onPressedCancel:nil];
}

@end
