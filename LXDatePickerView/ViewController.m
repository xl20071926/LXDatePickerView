//
//  ViewController.m
//  LXDatePickerView
//
//  Created by Leexin on 17/2/18.
//  Copyright © 2017年 Garden.Lee. All rights reserved.
//

#import "ViewController.h"
#import "LXDateViewPickerView.h"
#import "UIView+Extensions.h"

@interface ViewController () <LXDateViewPickerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self commonInit];
}

- (void)commonInit {
    
    LXDateViewPickerView *pickerView = [[LXDateViewPickerView alloc] initWithFrame:CGRectMake(0, 200.f, self.view.width, 40.f)];
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dateViewPickerView:(LXDateViewPickerView *)view didSelectedDate:(NSDate *)date {
    
    NSLog(@"did selected %@",date);
}

- (void)dateViewPickerViewDidCancelSelected:(LXDateViewPickerView *)view {
    
    NSLog(@"did cancel selected");
}

@end
