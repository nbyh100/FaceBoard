//
//  MessageView.h
//  GuessPlay
//
//  Created by 张九州 on 14-8-11.
//  Copyright (c) 2014年 张九州. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIView

// 需要显示的文本
@property (nonatomic, strong) NSString *text;

// 计算给定文本时视图的大小
+ (CGSize)sizeForText:(NSString *)text;

@end

