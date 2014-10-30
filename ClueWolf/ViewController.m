//
//  ViewController.m
//  ClueWolf
//
//  Created by Paul Rolfe on 10/25/14.
//  Copyright (c) 2014 Paul Rolfe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize playerCountLabel,stepper,startButton,Logo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    stepper.minimumValue=3;
    stepper.maximumValue=10;
    stepper.stepValue=1;
    stepper.continuous=NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepperChanged:(id)sender {
    playerCountLabel.text =[NSString stringWithFormat:@"%.0f",stepper.value];
}

- (IBAction)startTouched:(id)sender {
    //handled by segue in storyboard
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    GamePlayController * game = [segue destinationViewController];
    [game setNumberOfPlayers:playerCountLabel.text.intValue];
    
    //fade in the game controller. (done via segue in storyboard)
}
@end
