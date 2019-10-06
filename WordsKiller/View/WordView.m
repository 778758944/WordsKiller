//
//  WordView.m
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/26.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "WordView.h"
#import "../Dictionary/Dictionary.h"

@interface WordView() <AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate>
@property(nonatomic, strong) AVAudioPlayer * player;
@property(nonatomic, strong) Dictionary * dict;
@property(nonatomic, strong) AVSpeechUtterance * utterance;
@property(nonatomic, strong) AVSpeechSynthesizer * speaker;
@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic, assign) NSInteger finishCount;
@property(nonatomic, assign) BOOL isExplaining;
@end

@implementation WordView

-(void) setExplanation:(NSDictionary *)explanation
{
    [_word setTitle:explanation[@"word"] forState:(UIControlStateNormal)];
    NSString * ps = [NSString stringWithFormat:@"/%@/", explanation[@"phoneticSpell"]];
    [_phoneticSpell setTitle:ps forState:(UIControlStateNormal)];
    _definition.text = explanation[@"definition"];
    _lexical.text = explanation[@"lexicalCategory"];
    _example.text = explanation[@"example"];
    _player = nil;
    _explanation = explanation;
}

-(AVSpeechSynthesizer *) speaker {
    if (!_speaker) {
        _speaker = [[AVSpeechSynthesizer alloc] init];
        _speaker.delegate = self;
    }
    return _speaker;
}

-(Dictionary *) dict
{
    if (!_dict) {
        _dict = [Dictionary shareDictionary];
    }
    return _dict;
}

-(UIButton *) word
{
    if (!_word) {
        _word = [UIButton buttonWithType:UIButtonTypeCustom];
        [_word setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_word.titleLabel setFont: [UIFont boldSystemFontOfSize:48]];
        _word.titleLabel.numberOfLines = 0;
        _word.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _word;
}

-(UILabel *) lexical
{
    if (!_lexical) {
        _lexical = [[UILabel alloc] init];
        _lexical.translatesAutoresizingMaskIntoConstraints = NO;
        [_lexical setFont: [UIFont systemFontOfSize: 20]];
    }
    
    return _lexical;
}

-(UILabel *) definition
{
    if (!_definition) {
        _definition = [[UILabel alloc] init];
        _definition.translatesAutoresizingMaskIntoConstraints = NO;
        _definition.numberOfLines = 0;
        [_definition setFont: [UIFont systemFontOfSize: 30]];
    }
    return _definition;
}

-(UILabel *) example
{
    if (!_example) {
        _example = [[UILabel alloc] init];
        _example.translatesAutoresizingMaskIntoConstraints = NO;
        _example.numberOfLines = 0;
        _example.textColor = [UIColor grayColor];
        [_example setFont: [UIFont systemFontOfSize:20]];
    }
    return _example;
    
}

-(UIButton *) phoneticSpell
{
    if (!_phoneticSpell) {
        _phoneticSpell = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneticSpell.translatesAutoresizingMaskIntoConstraints = NO;
        _phoneticSpell.titleLabel.numberOfLines = 0;
        [_phoneticSpell setTitleColor: [UIColor blackColor] forState:(UIControlStateNormal)];
        [_phoneticSpell.titleLabel setFont:[UIFont systemFontOfSize:30]];
        [_phoneticSpell addTarget:self action:@selector(pronunce) forControlEvents:(UIControlEventTouchDown)];
    }
    return _phoneticSpell;
}



-(instancetype) initWithWord: (NSDictionary *) explanation
{
    self = [super init];
    if (self) {
        _explanation = explanation;
        NSString * phonetic = [NSString stringWithFormat: @"/%@/", explanation[@"phoneticSpell"]];
        
        [self.word setTitle:explanation[@"word"] forState:(UIControlStateNormal)];
        self.lexical.text = explanation[@"lexicalCategory"];
        self.definition.text = explanation[@"definition"];
        self.example.text = explanation[@"example"];
        [self.phoneticSpell setTitle:phonetic forState:(UIControlStateNormal)];
        
        [self.container addSubview: self.word];
        [self.container addSubview: self.lexical];
        [self.container addSubview: self.definition];
        [self.container addSubview: self.example];
        [self.container addSubview: self.phoneticSpell];
        [self addSubview: self.container];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self style];
        [self layoutIfNeeded];
        CGRect rect = [self.container frame];
        self.contentSize = rect.size;
//        self.pronunceURL = explanation[@"pri"]
    }
    return self;
}

-(UIView *) container
{
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _container;
}

-(void) style
{
    CGRect size = [[UIScreen mainScreen] bounds];
    [self.container.widthAnchor constraintEqualToConstant: size.size.width].active = YES;
    [self.container.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.container.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    
    [self.word.leftAnchor constraintEqualToAnchor: self.container.leftAnchor constant: 10].active = YES;
    [self.word.topAnchor constraintEqualToAnchor:self.container.topAnchor constant:10].active = YES;
    
    [self.word.titleLabel.leftAnchor constraintEqualToAnchor:self.word.leftAnchor].active = YES;
    [self.word.titleLabel.rightAnchor constraintEqualToAnchor:self.container.rightAnchor constant: -10].active = YES;
    
    [self.phoneticSpell.leftAnchor constraintEqualToAnchor:self.word.leftAnchor].active = YES;
    [self.phoneticSpell.topAnchor constraintEqualToAnchor:self.word.bottomAnchor].active = YES;
    
    [self.phoneticSpell.titleLabel.leftAnchor constraintEqualToAnchor:self.phoneticSpell.leftAnchor].active = YES;
    [self.phoneticSpell.titleLabel.rightAnchor constraintEqualToAnchor:self.container.rightAnchor].active = YES;
    
    [self.lexical.leftAnchor constraintEqualToAnchor: self.word.leftAnchor].active = YES;
    [self.lexical.topAnchor constraintEqualToAnchor:self.phoneticSpell.bottomAnchor constant:10].active = YES;
    [self.lexical.rightAnchor constraintEqualToAnchor:self.container.rightAnchor constant:-10].active = YES;
    
    [self.definition.leftAnchor constraintEqualToAnchor:self.word.leftAnchor].active = YES;
    [self.definition.rightAnchor constraintEqualToAnchor: self.container.rightAnchor constant: -10].active = YES;
    [self.definition.topAnchor constraintEqualToAnchor: self.lexical.bottomAnchor constant:10].active = YES;
    
    [self.example.leftAnchor constraintEqualToAnchor:self.word.leftAnchor].active = YES;
    [self.example.rightAnchor constraintEqualToAnchor: self.container.rightAnchor constant: -10].active = YES;
    [self.example.topAnchor constraintEqualToAnchor: self.definition.bottomAnchor constant:20].active = YES;
    
    [self.container.bottomAnchor constraintEqualToAnchor:self.example.bottomAnchor].active = YES;
}

-(void) pronunce
{
    if (self.player && !self.player.playing) {
        [self.player play];
    } else if (!self.isLoading) {
        self.isLoading = YES;
        __block WordView * weakSelf = self;
        [self.dict pronounce:self.explanation[@"pronounceUrl"] completion:^(NSError * _Nonnull err, NSData * _Nonnull pdata) {
            weakSelf.isLoading = NO;
            if (!err) {
                NSError * err;
                weakSelf.player = [[AVAudioPlayer alloc] initWithData:pdata error:&err];
                weakSelf.player.delegate = weakSelf;
                if (!err) [self.player play];
            }
        }];
    }
}

-(void) spellWord
{
    if (self.isExplaining) return;
    self.isExplaining = YES;
    NSString * word = self.explanation[@"word"];
    AVSpeechUtterance * wordUt = [[AVSpeechUtterance alloc] initWithString:word];
    wordUt.postUtteranceDelay = 3.0;
    [self.speaker speakUtterance: wordUt];
    for (NSInteger i = 0; i < word.length; i++) {
        char c = [word characterAtIndex:i];
        AVSpeechUtterance * ut = [[AVSpeechUtterance alloc] initWithString:[NSString stringWithFormat: @"%c", c]];
        ut.rate = 0.45;
        [self.speaker speakUtterance: ut];
    }
    
    AVSpeechUtterance * wordUt2 = [[AVSpeechUtterance alloc] initWithString:word];
    [self.speaker speakUtterance:wordUt2];
    [self explainWord];
}

-(void) explainWord
{
    NSString * lexicalStr = [NSString stringWithFormat:@"lexicalCategory: %@", self.explanation[@"lexicalCategory"]];
    
    AVSpeechUtterance * lexical = [[AVSpeechUtterance alloc] initWithString:lexicalStr];
    
    [self.speaker speakUtterance:lexical];
    
    NSString * definitionStr = [NSString stringWithFormat: @"definition: %@", self.explanation[@"definition"]];
    
    AVSpeechUtterance * definition = [[AVSpeechUtterance alloc] initWithString:definitionStr];
    definition.rate = 0.38;
    
    [self.speaker speakUtterance:definition];
    
    NSString * exampleStr = [NSString stringWithFormat:@"example: %@", self.explanation[@"example"]];
    
    AVSpeechUtterance * example = [[AVSpeechUtterance alloc] initWithString:exampleStr];
    example.rate = 0.38;
    
    [self.speaker speakUtterance:example];
}

-(void) speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    self.finishCount++;
    NSLog(@"%ld", self.finishCount);
    NSString * word = self.explanation[@"word"];
    if (self.finishCount == word.length + 5) {
        self.finishCount = 0;
        self.isExplaining = NO;
        if (self.delegate != nil) {
            [self.delegate explainDidFinished: self.explanation];
        }
    }
}

-(void) play
{
    if (self.speaker.paused) {
        [self.speaker continueSpeaking];
    } else {
        [self spellWord];
    }
}

-(void) pause
{
    [self.speaker pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

-(void) stop
{
    if (!!self.speaker) {
        [self.speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
