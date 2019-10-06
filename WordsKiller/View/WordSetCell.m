//
//  WordSetCell.m
//  WordsKiller
//
//  Created by WENTAO XING on 2019/8/1.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "WordSetCell.h"

@implementation WordSetCell
-(UILabel *) title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont systemFontOfSize:15];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.numberOfLines = 3;
        _title.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _title;
}
-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self.contentView addSubview:self.title];
    [self style];
    return self;
}

-(void) style
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 20;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.title.centerXAnchor constraintEqualToAnchor: self.contentView.centerXAnchor].active = YES;
    [self.title.centerYAnchor constraintEqualToAnchor: self.contentView.centerYAnchor].active = YES;
    [self.title.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;
}

@end
