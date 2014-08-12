//
//  FaceBoard.h
//  GuessPlay
//
//  Created by 张九州 on 14-8-11.
//  Copyright (c) 2014年 张九州. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageView.h"

@interface FaceBoard : UIView

// 表情会被输入到这个文本框
- (instancetype)initWithTextView:(UITextView *)faceTextView;

@end

