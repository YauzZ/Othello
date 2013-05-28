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



@end

@implementation ChessBoard

- (id)init
{
    self = [super init];
    if (self) {
        self.white = @"white";
        self.black = @"black";
        self.null  = @"null";
        self.blank = @"####";
        
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
        
        for (int i = 0; i < 8; i++) {
            for (int j = 1; j <= 8; j++) {
                [_chessboard setObject:_blank forKey:[NSString stringWithFormat:@"%c%d",'a'+i,j]];
            }
        }
    }
}

// 初始化棋局
- (void)initializeChessBoard
{
    [self setCellStatus:_black AtPosition:@"e4"];
    [self setCellStatus:_black AtPosition:@"d5"];
    [self setCellStatus:_white AtPosition:@"e5"];
    [self setCellStatus:_white AtPosition:@"d4"];
    self.currentPlayer = _black;
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

- (BOOL)isValidCellStatus:(NSString *)status
{
    if ([status isEqualToString:_white] || [status isEqualToString:_black] ||
        [status isEqualToString:_blank] || [status isEqualToString:_null]) {
        return YES;
    }
    return NO;
}

// 在指定位置上变更棋子状态
- (BOOL)setCellStatus:(NSString *)status AtPosition:(NSString *) position
{
    if (![self isValidPosition:position] || ![self isValidCellStatus:status]) {
        return NO;
    }
    [_chessboard setObject:status forKey:position];
    return YES;
}

// 获得指定位置的格子状态
- (NSString *)getCellStatusWithPosition:(NSString *) position
{
    if (![self isValidPosition:position]) return _null;
    
    return [_chessboard valueForKey:position];
}

// 获取当前格子指定方向与之相邻的格子状态
- (NSString *)getPositionWithDirection:(NSNumber *)direction  atPosition:(NSString *)position
{
    if (![self isValidPosition:position]) {
        return _null;
    }
    
    ChessCellDirection direction_ = [direction intValue];
    NSString *newPosition;
    switch (direction_) {
        case ChessCellDirectionLeft:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0] - 1, [position characterAtIndex:1]];
            break;
        case ChessCellDirectionLow:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0] , [position characterAtIndex:1] + 1];
            break;
        case ChessCellDirectionLowLeft:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0] - 1, [position characterAtIndex:1] + 1];
            break;
        case ChessCellDirectionLowRight:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0] + 1, [position characterAtIndex:1] + 1];
            break;
        case ChessCellDirectionRight:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0] + 1, [position characterAtIndex:1] ];
            break;
        case ChessCellDirectionTop:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0], [position characterAtIndex:1] - 1];
            break;
        case ChessCellDirectionTopLeft:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0] - 1, [position characterAtIndex:1] - 1];
            break;
        case ChessCellDirectionTopRight:
            newPosition = [NSString stringWithFormat:@"%c%c", [position characterAtIndex:0] + 1, [position characterAtIndex:1] - 1];
            break;
            
        default:
            return _null;
            break;
    }
    
    if (![self isValidPosition:newPosition]) {
        return _null;
    }
    return newPosition;
}

- (BOOL)isValidPlayer:(NSString *)player
{
    if ([player isEqualToString:_white] || [player isEqualToString:_black] ) {
        return YES;
    }
    return NO;
}

- (NSString *)getOpponentWithPlayer:(NSString *)player
{
    if (![self isValidPlayer:player]) {
        return _null;
    }
    
    if ([player isEqualToString:_black]) {
        return _white;
    } else {
        return _black;
    }
}

- (NSArray *)allAllowablePositions
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *position in _chessboard.allKeys) {
        if ([self isCanLayDownAtPosition:position withPlayer:_currentPlayer]) {
            [array addObject:position];
        }
    }
    return array;
}

- (NSArray *)layDownAtPosition:(NSString *)position
{
    return [self layDownAtPosition:position withPlayer:_currentPlayer];
}

// 在棋盘上放下棋子,返回需要变换状态的棋子列表
- (NSArray *)layDownAtPosition:(NSString *)position withPlayer:(NSString *)player
{
    if (![self isCanLayDownAtPosition:position withPlayer:player]) {
        return nil;
    }
    
    NSMutableArray *allPosition = [NSMutableArray arrayWithObject:position];
    
    NSString *newPositon;
    for (NSNumber *direction in [self getAllDirection]) {
        //取得该方向的相邻棋子位置
        newPositon = [self getPositionWithDirection:direction atPosition:position];
        if (![[self getCellStatusWithPosition:newPositon] isEqualToString:[self getOpponentWithPlayer:player]]) {
            continue;
        }
        
        NSMutableArray *chesses = [NSMutableArray arrayWithObject:newPositon];
        //判断该位置的棋子是否同色
        while (1) {
            newPositon = [self getPositionWithDirection:direction atPosition:newPositon];
            if ([[self getCellStatusWithPosition:newPositon] isEqualToString:[self getOpponentWithPlayer:player]]) {
                [chesses addObject:newPositon];
            } else if ([[self getCellStatusWithPosition:newPositon] isEqualToString:player] ) {
                [allPosition addObjectsFromArray:chesses];
                break;
            } else {
                break;
            }
        }
    }
    
    if ([allPosition count] == 1) {
        return nil;
    }
    
    for (NSString *chessPosition in allPosition) {
        [self setCellStatus:player AtPosition:chessPosition];
    }
    
    [self nextPlayer];
    
    return allPosition;
}

- (BOOL)isCanLayDownAtPosition:(NSString *)position withPlayer:(NSString *)player
{
    if (![self isValidPlayer:player]) {
        return NO;
    }
    
    if (![self isValidPosition:position]) {
        return NO;
    }
    
    NSString *newPositon;
    for (NSNumber *direction in [self getAllDirection]) {
        //取得该方向的相邻棋子位置
        newPositon = [self getPositionWithDirection:direction atPosition:position];
        
        //判断该位置的棋子是否同色
        while ([[self getCellStatusWithPosition:newPositon] isEqualToString:[self getOpponentWithPlayer:player]]) {
            newPositon = [self getPositionWithDirection:direction atPosition:newPositon];
            
            NSString *cellStatus = [self getCellStatusWithPosition:newPositon];
            if ([cellStatus isEqualToString:_null] || [cellStatus isEqualToString:_blank]) {
                break;
            } else if ([cellStatus isEqualToString:player]) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSArray *)getAllDirection
{
    NSArray *directions = [NSArray arrayWithObjects:
                           [NSNumber numberWithInt:ChessCellDirectionLeft],
                           [NSNumber numberWithInt:ChessCellDirectionLow],
                           [NSNumber numberWithInt:ChessCellDirectionLowLeft],
                           [NSNumber numberWithInt:ChessCellDirectionLowRight],
                           [NSNumber numberWithInt:ChessCellDirectionRight],
                           [NSNumber numberWithInt:ChessCellDirectionTop],
                           [NSNumber numberWithInt:ChessCellDirectionTopLeft],
                           [NSNumber numberWithInt:ChessCellDirectionTopRight],
                           nil];
    return directions;
}

- (void)nextPlayer
{
    if([_currentPlayer isEqualToString:_black]) {
        self.currentPlayer = _white;
    } else {
        self.currentPlayer = _black;
    }
}


- (void)test
{
    [self initializeChessBoard];
    NSLog(@"显示整个棋盘数组 %@",_chessboard);
    
    //测试position是否有效
    NSLog(@"位置da 是无效的  %@",[self isValidPosition:@"da"] ? @"true" : @"false"); //false
    NSLog(@"位置e5 是有效的  %@",[self isValidPosition:@"e5"] ? @"true" : @"false"); //true

    NSLog(@"位置e6 的上方是 %@", [self getPositionWithDirection:[NSNumber numberWithInt:ChessCellDirectionTop] atPosition:@"e6"]); //e5
    NSLog(@"位置e8 的下方是 %@", [self getPositionWithDirection:[NSNumber numberWithInt:ChessCellDirectionLow] atPosition:@"e8"]); //null
    
    NSLog(@"位置f5 是否可以落黑子? %@", [self isCanLayDownAtPosition:@"f5" withPlayer:_black] ? @"YES" : @"NO" ); // YES
    NSLog(@"位置e3 是否可以落黑子? %@", [self isCanLayDownAtPosition:@"e3" withPlayer:_black] ? @"YES" : @"NO" ); // NO
    NSLog(@"位置f5 是否可以落白子? %@", [self isCanLayDownAtPosition:@"f5" withPlayer:_white] ? @"YES" : @"NO" ); // NO
    NSLog(@"位置d6 是否可以落白子? %@", [self isCanLayDownAtPosition:@"d6" withPlayer:_white] ? @"YES" : @"NO" ); // YES
    NSLog(@"位置c4 是否可以落白子? %@", [self isCanLayDownAtPosition:@"c4" withPlayer:_white] ? @"YES" : @"NO" ); //NO
    
    
    NSLog(@"落子位置f5 , e5 应该变黑子? %@", [self layDownAtPosition:@"f5" withPlayer:_black] ? @"YES" : @"NO");
    NSLog(@"显示整个棋盘数组 %@",_chessboard); 
}

@end
