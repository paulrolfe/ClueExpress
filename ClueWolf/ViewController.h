//
//  ViewController.h
//  ClueWolf
//
//  Created by Paul Rolfe on 10/25/14.
//  Copyright (c) 2014 Paul Rolfe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameMaster.h"
#import "GamePlayController.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *playerCountLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIImageView *Logo;
- (IBAction)stepperChanged:(id)sender;
- (IBAction)startTouched:(id)sender;

@end

