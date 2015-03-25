//
//  BDMenu.m
//  Boom Diggity
//
//  Created by Rob Norback on 3/22/15.
//  Copyright (c) 2015 Sidecar Games. All rights reserved.
//

#import "BDMenu.h"

@implementation BDMenu{
    SKLabelNode *_levelLabel;
    SKLabelNode *_numberOfExplosionsLabel;
    SKLabelNode *_successLabel;
    SKLabelNode *_clickToContinueLabel;
    SKScene *_gameScene;
}

- (instancetype)initWithScene:(SKScene*)gameScene
{
    self = [super init];
    if (self) {
        _gameScene = gameScene;
        
        _successLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        _successLabel.fontColor = [UIColor whiteColor];
        _successLabel.fontSize = 20;
        _successLabel.position = CGPointMake(gameScene.size.width/2, gameScene.size.height/2);
        _successLabel.text = [NSString stringWithFormat:@"YOU WIN!"];
        
        _levelLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        _levelLabel.fontColor = [UIColor whiteColor];
        _levelLabel.fontSize = 20;
        _levelLabel.position = CGPointMake(gameScene.size.width/2, gameScene.size.height/2);
        _levelLabel.text = [NSString stringWithFormat:@"Level: 1"];
        
        _numberOfExplosionsLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        _numberOfExplosionsLabel.fontColor = [UIColor whiteColor];
        _numberOfExplosionsLabel.fontSize = 20;
        _numberOfExplosionsLabel.position = CGPointMake(gameScene.size.width/2, gameScene.size.height/2);
        _numberOfExplosionsLabel.text = [NSString stringWithFormat:@"Number of Explosions: 2/1"];
        
        _clickToContinueLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        _clickToContinueLabel.fontColor = [UIColor whiteColor];
        _clickToContinueLabel.fontSize = 20;
        _clickToContinueLabel.position = CGPointMake(gameScene.size.width/2, gameScene.size.height/2);
        _clickToContinueLabel.text = [NSString stringWithFormat:@"(Click to Continue...)"];
        
        self.hidden = YES;
        self.alpha = 0;
        
        [self addChild:_levelLabel];
        [self addChild:_numberOfExplosionsLabel];
        [self addChild:_successLabel];
        [self addChild:_clickToContinueLabel];
    }
    return self;
}

-(void)hideMenu
{
    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:1.0];
    SKAction *moveUp1x = [SKAction moveBy:CGVectorMake(0, 50) duration:1.0];
    SKAction *moveUp2x = [SKAction moveBy:CGVectorMake(0, 100) duration:1.0];
    SKAction *moveDown1x = [SKAction moveBy:CGVectorMake(0, -50) duration:1.0];
    SKAction *moveDown2x = [SKAction moveBy:CGVectorMake(0, -100) duration:1.0];
    
    [self runAction:fadeOut];
    [_successLabel runAction:moveDown2x];
    [_levelLabel runAction:moveDown1x];
    [_numberOfExplosionsLabel runAction:moveUp1x];
    [_clickToContinueLabel runAction:moveUp2x];
}

-(void)showMenu
{
    self.hidden = NO;
    
    SKAction *fadeIn = [SKAction fadeAlphaTo:1.0 duration:1.0];
    SKAction *moveUp1x = [SKAction moveBy:CGVectorMake(0, 50) duration:1.0];
    SKAction *moveUp2x = [SKAction moveBy:CGVectorMake(0, 100) duration:1.0];
    SKAction *moveDown1x = [SKAction moveBy:CGVectorMake(0, -50) duration:1.0];
    SKAction *moveDown2x = [SKAction moveBy:CGVectorMake(0, -100) duration:1.0];
    
    [self runAction:fadeIn];
    [_successLabel runAction:moveUp2x];
    [_levelLabel runAction:moveUp1x];
    [_numberOfExplosionsLabel runAction:moveDown1x];
    [_clickToContinueLabel runAction:moveDown2x];
}

@end
