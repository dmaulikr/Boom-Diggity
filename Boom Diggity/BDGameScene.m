//
//  BDGameScene.m
//  Boom Diggity
//
//  Created by Rob Norback on 3/17/15.
//  Copyright (c) 2015 Sidecar Games. All rights reserved.
//

#import "BDGameScene.h"
#import "BDExplodingBall.h"
#import "BDMenu.h"
#import <AVFoundation/AVFoundation.h>

@implementation BDGameScene
{
    // Main View Elements
    SKNode *_mainLayer;
    SKScene *_pauseScene;
    BOOL _ranInitialExplosion;
    BDExplodingBall *_explodingBall;
    int _numberOfBallsOnScreen;
    //int _numberOfCreatedExplosions;
    NSArray *_levelWinValues;
    AVAudioPlayer *_backgroundMusic;
    BDMenu *_menu;
    SKLabelNode *_goalLabel;
}

-(id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {
        // Modify physics world
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        // Create border
        SKNode *border = [[SKNode alloc] init];
        border.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        border.physicsBody.categoryBitMask = kEdgeCategory;
        [self addChild:border];
        
        // Create mainLayer
        _mainLayer = [SKNode node];
        [self addChild:_mainLayer];
        
        // Create menu
        _menu = [[BDMenu alloc]initWithScene:self];
        [self addChild:_menu];
        
        // Create goal label
        _goalLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        _goalLabel.fontColor = [SKColor whiteColor];
        _goalLabel.fontSize = 20;
        _goalLabel.text = [NSString stringWithFormat:@"Goal: %i/%i",0,_currentLevel];
        _goalLabel.position = CGPointMake(40, 0);
        [self addChild:_goalLabel];
        
        // Create background music
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"HappySongMono" withExtension:@"caf"];
        NSError *error = nil;
        _backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (!_backgroundMusic) {
            NSLog(@"Error loading audio player: %@", error);
        }
        else {
            _backgroundMusic.numberOfLoops = -1;
            _backgroundMusic.volume = 0.2;
        }
        
        // Initialize game values
        _currentLevel = 0;
        
        // Initialize game win conditions
        _levelWinValues = @[@0,@1,@2,@3,@5,@7,@10,@15,@21,@27,@33,@40,@50,@55];
        //                      5 10 15 20 25  30  35  40  45  50  55  60  65
        
        // Create a new game
        //[_backgroundMusic play];
        [self loadNextLevel];
        
        
    }
    
    return self;
}



// LEVEL CREATION

-(void)loadNextLevel
{
    _currentLevel++;
    _numberOfBallsOnScreen = _currentLevel * 5;
    //_numberOfCreatedExplosions = 0;
    _ranInitialExplosion = NO;
    
    [_mainLayer removeAllChildren];
    
    // Create background
    self.backgroundColor = [SKColor blackColor];
    self.isMenuShowing = YES;
    
    BDExplodingBall *randomBall;
    for (int i = 0; i < _numberOfBallsOnScreen; i++) {
        randomBall = [[BDExplodingBall alloc] initRandomBallWithinFrame:self.frame];
        [_mainLayer addChild:randomBall];
    }
}

// VARIABLE HANDLING

-(void)setIsMenuShowing:(BOOL)isMenuShowing
{
    _isMenuShowing = isMenuShowing;
    
    if (_isMenuShowing) {
        [_menu showMenu];
    }
    else{
        [_menu hideMenu];
    }
}

// CONTACT HANDLING

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    // Smaller bit mask is the firstBody, larger bit mask is the secondBody
    
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody.categoryBitMask == kLittleBallCategory && secondBody.categoryBitMask == kExplodingBallCategory) {
        // Little ball collides with exploding ball
        if ([firstBody.node isKindOfClass:[BDExplodingBall class]])
        {
            [(BDExplodingBall*)firstBody.node explode];
        }
        
    }
}

-(void)update:(NSTimeInterval)currentTime
{
    if (_ranInitialExplosion && [self isLevelComplete])
    {
        if ([self numberOfBallsExploded] >= [[_levelWinValues objectAtIndex:_currentLevel] intValue]) {
            NSLog(@"Current Level:%i",_currentLevel);
            NSLog(@"YOU WIN");
            NSLog(@"Number of Explosions:%i",[self numberOfBallsExploded]);
            
        }
        else
        {
            NSLog(@"Current Level:%i",_currentLevel);
            NSLog(@"NOT ENOUGH EXPLOSIONS!");
            NSLog(@"Number of Explosions:%i",[self numberOfBallsExploded]);
            _currentLevel--;
            _numberOfBallsOnScreen -= 5;
        }
        
        if (_currentLevel == 13) {
            // Restart the game
            _currentLevel = 0;
            _numberOfBallsOnScreen = 0;
        }
        [self loadNextLevel];
    }
    
    // If you exploded enough balls change the background color
    if ([self numberOfBallsExploded] == [[_levelWinValues objectAtIndex:_currentLevel] intValue]) {
        //self.backgroundColor = [SKColor colorWithRed:.996 green:.733 blue:.031 alpha:1.0];
        self.backgroundColor = [SKColor whiteColor];
    }
}

-(int)numberOfBallsExploded
{
    int numberOfBallsLeft = 0;
    
    for (SKNode *node in _mainLayer.children) {
        if ([node isKindOfClass:[BDExplodingBall class]]) {
            if([node.name isEqualToString:@"ball"])
            {
                numberOfBallsLeft++;
            }
        }
    }
    
    // Return number of balls exploded
    return (5 * _currentLevel) - numberOfBallsLeft;

}

-(BOOL)isLevelComplete
{
    // Look for remaining explosions
    for (SKNode *node in _mainLayer.children) {
        if ([node isKindOfClass:[BDExplodingBall class]]) {
            if([node.name isEqualToString:@"explodingBall"])
            {
                return NO;
            }
        }
    }
    // Couldn't find any exploding balls
    return YES;
}

// TOUCH HANDLING

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Called when touches begin
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        //SKNode *node = [self nodeAtPoint:location];
        
        if (_isMenuShowing) {
            self.isMenuShowing = NO;
        }
        else if (!_ranInitialExplosion) {
            _explodingBall = [[BDExplodingBall alloc] initWithPosition:location
                                                              andColor:@"BallGray"];
            [_mainLayer addChild:_explodingBall];
            [_explodingBall explode];
            //_numberOfCreatedExplosions++;
            _ranInitialExplosion = YES;
        }

    }
}


@end
