//
//  LXDatePickerViewController.h
//  LXDatePickerView
//
//  Created by Leexin on 17/2/18.
//  Copyright © 2017年 Garden.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LXDatePickerSelectBlock)(NSString *dateString);
typedef void (^LXDatePickerCancleBlock)();

@class LXDatePickerViewController;
@protocol LXDatePickerViewControllerDelegate <NSObject>

@optional
- (void)datePickerViewControllerDidClickCancleButton:(LXDatePickerViewController *)controller;
- (void)datePickerViewController:(LXDatePickerViewController *)controller didSelectDate:(NSString *)dateString;

@end

@interface LXDatePickerViewController : UIViewController

@property (nonatomic, weak) id<LXDatePickerViewControllerDelegate> delegate;
@property (nonatomic, copy) LXDatePickerSelectBlock selectBlock;
@property (nonatomic, copy) LXDatePickerCancleBlock cancleBlock;

- (instancetype)initWithSelectedDate:(NSDate *)selectedDate; // 手动设置初始选中日期,未设置则默认当前日期

@end
