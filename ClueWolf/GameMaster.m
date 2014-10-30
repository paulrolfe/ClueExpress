//
//  GameMaster.m
//  ClueWolf
//
//  Created by Paul Rolfe on 10/26/14.
//  Copyright (c) 2014 Paul Rolfe. All rights reserved.
//

#import "GameMaster.h"
#import "GameDictionaries.h"

#define cStateMurderWeaponIs 0
#define cStateNameWeapon 1
#define cStateRemember 2
#define cStateNightTime 3
#define cStateDayTimeIntro 4
#define cStateDayTime 5
#define cStateGameEnded 6


@implementation GameMaster{
    NSMutableArray * activePeople;
    NSMutableArray * activeRooms;
    NSMutableArray * activeWeapons;
    NSMutableArray * nightPeople;
    int chosenWeaponIndex;
    int numberOfPlayers;
    int dayTimeSeconds;
    AVAudioPlayer *audioPlayer;
    AVAudioPlayer *backgroundAudioPlayer;
    int gameState;
    int nighttimeIndex;
    int whichDay;
    NSTimer * dayTimer;
    int actionToTake;
    int secondsLeftOnTimer;
    int activeRoomIndex;
    CGRect originalFrame;
}
#pragma mark - Setup
-(void)startWithNumberOfPlayers:(int)number{
    //game setup
    numberOfPlayers=number;
    nighttimeIndex=0;
    whichDay=0;
    
    [self determineActiveArrays];
    
    chosenWeaponIndex = arc4random() % activeWeapons.count;
    
    dayTimeSeconds = [GameDictionaries secondsPerRoundForPlayers:number];
    
    //begin narrations
    gameState=cStateMurderWeaponIs;
    [self introduceBodyAndWeapon];

}
-(void)determineActiveArrays{
    
    NSArray * allpeople = [GameDictionaries initPeople];
    NSArray * allweapons = [GameDictionaries initWeapons];
    NSArray * allrooms = [GameDictionaries initRooms];
    
    activePeople = [[NSMutableArray alloc] init];
    activeWeapons = [[NSMutableArray alloc] init];
    activeRooms = [[NSMutableArray alloc] init];
    nightPeople = [[NSMutableArray alloc] init];

    
    for (int i=0;i<10;i++){
        if ([allpeople[i][@"minplayers" ]intValue]<=numberOfPlayers){
            [activePeople addObject:allpeople[i]];
        }
        if ([allweapons[i][@"minplayers" ]intValue]<=numberOfPlayers){
            [activeWeapons addObject:allweapons[i]];
        }
        if ([allrooms[i][@"minplayers" ]intValue]<=numberOfPlayers){
            [activeRooms addObject:allrooms[i]];
        }
    }
    //Get night people, did this, so that we are able to easily change the night time characters.
    for (int i=0;i<activePeople.count;i++){
        if ([activePeople[i][@"nightbool" ] boolValue]){
            [nightPeople addObject:activePeople[i]];
        }
    }
}
#pragma mark - Audio completion handling
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //Every time an audio clip finishes playing, it checks here for what to do next.
    
    if (flag){
        audioPlayer=nil;
        
        switch (gameState) {
            case cStateMurderWeaponIs://after murder announcement
                gameState=cStateNameWeapon;
                [self introduceBodyAndWeapon];
                break;
            case cStateNameWeapon://after weapon announcement
                gameState=cStateRemember;
                [self introduceBodyAndWeapon];
                break;
            case cStateRemember://after remember statement
                gameState=cStateNightTime;
                [self nightBackgroundSounds];
                [self nightloop];
                break;
            case cStateNightTime://called after every night character's audio
                if (nighttimeIndex<nightPeople.count+2){
                    [self nightloop];
                }
                else{ //going to day time.
                    nighttimeIndex=0;
                    gameState=cStateDayTimeIntro;
                    [self dayIntro];
                }
                break;
            case cStateDayTime: //called after room intro is done.
                if (whichDay<3){ //because there are three days.
                    [self dayloop];
                }
                else{
                    [self gameIsEnding];
                }
                break;
            case cStateDayTimeIntro: //called after room audio is done.
                //Check if there are any actions
                if ([activeRooms[activeRoomIndex][@"actions"] intValue]!=0){
                    [self committAction:[activeRooms[activeRoomIndex][@"actions"] intValue]];
                }
                //remove the room from active, so we don't repeat.
                [activeRooms removeObjectAtIndex:activeRoomIndex];
                break;
            case cStateGameEnded:
                [self gameEnded];
                break;
            default:
                break;
        }
    }
}
-(void)committAction:(int)action{
    //handle the actions of the room cards.
    //These action integers match up to the GameDictionaries.
    
    switch (action) {
        case 2: //ends the game.
            if (whichDay!=0)
                [self endGameNow];
            break;
        case 1: //makes it night time.
            [self suddenlyNight];
            break;
        case 3: //adds the wind bottle.
            if (chosenWeaponIndex!=9)
                [self wineBottleToMurderWeapons];
            break;
        case 4: //makes the horse shoe the only murder weapon.
            [self horseshowIsMurderWeapon];
            break;
        default:
            break;
    }
}

#pragma mark - Beginning Audio
-(void)introduceBodyAndWeapon{
    //shows images with narrations.
    NSURL *url;
    switch (gameState) {
        case cStateMurderWeaponIs:
            url=[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                        pathForResource:@"themurderweaponis"
                                        ofType:@"mp3"]];

            break;
        case cStateNameWeapon:
            url=[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                        pathForResource:activeWeapons[chosenWeaponIndex][@"filename"]
                                        ofType:@"mp3"]];
            [self.viewController.weaponImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",activeWeapons[chosenWeaponIndex][@"filename"]]]];
            [self.viewController.murderWeaponLabel setHidden:NO];
            originalFrame = self.viewController.weaponImage.frame; //got to set it sometime.

            break;
        case cStateRemember:
            url=[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                        pathForResource:@"remember"
                                        ofType:@"mp3"]];
            break;

        default:
            return;
            break;
    }
    
    audioPlayer = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:url
                                  error:nil];
    audioPlayer.delegate=self;
    
    [audioPlayer play];
}
#pragma mark - Night time
-(void)nightBackgroundSounds{
    NSURL *url =[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                        pathForResource:@"backgroundtrain2"
                                        ofType:@"mp3"]];
    
    backgroundAudioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:nil];
    backgroundAudioPlayer.delegate=self;
    backgroundAudioPlayer.volume=.2;
    
    [backgroundAudioPlayer play];
}
-(void)nightloop{
    //play a character sound file, display the image and text
    //on completion, run again with index+1
    //the audio completion handler will stop it when it's done and move to the next phase.
    [self.viewController.roundLabel setText:@"Night Time"];
    [self.viewController.timeRemainingLabel setText:@""];
    self.viewController.nightButton.enabled=NO;

    NSURL * url;
    if (nighttimeIndex==0){//night time starting, lights out.
        url =[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                     pathForResource:@"lightsout"
                                     ofType:@"mp3"]];
        
        
        [self.viewController.roomImage setImage:[UIImage imageNamed:@"nightholder.png"]];
        [self.viewController.roomLabel setText:@"Everyone close your eyes."];
    }
    else if (nighttimeIndex==nightPeople.count+1){//night time done, lights on.
        
        [backgroundAudioPlayer stop];
        backgroundAudioPlayer=nil;
        
        url =[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                     pathForResource:@"lightson"
                                     ofType:@"mp3"]];
        
        
        [self.viewController.roomImage setImage:[UIImage imageNamed:@"nightholder.png"]];
        [self.viewController.roomLabel setText:@"Everyone open your eyes."];
    }
    else{
        url =[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                            pathForResource:nightPeople[nighttimeIndex-1][@"filename"]
                                            ofType:@"mp3"]];

        
        [self.viewController.roomImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",nightPeople[nighttimeIndex-1][@"filename"]]]];
        [self.viewController.roomLabel setText:nightPeople[nighttimeIndex-1][@"text"]];
    }
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:nil];
    audioPlayer.delegate=self;
    
    [audioPlayer play];
    
    nighttimeIndex++;
}
#pragma mark - Day time
-(void)dayIntro{
    //Where we play the next card is... audio.
    NSString * dayIntroFilename;
    if(whichDay==0){
        [self.viewController.roundLabel setText:@"Get ready!"];
        dayIntroFilename=@"firstroom";
        [self.viewController.roomImage setImage:nil];
    }
    else if (whichDay==1){
        [self.viewController.roundLabel setText:@"Next room..."];
        dayIntroFilename=@"nextroom";
    }
    else if (whichDay==2){
        [self.viewController.roundLabel setText:@"Last room..."];
        dayIntroFilename=@"lastroom";
    }
    else{
        [self gameIsEnding];
        return;
    }
    [self.viewController.timeRemainingLabel setText:@""];
    
    NSURL *url =[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                        pathForResource:dayIntroFilename
                                        ofType:@"mp3"]];
    
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:nil];
    audioPlayer.delegate=self;
    
    [audioPlayer play];
    
    gameState=cStateDayTime;
}
-(void)dayloop{
    //Pick a random card from activeRooms
    //Play audio based on the day (i.e. Walk into the first/next/last car of the train and it's the _______
    //Do the action if needed, otherwise just start a timer for the dayTimeSeconds
    //remove the room from active rooms after using.
    //at end of dayTimer play another loop unless it's the last day...
    
    [self.viewController.roundLabel setText:[NSString stringWithFormat:@"Round %d",whichDay+1]];
    [self.viewController.nightButton setEnabled:YES];
    [self.viewController.skipDay setEnabled:YES];

    
    activeRoomIndex = arc4random() % activeRooms.count;
    
    NSURL *url =[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                 pathForResource:activeRooms[activeRoomIndex][@"filename"]
                                 ofType:@"mp3"]];
    
    
    [self.viewController.roomImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",activeRooms[activeRoomIndex][@"filename"]]]];
    [self.viewController.roomLabel setText:activeRooms[activeRoomIndex][@"text"]];
    
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:nil];
    audioPlayer.delegate=self;
    
    [audioPlayer play];
    
    whichDay++;
    gameState=cStateDayTimeIntro;
    
    dayTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:dayTimer forMode:NSDefaultRunLoopMode];
    secondsLeftOnTimer=dayTimeSeconds;
}
-(void)timerHandler:(NSTimer *)timer{
    int minutesLeft=(secondsLeftOnTimer/60)%60;
    int secondsLeft=secondsLeftOnTimer%60;
    
    [self.viewController.timeRemainingLabel setText:[NSString stringWithFormat:@"%02d:%02d",minutesLeft,secondsLeft]];
    
    if (secondsLeftOnTimer==0){
        [timer invalidate];
        [self dayIntro];
    }
    else
        secondsLeftOnTimer--;
}
#pragma mark - End of game
-(void)gameIsEnding{
    //play audio file that counts down 5 seconds. "Point at the person with the murder weapon in 5,4,3,2,1 Point!"
    //Then on completion, something that explains ending, doesn't have to be said aloud.
    //EX: Whoever named the right killer wins. If you're the killer and no one picked you, you win.
    [self.viewController.roundLabel setText:@"Time's up!"];
    [self.viewController.timeRemainingLabel setText:@""];
    
    [self.viewController.pauseButton setHidden:YES];
    [self.viewController.nightButton setHidden:YES];
    [self.viewController.skipDay setHidden:YES];
    
    NSURL *url =[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                        pathForResource:@"timesup"
                                        ofType:@"mp3"]];
    
    
    [self.viewController.roomImage setHidden:YES];
    [self.viewController.roomLabel setText:@"Point at the person with the murder weapon in 5,4,3,2,1 Point!"];
    
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:nil];
    audioPlayer.delegate=self;
    
    [audioPlayer play];
    [self.viewController.endButton setTitle:@"DONE" forState:UIControlStateNormal];
    self.gameIsOver=YES;

    gameState=cStateGameEnded;

    
}
-(void)gameEnded{
    [self.viewController.roundLabel setText:@"Game Over"];

    [self.viewController.roomLabel setText:@"Whoever named the right killer wins. If you're the killer and no one picked you, you win."];
    [self.viewController.roomLabel setMinimumScaleFactor:.5];
    [self.viewController.roomLabel setNeedsLayout];
}

#pragma mark - Buttons and Actions
-(void)wineBottleToMurderWeapons{
    [self.viewController.murderWeaponLabel setText:@"Murder Weapons"];
    //add a new image view.
    
    UIImageView * newWeapon = [[UIImageView alloc] initWithFrame:CGRectOffset(originalFrame, originalFrame.size.width+8, 0)];
    [newWeapon setImage:[UIImage imageNamed:@"winebottle"]];
    newWeapon.tag=5;
    [self.viewController.view addSubview:newWeapon];

}
-(void)horseshowIsMurderWeapon{
    [self.viewController.murderWeaponLabel setText:@"Murder Weapon"];
    [[self.viewController.view viewWithTag:5] removeFromSuperview];
    [self.viewController.weaponImage setFrame:originalFrame];
    [self.viewController.weaponImage setImage:[UIImage imageNamed:@"horseshoe.png"]];
}
-(void)pauseGame{
    self.gameIsPaused=YES;
    if (audioPlayer){
        [audioPlayer pause];
    }
    if (backgroundAudioPlayer)
        [backgroundAudioPlayer pause];
    if (dayTimer){
        //pause this somehow. Timer needs to be reworked to show the timer countdown clock anyways.
        [dayTimer invalidate];
    }
    [self.viewController.nightButton setEnabled:NO];
    [self.viewController.skipDay setEnabled:NO];
    [self.viewController.endButton setEnabled:NO];
}
-(void)playGame{
    self.gameIsPaused=NO;
    if (audioPlayer){
        [audioPlayer play];
    }
    if (backgroundAudioPlayer)
        [backgroundAudioPlayer play];
    if (dayTimer){
        //play this somehow. Timer needs to be reworked to show the timer countdown clock anyways.
        dayTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:dayTimer forMode:NSDefaultRunLoopMode];
        
    }
    [self.viewController.endButton setEnabled:YES];
    if (gameState==cStateDayTime||gameState==cStateDayTimeIntro){
        [self.viewController.skipDay setEnabled:YES];
        [self.viewController.nightButton setEnabled:YES];
    }

}
-(void)skipDay{
    if (audioPlayer){
        [audioPlayer stop];
        audioPlayer=nil;
    }
    if (backgroundAudioPlayer){
        [backgroundAudioPlayer stop];
        backgroundAudioPlayer=nil;
    }
    if (dayTimer){
        [dayTimer invalidate];
    }
    [self dayIntro];
}
-(void)suddenlyNight{
    if (audioPlayer){
        [audioPlayer stop];
        audioPlayer=nil;
    }
    if (dayTimer){
        [dayTimer invalidate];
        dayTimer=nil;
    }
    [self.viewController.skipDay setEnabled:NO];
    [self nightBackgroundSounds];
    [self nightloop];
    gameState=cStateNightTime;
}
-(void)endGameNow{
    if (audioPlayer){
        [audioPlayer stop];
        audioPlayer=nil;
    }
    if (backgroundAudioPlayer){
        [backgroundAudioPlayer stop];
        backgroundAudioPlayer=nil;
    }
    if (dayTimer){
        [dayTimer invalidate];
        dayTimer=nil;
    }
    [self gameIsEnding];
}

@end
