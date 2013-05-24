//
//  ChessBoard.m
//  Othello
//
//  Created by Colin Yang Hong on 13-5-22.
//  Copyright (c) 2013年 Colin Yang Hong. All rights reserved.
//

#import "ChessBoard.h"

@interface ChessBoard ()
{
}


// 白子
@property (nonatomic ,retain) NSString *white;

// 黑子
@property (nonatomic ,retain) NSString *black;

// 无子
@property (nonatomic ,retain) NSString *blank;

// 无效的格子
@property (nonatomic ,retain) NSString *null;

@end

@implementation ChessBoard

- (id)init
{
    self = [super init];
    if (self) {
        self.white = @"white";
        self.black = @"black";
        self.null  = @"null";
        self.blank = @"blank";
        
        // 初始化64个格子的
        self.chessboard = [[NSMutableDictionary alloc] initWithCapacity:64];   
    }
    return self;
}


// 初始化棋盘
- (void)setChessboard:(NSMutableDictionary *)chessboard
{
    if (chessboard != _chessboard) {
        [_chessboard release];
        _chessboard = [chessboard retain];
        
        for (int i = 1; i <= 8; i++) {
            for (int j = 0; j < 7; j++) {
                [_chessboard setObject:_blank forKey:[NSString stringWithFormat:@"%c%d",'a'+j,i]];
            }
        }
    }
}

// 初始化棋局
- (void)initializeChessBoard
{
    [self setStatusAtPosition:@"e4" withPlayer:_black];
    [self setStatusAtPosition:@"d5" withPlayer:_black];
    [self setStatusAtPosition:@"e5" withPlayer:_white];
    [self setStatusAtPosition:@"d4" withPlayer:_white];
}

// 判断是否有效的格子位置
- (BOOL)isValidPosition:(NSString *)position
{
    if ([position length] != 2) {
        return false;
    }
    
    if ([position characterAtIndex:0] < 'a' || [position characterAtIndex:0] > 'a' + 7) {
        return false;
    };
    
    if ([position characterAtIndex:1] < '1' || [position characterAtIndex:1] > '1' + 7) {
        return false;
    };
    
    return true;
}

// 在指定位置上放置棋子
- (BOOL)setStatusAtPosition:(NSString *) position withPlayer:(NSString *)player
{
    if (![self isValidPosition:position]) {
        return NO;
    }
    [_chessboard setObject:player forKey:position];
    return YES;
}

// 获得指定位置的格子状态
- (NSString *)getStatusWithPosition:(NSString *) position
{
    if (![self isValidPosition:position]) return _null;
    
    return [_chessboard valueForKey:position];
}

// 获取当前格子的上方格子位置
- (NSString *)getPositionWithDirection:(ChessCellDirection)direction  atPosition:(NSString *)position
{
    if (![self isValidPosition:position]) {
        return _null;
    }
    
    NSString *newPosition;
    switch (direction) {
        case ChessCellDirectionLeft:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0], [position characterAtIndex:1] - 1];
            break;
        case ChessCellDirectionLow:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0], [position characterAtIndex:1] - 1];
            break;
        case ChessCellDirectionLowLeft:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0], [position characterAtIndex:1] - 1];
            break;
        case ChessCellDirectionLowRight:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0], [position characterAtIndex:1] - 1];
            break;
        case ChessCellDirectionRight:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0], [position characterAtIndex:1] - 1];
            break;
        case ChessCellDirectionTop:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0], [position characterAtIndex:1] - 1];
            break;
        case ChessCellDirectionTopLeft:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0], [position characterAtIndex:1] - 1];
            break;
        case ChessCellDirectionTopRight:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0], [position characterAtIndex:1] - 1];
            break;
            
        default:
            break;
    }
    
    if (![self isValidPosition:newPosition]) {
        return _null;
    }
    return newPosition;
}

// 获取当前格子的下方格子位置
- (NSString *)getUnderPosition:(NSString *)position
{
    if (![self isValidPosition:position]) {
        return _null;
    }
    NSString *newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0], [position characterAtIndex:1] + 1];
    if (![self isValidPosition:newPosition]) {
        return _null;
    }
    return newPosition;
}

// 获取当前格子的左方格子位置
- (NSString *)getLeftPosition:(NSString *)position
{
    if (![self isValidPosition:position]) {
        return _null;
    }
    NSString *newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0] - 1, [position characterAtIndex:1]];
    if (![self isValidPosition:newPosition]) {
        return _null;
    }
    return newPosition;
}

// 获取当前格子的右方格子位置
- (NSString *)getRightPosition:(NSString *)position
{
    if (![self isValidPosition:position]) {
        return _null;
    }
    NSString *newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0] + 1, [position characterAtIndex:1]];
    if (![self isValidPosition:newPosition]) {
        return _null;
    }
    return newPosition;
}

- (BOOL)isValidPlayer:(NSString *)player
{
    if (![player isEqualToString:_white] || ![player isEqualToString:_black] ) {
        return NO;
    }
    return YES;
}

- (NSString *)getOpponentWithPlayer:(NSString *)player
{
    if (![self isValidPlayer:player]) {
        return NO;
    }
    
    if ([player isEqualToString:_black]) {
        return _white;
    } else {
        return _black;
    }
}

- (BOOL)isCanLayDownAtPosition:(NSString *)position withPlayer:(NSString *)player
{
    if (![self isValidPlayer:player]) {
        return NO;
    }
    
    if (![self isValidPosition:position]) {
        return NO;
    }
}

- (void)test
{
    [self initializeChessBoard];
    NSLog(@"显示整个棋盘数组 %@",_chessboard);
    
    //测试position是否有效
    NSLog(@"位置da 是无效的  %@",[self isValidPosition:@"da"] ? @"true" : @"false");
    NSLog(@"位置e5 是有效的  %@",[self isValidPosition:@"e5"] ? @"true" : @"false");
    
    NSLog(@"位置e6 的上方是 %@", [self getAbovePosition:@"e6"]);
    NSLog(@"位置e8 的下方是 %@", [self getUnderPosition:@"e8"]);
}

@end
