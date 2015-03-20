//
//  BDExplodingBall.h
//  Boom Diggity
//
//  Created by Rob Norback on 3/17/15.
//  Copyright (c) 2015 Sidecar Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const uint32_t kLittleBallCategory = 0x1 << 0;
static const uint32_t kExplodingBallCategory = 0x1 << 1;
static const uint32_t kEdgeCategory = 0x1 << 2;

@interface BDExplodingBall : SKSpriteNode

-(instancetype)initRandomBallWithinFrame:(CGRect)frame;
-(instancetype)initWithPosition:(CGPoint)position andColor:(NSString *)colorName;
-(int)getBallSpeed;
-(void)explode;

@end
