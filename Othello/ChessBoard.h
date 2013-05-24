//
//  ChessBoard.h
//  Othello
//
//  Created by Colin Yang Hong on 13-5-22.
//  Copyright (c) 2013年 Colin Yang Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ChessTypeWhite ,
    ChessTypeBlack ,
}ChessType;

typedef enum {
    ChessCellStatusNull ,
    ChessCellStatusExist ,
}ChessCellStatus;

@interface ChessBoard : NSObject

@property (nonatomic ,retain) NSMutableDictionary *chessboard;

//@property (nonatomic ,assign) char chessboard[8][8];




- (void)test;

@end
