//
//  GamePlayController.h
//  ClueWolf
//
//  Created by Paul Rolfe on 10/25/14.
//  Copyright (c) 2014 Paul Rolfe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameMaster.h"

@class GameMaster;

@interface GamePlayController : UIViewController

@property GameMaster * currentGame;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *roomImage;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weaponImage;
@property (weak, nonatomic) IBOutlet UIButton *nightButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
- (IBAction)nightAction:(id)sender;
- (IBAction)pauseAction:(id)sender;
- (IBAction)endAction:(id)sender;
- (IBAction)skipDayAction:(id)sender;

@property int numberOfPlayers;
@property (weak, nonatomic) IBOutlet UILabel *murderWeaponLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRemainingLabel;
@property (weak, nonatomic) IBOutlet UIButton *skipDay;

@end
