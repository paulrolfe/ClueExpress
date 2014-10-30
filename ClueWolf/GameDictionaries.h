//
//  GameDictionaries.h
//  ClueWolf
//
//  Created by Paul Rolfe on 10/26/14.
//  Copyright (c) 2014 Paul Rolfe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameDictionaries : NSObject

+(NSArray *)initRooms;
+(NSArray *)initPeople;
+(NSArray *)initWeapons;
+(int)secondsPerRoundForPlayers:(int)players;

@end
