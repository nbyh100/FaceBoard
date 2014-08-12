//
//  FaceBoard.m
//  GuessPlay
//
//  Created by 张九州 on 14-8-11.
//  Copyright (c) 2014年 张九州. All rights reserved.
//

#import "FaceBoard.h"

@interface FaceBoard()<UIScrollViewDelegate>

@property (nonatomic, weak) UITextView *faceTextView;
@property (nonatomic, weak) UIScrollView *faceView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSDictionary *faceMap;

@property (nonatomic, assign, readonly) int faceCount;
@property (nonatomic, assign, readonly) int pageCount;

@end

@implementation FaceBoard

- (instancetype)initWithTextView:(UITextView *)faceTextView
{
    if (self = [super initWithFrame: (CGRect){CGPointZero, (CGSize){FaceBoard.screenWidth, 216}}]) {
        self.faceTextView = faceTextView;
        self.faceMap = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"FaceMap" ofType: @"plist"]];

        UIScrollView *faceView = [[UIScrollView alloc] initWithFrame: (CGRect){CGPointZero, (CGSize){CGRectGetWidth(self.bounds), 190}}];
        faceView.pagingEnabled = YES;
        faceView.contentSize = (CGSize){(double)self.pageCount * CGRectGetWidth(self.bounds), 190};
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        [self addSubview: faceView];
        self.faceView = faceView;

        [self addFaceButtons];

        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.numberOfPages = self.pageCount;
        [pageControl sizeToFit];
        pageControl.center = (CGPoint){CGRectGetMidX(self.bounds), 175 + CGRectGetMidX(pageControl.bounds)};
        pageControl.currentPage = 0;
        [self addSubview: pageControl];
        self.pageControl = pageControl;

        UIButton *backButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [backButton setImage: [UIImage imageNamed: @"faceboard_delete"] forState: UIControlStateNormal];
        [backButton setImage: [UIImage imageNamed: @"faceboard_delete_active"] forState: UIControlStateSelected];
        [backButton addTarget: self action: @selector(backspace) forControlEvents: UIControlEventTouchUpInside];
        backButton.frame = (CGRect){(CGPoint){272, 182}, (CGSize){38, 38}};
        [self addSubview: backButton];
    }
    return self;
}

+ (int)faceSize
{
    return 44;
}

+ (int)rows
{
    return 4;
}

+ (int)columns
{
    return 7;
}

+ (int)pageSize
{
    return FaceBoard.rows * FaceBoard.columns;
}

+ (int)faceNameLength
{
    return 5;
}

+ (float)screenWidth
{
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

+ (NSString *)faceNameHead
{
    return @"/s";
}

- (int)faceCount
{
    return self.faceMap.allKeys.count;
}

- (int)pageCount
{
    return (int)ceil((double)self.faceCount/(FaceBoard.pageSize));
}

- (void)addFaceButtons
{
    for (int i = 1; i <= self.faceCount; i++) {
        UIButton *faceButton = [UIButton buttonWithType: UIButtonTypeCustom];
        faceButton.tag = i;

        [faceButton addTarget: self
                       action: @selector(faceInput:)
             forControlEvents: UIControlEventTouchUpInside];

        CGFloat x = (((i - 1) % FaceBoard.pageSize) % FaceBoard.columns) * FaceBoard.faceSize + 6 + ((i - 1) / FaceBoard.pageSize * FaceBoard.screenWidth);
        CGFloat y = (((i - 1) % FaceBoard.pageSize) / FaceBoard.columns) * FaceBoard.faceSize + 8;
        faceButton.frame = CGRectMake(x, y, FaceBoard.faceSize, FaceBoard.faceSize);

        [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d", i]]
                    forState:UIControlStateNormal];

        [self.faceView addSubview:faceButton];
    }
}

- (void)backspace
{
    NSString *inputString = self.faceTextView.text;

    if ( inputString.length ) {
        NSString *string = nil;
        NSInteger stringLength = inputString.length;
        if (stringLength >= FaceBoard.faceNameLength) {
            string = [inputString substringFromIndex: stringLength - FaceBoard.faceNameLength];
            NSRange range = [string rangeOfString: FaceBoard.faceNameHead];
            if ( range.location == 0 ) {
                string = [inputString substringToIndex: [inputString rangeOfString: FaceBoard.faceNameHead options:NSBackwardsSearch].location];
            }
            else {
                string = [inputString substringToIndex:stringLength - 1];
            }
        }
        else {
            string = [inputString substringToIndex:stringLength - 1];
        }

        self.faceTextView.text = string;
    }
}

- (void)faceInput:(UIButton *)sender
{
    int i = sender.tag;
    if (self.faceTextView) {
        NSMutableString *faceString = [[NSMutableString alloc] initWithString: self.faceTextView.text];
        [faceString appendString: [self.faceMap objectForKey: [NSString stringWithFormat:@"%03d", i]]];
        self.faceTextView.text = faceString;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.pageControl setCurrentPage: (int)(self.faceView.contentOffset.x / FaceBoard.screenWidth)];
    [self.pageControl updateCurrentPageDisplay];
}

+ (void)getMessageRange:(NSString*)message :(NSMutableArray*)array {

	NSRange range = [message rangeOfString: FaceBoard.faceNameHead];
    if (range.length > 0) {
        if (range.location > 0) {
            [array addObject: [message substringToIndex: range.location]];
            message = [message substringFromIndex: range.location];

            if (message.length > FaceBoard.faceNameLength) {
                [array addObject: [message substringToIndex: FaceBoard.faceNameLength]];
                message = [message substringFromIndex: FaceBoard.faceNameLength];
                [self getMessageRange: message :array];
            } else if ( message.length > 0 ) {
                [array addObject:message];
            }
        }
        else {
            if (message.length > FaceBoard.faceNameLength) {
                [array addObject:[message substringToIndex: FaceBoard.faceNameLength]];
                message = [message substringFromIndex: FaceBoard.faceNameLength];
                [self getMessageRange:message :array];
            } else if (message.length > 0) {
                [array addObject:message];
            }
        }
    } else {
        [array addObject:message];
    }
}

@end

