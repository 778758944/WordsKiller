//
//  CtrlView.m
//  WordsKiller
//
//  Created by WENTAO XING on 2019/8/6.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "CtrlView.h"

@implementation CtrlView

-(UIButton *) play
{
    if (!_play) {
        _play = [UIButton buttonWithType: UIButtonTypeSystem];
        [_play setTitle:@"Play" forState:(UIControlStateNormal)];
        _play.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _play;
}

-(UIButton *) prev
{
    if (!_prev) {
        _prev = [UIButton buttonWithType:UIButtonTypeSystem];
        [_prev setTitle:@"Prev" forState:(UIControlStateNormal)];
        _prev.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _prev;
}

-(UIButton *) next
{
    if (!_next) {
        _next = [UIButton buttonWithType:UIButtonTypeSystem];
        [_next setTitle:@"Next" forState:(UIControlStateNormal)];
        _next.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _next;
}

-(instancetype) init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview: self.play];
        [self addSubview: self.prev];
        [self addSubview: self.next];
    }
    [self style];
    return self;
}

-(void) style
{
    self.backgroundColor = [UIColor whiteColor];
    [self.play.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.play.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    [self.prev.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.prev.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15].active = YES;
    
    [self.next.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.next.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-15].active = YES;
    
}

@end
