//
//  WordView.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/26.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "./WordViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface WordView : UIScrollView
@property(nonatomic, strong) UIButton * word;
@property(nonatomic, strong) UILabel * definition;
@property(nonatomic, strong) UILabel * lexical;
@property(nonatomic, strong) UILabel * example;
@property(nonatomic, strong) UIButton * phoneticSpell;
@property(nonatomic, strong) UIView * container;
@property(nonatomic, strong) NSDictionary * explanation;
@property(nonatomic, weak) id<WordViewDelegate> delegate;
-(instancetype) initWithWord: (NSDictionary *) explanation;
-(void) pause;
-(void) play;
-(void) stop;
@end

NS_ASSUME_NONNULL_END
