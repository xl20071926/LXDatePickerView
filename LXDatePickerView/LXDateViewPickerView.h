//
//  LXDateViewPickerView.h
//  LXDatePickerView
//
//  Created by Leexin on 17/2/18.
//  Copyright © 2017年 Garden.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXDateViewPickerView;
@protocol LXDateViewPickerViewDelegate <NSObject>

- (void)dateViewPickerView:(LXDateViewPickerView *)view didSelectedDate:(NSDate *)date;
@optional
- (void)dateViewPickerViewDidCancelSelected:(LXDateViewPickerView *)view;

@end

@interface LXDateViewPickerView : UIView

// 默认开始日期今天,结束日期明天
- (instancetype)initWithFrame:(CGRect)frame;
// 手动设置开始日期,结束日期
- (instancetype)initWithFrame:(CGRect)frame
                    stareDate:(NSDate *)stareDate
                      endDate:(NSDate *)endDate;

@property (nonatomic, weak) id<LXDateViewPickerViewDelegate> delegate;
@property (nonatomic, strong, readonly) NSString *stareString;
@property (nonatomic, strong, readonly) NSString *endString;

@end
