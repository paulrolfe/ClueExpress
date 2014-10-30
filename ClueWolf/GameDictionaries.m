//
//  GameDictionaries.m
//  ClueWolf
//
//  Created by Paul Rolfe on 10/26/14.
//  Copyright (c) 2014 Paul Rolfe. All rights reserved.
//

#import "GameDictionaries.h"

@implementation GameDictionaries


+(NSArray *)initPeople{
    NSArray * data = @[
                       @{
                           @"name":@"Miss Scarlet",
                           @"text":@"You may swap your weapon card with another player",
                           @"filename":@"scarlet",
                           @"minplayers":@3,
                           @"nightbool":@YES
                           },
                       @{
                           @"name":@"Professor Plum",
                           @"text":@"All players must pass their weapons to the right.",
                           @"filename":@"plum",
                           @"minplayers":@3,
                           @"nightbool":@NO
                           },
                       @{
                           @"name":@"Mrs. White",
                           @"text":@"All players must pass their weapons to the left",
                           @"filename":@"white",
                           @"minplayers":@3,
                           @"nightbool":@NO
                           },
                       @{
                           @"name":@"Mr. Green",
                           @"text":@"Swap weapons with another player but do NOT look at their card.",
                           @"filename":@"green",
                           @"minplayers":@3,
                           @"nightbool":@NO
                           },
                       @{
                           @"name":@"Ms. Peacock",
                           @"text":@"Swap two players' weapons without look at them.",
                           @"filename":@"peacock",
                           @"minplayers":@3,
                           @"nightbool":@YES
                           },
                       @{
                           @"name":@"Colonel Mustard",
                           @"text":@"Look at another player's weapon.",
                           @"filename":@"mustard",
                           @"minplayers":@3,
                           @"nightbool":@YES
                           },
                       @{
                           @"name":@"The Marshal",
                           @"text":@"At any point you can make a final accusation and end the game.",
                           @"filename":@"marshal",
                           @"minplayers":@8,
                           @"nightbool":@NO
                           },
                       @{
                           @"name":@"The Waitress",
                           @"text":@"You may do any action that has been previously revealed by a day time character.",
                           @"filename":@"waitress",
                           @"minplayers":@9,
                           @"nightbool":@NO
                           },
                       @{
                           @"name":@"The Cook",
                           @"text":@"If the knife is a murder weapon, you are an accomplice. If not, you may swap weapons with the character to your left without looking at their card.",
                           @"filename":@"scarlet",
                           @"minplayers":@10,
                           @"nightbool":@NO
                           },
                       @{
                           @"name":@"The Engineer",
                           @"text":@"Skip a room and proceed to the next. If this is the last round, the game is over.",
                           @"filename":@"engineer",
                           @"minplayers":@7,
                           @"nightbool":@NO
                           }
                       ];
    
    return data;
}
+(NSArray *)initWeapons{
     NSArray * data = @[
                       @{
                           @"name":@"Candlestick",
                           @"filename":@"candlestick",
                           @"minplayers":@3
                           },
                       @{
                           @"name":@"Knife",
                           @"filename":@"knife",
                           @"minplayers":@3
                           },
                       @{
                           @"name":@"Pistol",
                           @"filename":@"pistol",
                           @"minplayers":@3
                           },
                       @{
                           @"name":@"Wrench",
                           @"filename":@"wrench",
                           @"minplayers":@4
                           },
                       @{
                           @"name":@"Rope",
                           @"filename":@"rope",
                           @"minplayers":@6
                           },
                       @{
                           @"name":@"Flashlight",
                           @"filename":@"flashlight",
                           @"minplayers":@9
                           },
                       @{
                           @"name":@"Telephone",
                           @"filename":@"telephone",
                           @"minplayers":@8
                           },
                       @{
                           @"name":@"Lead Pipe",
                           @"filename":@"leadpipe",
                           @"minplayers":@5
                           },
                       @{
                           @"name":@"Horseshoe",
                           @"filename":@"horseshoe",
                           @"minplayers":@10
                           },
                       @{
                           @"name":@"Wine Bottle",
                           @"filename":@"winebottle",
                           @"minplayers":@7
                           }
                       ];
    
    return data;
}
+(NSArray *)initRooms{
    NSArray * data = @[
                       @{
                           @"name":@"The Galley",
                           @"text":@"Everyone reveal your role to the player on your right.",
                           @"filename":@"galley",
                           @"minplayers":@3,
                           @"actions":@0
                           },
                       @{
                           @"name":@"The Quiet Car",
                           @"text":@"No one may use their daytime abilities. You may still discuss though.",
                           @"filename":@"quietcar",
                           @"minplayers":@3,
                           @"actions":@0
                           },
                       @{
                           @"name":@"The Coach",
                           @"text":@"Everyone pass your weapon card two players to the left.",
                           @"filename":@"coach",
                           @"minplayers":@3,
                           @"actions":@0
                           },
                       @{
                           @"name":@"The Observation Car",
                           @"text":@"Everyone may now look at their own weapon card.",
                           @"filename":@"observationcar",
                           @"minplayers":@3,
                           @"actions":@0
                           },
                       @{
                           @"name":@"The Sleeping Car",
                           @"text":@"The game will now end immediately.",
                           @"filename":@"sleepingcar",
                           @"minplayers":@3,
                           @"actions":@2 //Go to countdown mode.
                           },
                       @{
                           @"name":@"The Tunnel",
                           @"text":@"The lights have gone out again.",
                           @"filename":@"tunnel",
                           @"minplayers":@3,
                           @"actions":@1 //Go to night.
                           },
                       @{
                           @"name":@"The Lounge",
                           @"text":@"The wine bottle is also a murder weapon!",
                           @"filename":@"lounge",
                           @"minplayers":@7,
                           @"actions":@3 //Add wine bottle to murder weapons
                           },
                       @{
                           @"name":@"The Baggage Car",
                           @"text":@"Everyone pass your role card to the left except for face up roles.",
                           @"filename":@"baggagecar",
                           @"minplayers":@8,
                           @"actions":@0
                           },
                       @{
                           @"name":@"The Infirmary",
                           @"text":@"Players with face up role cards may return them to being face down.",
                           @"filename":@"infirmary",
                           @"minplayers":@9,
                           @"actions":@0
                           },
                       @{
                           @"name":@"The Horse Car",
                           @"text":@"The only murder weapon is now the horseshoe.",
                           @"filename":@"horsecar",
                           @"minplayers":@10,
                           @"actions":@4
                           }
                       ];
    return data;
}

+(int)secondsPerRoundForPlayers:(int)players{
    int result = 30 + (players-3)*5;
    
    return result;
}

@end
