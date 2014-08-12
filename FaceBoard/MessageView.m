//
//  MessageView.m
//  GuessPlay
//
//  Created by 张九州 on 14-8-11.
//  Copyright (c) 2014年 张九州. All rights reserved.
//

#import "MessageView.h"
#import "FaceBoard.h"

@interface FaceBoard()

+ (NSString *)faceNameHead;

// 分析消息文本, 生成表情编码和文本组成的数组
+ (void)getMessageRange:(NSString*)message :(NSMutableArray*)array;

@end

@interface MessageView()

@property (nonatomic, strong) NSDictionary *faceMap;
@property (nonatomic, assign) BOOL moreThanOneLine;
@property (nonatomic, assign) float originX;
@property (nonatomic, assign) float originY;

@end

@implementation MessageView

- (id)init
{
    if (self = [super initWithFrame: CGRectZero]) {
        self.opaque = NO;
        self.faceMap = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"FaceMap" ofType: @"plist"]];
    }
    return self;
}

+ (float)leftPadding
{
    return 16;
}

+ (float)topPadding
{
    return 8;
}

+ (float)lineHeight
{
    return 22;
}

+ (float)maxWidth
{
    return 166;
}

+ (float)faceSize
{
    return 20;
}

+ (float)charWidth
{
    return 8;
}

+ (UIFont *)font
{
    return [UIFont systemFontOfSize: 16];
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

+ (CGSize)sizeForText:(NSString *)text
{
    CGFloat originX = MessageView.leftPadding;
    CGFloat originY = MessageView.topPadding;
    CGFloat viewWidth;
    CGFloat viewHeight;
    NSDictionary *faceMap = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"FaceMap" ofType: @"plist"]];

    BOOL moreThanOneLine = NO;
    NSMutableArray *data = [NSMutableArray array];
    [FaceBoard getMessageRange: text :data];

    UIFont *font = MessageView.font;

    for (int index = 0; index<[data count]; index++) {
        NSString *str = [data objectAtIndex: index];
        if ([str hasPrefix: FaceBoard.faceNameHead]) {
            NSArray *imageNames = [faceMap allKeysForObject: str];
            NSString *imageName = nil;
            NSString *imagePath = nil;

            if ( imageNames.count > 0 ) {
                imageName = [imageNames objectAtIndex:0];
                imagePath = [[NSBundle mainBundle] pathForResource: imageName ofType: @"png"];
            }

            if (imagePath) {
                if (originX - MessageView.leftPadding > MessageView.maxWidth - MessageView.faceSize) {
                    moreThanOneLine = YES;
                    originX = MessageView.leftPadding;
                    originY += MessageView.lineHeight;
                }

                originX += MessageView.faceSize;
            } else {
                for (int index = 0; index<str.length; index++) {
                    NSString *character = [str substringWithRange: NSMakeRange(index, 1)];
                    CGSize size = [character sizeWithFont: font constrainedToSize: CGSizeMake(MessageView.maxWidth, MessageView.lineHeight * 1.5)];

                    if (originX - MessageView.leftPadding > (MessageView.maxWidth - MessageView.charWidth)) {
                        moreThanOneLine = YES;
                        originX = MessageView.leftPadding;
                        originY += MessageView.lineHeight;
                    }

                    originX += size.width;
                }
            }
        } else {
            for (int index = 0; index < str.length; index++) {
                NSString *character = [str substringWithRange:NSMakeRange(index, 1)];
                CGSize size = [character sizeWithFont: font constrainedToSize: CGSizeMake(MessageView.maxWidth, MessageView.lineHeight * 1.5)];

                if (originX - MessageView.leftPadding > (MessageView.maxWidth - MessageView.charWidth)) {
                    moreThanOneLine = YES;
                    originX = MessageView.leftPadding;
                    originY += MessageView.lineHeight;
                }

                originX += size.width;
            }
        }
    }

    if (moreThanOneLine) {
        viewWidth = MessageView.maxWidth + MessageView.leftPadding * 2;
    } else {
        viewWidth = originX + MessageView.leftPadding;
    }
    viewHeight = originY + MessageView.lineHeight + MessageView.topPadding;

    return (CGSize){viewWidth, viewHeight};
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect: rect];
    if (!self.text) {
        return;
    }

    UIFont *font = MessageView.font;
    self.moreThanOneLine = NO;

    self.originX = MessageView.leftPadding;
    self.originY = MessageView.topPadding;

    NSMutableArray *data = [NSMutableArray array];
    [FaceBoard getMessageRange: self.text :data];
    for (int index = 0; index < [data count]; index++) {
        NSString *str = [data objectAtIndex:index];
        if ([str hasPrefix: FaceBoard.faceNameHead]) {
            NSArray *imageNames = [self.faceMap allKeysForObject: str];
            NSString *imageName = nil;

            if (imageNames.count > 0) {
                imageName = [imageNames objectAtIndex: 0];
            }

            UIImage *image = [UIImage imageNamed:imageName];
            if (image) {
                if (self.originX - MessageView.leftPadding > MessageView.maxWidth - MessageView.faceSize) {
                    self.moreThanOneLine = YES;
                    self.originX = MessageView.leftPadding;
                    self.originY += MessageView.lineHeight;
                }

                [image drawInRect: CGRectMake(self.originX, self.originY, MessageView.faceSize, MessageView.faceSize)];
                self.originX += MessageView.faceSize;
            } else {
                [self drawText: str withFont: font];
            }
        } else {
            [self drawText:str withFont:font];
        }
    }
}

- (void)drawText:(NSString *)string withFont:(UIFont *)font
{
    for (int index = 0; index < string.length; index++) {
        NSString *character = [string substringWithRange: NSMakeRange(index, 1)];
        CGSize size = [character sizeWithFont: font constrainedToSize: CGSizeMake(MessageView.maxWidth, MessageView.lineHeight * 1.5)];

        if (self.originX - MessageView.leftPadding > (MessageView.maxWidth - MessageView.charWidth)) {
            self.moreThanOneLine = YES;
            self.originX = MessageView.leftPadding;
            self.originY += MessageView.lineHeight;
        }

        [character drawInRect: CGRectMake(self.originX, self.originY, size.width, self.bounds.size.height) withFont: font];
        self.originX += size.width;
    }
}

@end
