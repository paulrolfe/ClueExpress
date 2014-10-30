//
//  GamePlayController.m
//  ClueWolf
//
//  Created by Paul Rolfe on 10/25/14.
//  Copyright (c) 2014 Paul Rolfe. All rights reserved.
//

#import "GamePlayController.h"

@implementation GamePlayController{
}

@synthesize currentGame,pauseButton,endButton,nightButton,logo,roomImage,roomLabel,weaponImage,numberOfPlayers,murderWeaponLabel,roundLabel,timeRemainingLabel,skipDay;

-(void)viewDidLoad{
    //start the game master.
    currentGame = [[GameMaster alloc] init];
    currentGame.viewController=self;
    [currentGame startWithNumberOfPlayers:numberOfPlayers];
    
    roomLabel.text=@"";
    murderWeaponLabel.hidden=YES;
    roundLabel.text=@"";
    timeRemainingLabel.text=@"";
    nightButton.enabled=NO;
    skipDay.enabled=NO;
    
    nightButton.layer.cornerRadius=3;
    skipDay.layer.cornerRadius=3;
    pauseButton.layer.cornerRadius=3;
    endButton.layer.cornerRadius=3;

}
-(void)viewDidAppear:(BOOL)animated{
    
}

- (IBAction)nightAction:(id)sender {//only available during the day.
    [currentGame suddenlyNight];
}

- (IBAction)pauseAction:(id)sender {
    if (currentGame.gameIsPaused){
        [currentGame playGame];
        [pauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];

    }
    else{
        [currentGame pauseGame];
        [pauseButton setTitle:@"PLAY" forState:UIControlStateNormal];
    }
}

- (IBAction)endAction:(id)sender {
    if (currentGame.gameIsOver){
        [currentGame pauseGame];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [currentGame endGameNow];
    }
}

- (IBAction)skipDayAction:(id)sender {
    [currentGame skipDay];
}
@end
