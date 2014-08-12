//
//  ViewController.m
//  FaceBoard
//
//  Created by 张九州 on 14-8-12.
//  Copyright (c) 2014年 张九州. All rights reserved.
//

#import "ViewController.h"
#import "FaceBoard.h"
#import "MessageView.h"

@interface ViewController ()

@property (nonatomic, assign) MessageView *mv;
@property (nonatomic, assign) UITextView *tv;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITextView *tv = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, 320, 200)];
    tv.layer.borderWidth = 1;
    tv.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview: tv];
    self.tv = tv;

    FaceBoard *faceBoard = [[FaceBoard alloc] initWithTextView: tv];
    tv.inputView = faceBoard;

    UIButton *send = [UIButton buttonWithType: UIButtonTypeSystem];
    [send setTitle: @"Show Bubble" forState: UIControlStateNormal];
    [self.view addSubview: send];
    send.bounds = (CGRect){CGPointZero, (CGSize){120, 30}};
    send.center = (CGPoint){CGRectGetMidX(self.view.bounds), 220};
    [send addTarget: self action: @selector(send) forControlEvents: UIControlEventTouchUpInside];

    MessageView *mv = [[MessageView alloc] init];
    mv.backgroundColor = [UIColor yellowColor];
    [self.view addSubview: mv];
    mv.layer.cornerRadius = 15.;
    mv.layer.masksToBounds = YES;
    self.mv = mv;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)send
{
    self.mv.text = self.tv.text;
    self.mv.frame = (CGRect){(CGPoint){10, 250}, [MessageView sizeForText: self.tv.text]};
    [self.view endEditing: YES];
}

@end
