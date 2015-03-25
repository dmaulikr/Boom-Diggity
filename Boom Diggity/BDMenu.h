//
//  BDMenu.h
//  Boom Diggity
//
//  Created by Rob Norback on 3/22/15.
//  Copyright (c) 2015 Sidecar Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BDMenu : SKSpriteNode

- (instancetype)initWithScene:(SKScene*)gameScene;
-(void)hideMenu;
-(void)showMenu;

@end
