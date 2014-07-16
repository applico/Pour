//
//  UINavigationBar+myNav.m
//  FTT GUI
//
//  Created by Philip Xu on 7/3/14.
//  Copyright (c) 2014 ApplicoInc. All rights reserved.
//

#import "UINavigationBar+myNav.h"

@implementation UINavigationBar (myNav)
- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = CGSizeMake(320,60);
    return newSize;
}
@end
