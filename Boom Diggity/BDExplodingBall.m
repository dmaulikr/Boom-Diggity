//
//  BDExplodingBall.m
//  Boom Diggity
//
//  Created by Rob Norback on 3/17/15.
//  Copyright (c) 2015 Sidecar Games. All rights reserved.
//

#import "BDExplodingBall.h"

@implementation BDExplodingBall

static const int kBallSpeed = 40;
static const int kExplodingBallWaitTime = 2;
static const CGFloat kSizeOfExplodingBall = 2;//size multiplier

-(instancetype)initRandomBallWithinFrame:(CGRect)frame
{
    // Create a ball with a random color, placement, and direction of motion
    self = [super initWithImageNamed:[self returnBallWithRandomColor]];
    
    if (self) {
        [self createRandomBallWithinFrame:frame];
    }
    return self;
}

-(instancetype)initWithPosition:(CGPoint)position andColor:(NSString *)colorName
{
    // Create a ball with a specific position and color
    self = [super initWithImageNamed:colorName];
    
    if (self) {
        [self createBallAtPosition:position withVelocity:CGVectorMake(0, 0)];
    }
    return self;
}

-(void)createRandomBallWithinFrame:(CGRect)frame
{
    // Create a ball with a random direction and position
    
    int randomWidth = arc4random_uniform(frame.size.width);
    int randomHeight = arc4random_uniform(frame.size.height);
    CGPoint startingPoint = CGPointMake(randomWidth,randomHeight);
    int randomDirectionInDegrees = arc4random_uniform(360);
    CGFloat randDirInRadians = randomDirectionInDegrees * M_PI/180;
    CGFloat dx = cosf(randDirInRadians);
    CGFloat dy = sinf(randDirInRadians);
    CGVector startingVelocity = CGVectorMake(dx * kBallSpeed, dy * kBallSpeed);
    
    [self createBallAtPosition:startingPoint withVelocity:startingVelocity];
}

-(void)createBallAtPosition:(CGPoint)position withVelocity:(CGVector)velocity
{
    // Create a ball with the name "ball" and velocity that is specified, will travel at const velocity because of didSimulatePhysics method
    self.xScale = 0.4;
    self.yScale = 0.4;
    self.name = @"ball";
    self.position = position;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.velocity = velocity;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.friction = 0;
    self.physicsBody.restitution = 1.0;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.categoryBitMask = kLittleBallCategory;
    self.physicsBody.collisionBitMask = kEdgeCategory;
    self.physicsBody.contactTestBitMask = kExplodingBallCategory;
}

-(NSString*)returnBallWithRandomColor
{
    NSArray *balls = @[@"BallBlue",@"BallDarkBlue",@"BallGreen",@"BallLightBlue",@"BallLightGreen",@"BallLightOrange",@"BallLightPurple",@"BallMagenta",@"BallOrange",@"BallPastelRed",@"BallPink",@"BallPurple",@"BallRed",@"BallTeal",@"BallYellow"];
    
    return [balls objectAtIndex:arc4random_uniform(balls.count)];
}

-(int)getBallSpeed
{
    return kBallSpeed;
}

-(void)explode
{
    // Make the ball explode
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = kExplodingBallCategory;
    self.alpha = 0.5;
    self.name = @"explodingBall";
    SKAction *explode = [SKAction scaleTo:kSizeOfExplodingBall duration:.4];
    SKAction *wait = [SKAction waitForDuration:kExplodingBallWaitTime];
    SKAction *updatePhysicsBody = [SKAction runBlock:^{
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
        self.physicsBody.categoryBitMask = kExplodingBallCategory;
        self.physicsBody.dynamic = NO;
    }];
    SKAction *sequence = [SKAction sequence:@[explode,updatePhysicsBody,wait]];
    [self runAction:sequence completion:^{
        [self removeFromParent];
    }];
}
@end
