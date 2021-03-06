//
//  BDGameScene.h
//  Boom Diggity
//
//  Created by Rob Norback on 3/17/15.
//  Copyright (c) 2015 Sidecar Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BDGameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) int currentLevel;
@property (nonatomic) BOOL isMenuShowing;

@end
