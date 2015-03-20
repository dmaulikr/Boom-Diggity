//
//  BDGameScene.m
//  Boom Diggity
//
//  Created by Rob Norback on 3/17/15.
//  Copyright (c) 2015 Sidecar Games. All rights reserved.
//

#import "BDGameScene.h"
#import "BDExplodingBall.h"

@implementation BDGameScene
{
    // Main View Elements
    SKNode *_mainLayer;
    BOOL _ranInitialExplosion;
    BDExplodingBall *_explodingBall;
    int _numberOfBallsOnScreen;
    //int _numberOfCreatedExplosions;
    NSArray *_levelWinValues;
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
        
        // Initialize game values
        _numberOfBallsOnScreen = 0;
        _currentLevel = 0;
        
        // Initialize game win conditions
        _levelWinValues = @[@0,@1,@2,@3,@5,@7,@10,@15,@21,@27,@33,@44,@55];
        
        // Create a new game
        [self loadNextLevel];
    }
    
    return self;
}

// LEVEL CREATION

-(void)loadNextLevel
{
    _currentLevel++;
    _numberOfBallsOnScreen += 5;
    //_numberOfCreatedExplosions = 0;
    _ranInitialExplosion = NO;
    
    [_mainLayer removeAllChildren];
    
    // Create background
    self.backgroundColor = [SKColor blackColor];
    
    
    BDExplodingBall *randomBall;
    for (int i = 0; i < _numberOfBallsOnScreen; i++) {
        randomBall = [[BDExplodingBall alloc] initRandomBallWithinFrame:self.frame];
        [_mainLayer addChild:randomBall];
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

// FRAME UPDATE HANDLING

-(void)didSimulatePhysics
{
    // Make the "ball" nodes travel at a constant velocity by normalizing their vectors and then multiplying them by the _ballSpeed
    [_mainLayer enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *node, BOOL *stop) {
        CGFloat xVel = node.physicsBody.velocity.dx;
        CGFloat yVel = node.physicsBody.velocity.dy;
        CGFloat unit = sqrt(pow(xVel,2) + pow(yVel,2));
        int ballSpeed = [(BDExplodingBall *)node getBallSpeed];
        node.physicsBody.velocity = CGVectorMake(xVel/unit * ballSpeed, yVel/unit * ballSpeed);
        
    }];
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
        
        if (_currentLevel == 12) {
            // Restart the game
            _currentLevel = 0;
            _numberOfBallsOnScreen = 0;
        }
        [self loadNextLevel];
    }
    
    // If you exploded enough balls change the background color
    if ([self numberOfBallsExploded] == [[_levelWinValues objectAtIndex:_currentLevel] intValue]) {
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
        
        if (!_ranInitialExplosion) {
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
