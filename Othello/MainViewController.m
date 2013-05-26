//
//  MainViewController.m
//  Othello
//
//  Created by YauzZ on 13年5月24日.
//  Copyright (c) 2013年 Colin Yang Hong. All rights reserved.
//

#import "MainViewController.h"
#import "ChessBoard.h"

@interface MainViewController ()

@property (nonatomic, retain) ChessBoard *chessboard;

@property (nonatomic, retain) NSMutableDictionary *allChesses;

@property (nonatomic, retain) NSString *currentPlayer;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.chessboard = [[[ChessBoard alloc] init] autorelease];
        [_chessboard initializeChessBoard];
        _currentPlayer = _chessboard.black;
    }
    return self;
}

- (CGPoint)getPointWithPositon:(NSString *)positon
{
    NSInteger x,y;
    x = ([positon characterAtIndex:0] - 'a') * 96 ;
    y = ([positon characterAtIndex:1] - '1' )* 96  + 100;
    return CGPointMake(x, y);
}

- (NSString *)getPositionWithPoint:(CGPoint)point
{
    char x = (((int)point.x - 0) / 96) + 'a';
    char y = ((int)point.y - 100) / 96 + '1';
    NSString *position = [NSString stringWithFormat:@"%c%c", x, y];
    return position;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allChesses = [[[NSMutableDictionary alloc] initWithCapacity:64] autorelease];
    
    for (NSString *cellPosition in [_chessboard.chessboard allKeys]) {
        
        CGPoint origin = [self getPointWithPositon:cellPosition];
        
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, 96, 96 )] autorelease];
        
        NSString *status = [_chessboard.chessboard valueForKey:cellPosition];
        
        if ([status isEqualToString:_chessboard.black]) {
            view.backgroundColor = [UIColor blackColor];
        } else if ([status isEqualToString:_chessboard.white]) {
            view.backgroundColor = [UIColor whiteColor];
        } else {
            view.backgroundColor = [UIColor blueColor];
        }
        
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChess:)] autorelease];
        [view addGestureRecognizer:tap];
        [self.view addSubview:view];
        
        [_allChesses setObject:view forKey:cellPosition];
    }
	// Do any additional setup after loading the view.
}

- (void)refreshChessboard
{
    for (NSString *chessPosition in [_chessboard.chessboard allKeys]) {
        NSString *status = [_chessboard.chessboard valueForKey:chessPosition];
        UIView *view = [_allChesses valueForKey:chessPosition];
        
        if ([status isEqualToString:_chessboard.black]) {
            view.backgroundColor = [UIColor blackColor];
        } else if ([status isEqualToString:_chessboard.white]) {
            view.backgroundColor = [UIColor whiteColor];
        } else {
            view.backgroundColor = [UIColor blueColor];
        }
    }
}

- (void)switchPlayer
{
    if ([_currentPlayer isEqualToString:_chessboard.black]) {
        _currentPlayer = _chessboard.white;
    } else {
        _currentPlayer = _chessboard.black;
    }
}

- (void)tapChess:(UITapGestureRecognizer *)sender
{
    NSLog(@"%@",sender.view);
    
    if (sender.view.backgroundColor == [UIColor blackColor] || sender.view.backgroundColor == [UIColor whiteColor]) {
        return;
    } else {
        NSString *postion = [self getPositionWithPoint:sender.view.frame.origin];
        if ([_chessboard isCanLayDownAtPosition:postion withPlayer:_currentPlayer]) {
            [_chessboard layDownAtPosition:postion withPlayer:_currentPlayer];
            [self refreshChessboard];
            [self switchPlayer];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
