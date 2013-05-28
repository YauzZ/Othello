//
//  ChessBoard.h
//  Othello
//
//  Created by Colin Yang Hong on 13-5-22.
//  Copyright (c) 2013年 Colin Yang Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ChessCellDirectionTopLeft,
    ChessCellDirectionTop,
    ChessCellDirectionTopRight,
    ChessCellDirectionRight,
    ChessCellDirectionLowRight,
    ChessCellDirectionLow,
    ChessCellDirectionLowLeft,
    ChessCellDirectionLeft,
}ChessCellDirection;

@interface ChessBoard : NSObject

@property (nonatomic , retain, readonly) NSMutableDictionary *chessboard;

@property (nonatomic ,retain) NSString *white; // 白子
@property (nonatomic ,retain) NSString *black; // 黑子
@property (nonatomic ,retain) NSString *blank;// 无子
@property (nonatomic ,retain) NSString *null;  // 无效的格子

@property (nonatomic, retain) NSString *currentPlayer;
- (void)initializeChessBoard;
- (NSArray *)layDownAtPosition:(NSString *)position;
- (NSArray *)allAllowablePositions;
- (void)test;

@end
