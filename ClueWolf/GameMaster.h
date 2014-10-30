//
//  GameMaster.h
//  ClueWolf
//
//  Created by Paul Rolfe on 10/26/14.
//  Copyright (c) 2014 Paul Rolfe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "GamePlayController.h"

@class GamePlayController;

@interface GameMaster : NSObject<AVAudioPlayerDelegate>

@property GamePlayController * viewController;

-(void)startWithNumberOfPlayers:(int)number;
@property BOOL gameIsOver;
@property BOOL gameIsPaused;
-(void)endGameNow;
-(void)pauseGame;
-(void)playGame;
-(void)skipDay;
-(void)suddenlyNight;

@end
