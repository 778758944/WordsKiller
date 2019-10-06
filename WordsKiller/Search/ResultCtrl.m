//
//  ResultCtrl.m
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/19.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "ResultCtrl.h"
#import "../model/Word+addon.h"
#import "../Dictionary/Dictionary.h"
#import "../View/WordView.h"
#import "../View/WordViewDelegate.h"

@interface ResultCtrl () <AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate, WordViewDelegate>
@property(nonatomic, strong) Dictionary * dict;
@property(nonatomic, strong) AVAudioPlayer * player;
@property(nonatomic, strong) AVSpeechSynthesizer * speaker;
@property(nonatomic, strong) WordView * wordview;
@property(nonatomic) BOOL isReading;
@end

@implementation ResultCtrl

-(Dictionary *) dict
{
    if (!_dict) {
        _dict = [Dictionary shareDictionary];
    }
    
    return _dict;
}

-(AVSpeechSynthesizer *) speaker
{
    if (!_speaker) {
        _speaker = [[AVSpeechSynthesizer alloc] init];
        _speaker.delegate = self;
        [_speaker stopSpeakingAtBoundary:(AVSpeechBoundaryImmediate)];
    }
    return _speaker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    WordView * wordView = [[WordView alloc] initWithWord:self.explanation];
    wordView.delegate = self;
    
    
    [self.view addSubview:wordView];
    [wordView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [wordView.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor].active = YES;
    [wordView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [wordView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    NSString * text = self.explanation[@"word"];
    if (![Word isExist:text inContext:self.dataCtx]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:(UIBarButtonItemStylePlain) target:self action:@selector(save)];
    }
    // Do any additional setup after loading the view.
}

-(void) pronunciation
{
    __block ResultCtrl * weakSelf = self;
    [self.dict pronounce:self.explanation[@"pronounceUrl"] completion:^(NSError *  err, NSData * pdata) {
        if (err) {
            //
        } else {
            NSError * auerr;
            weakSelf.player = [[AVAudioPlayer alloc] initWithData:pdata error: &auerr];
            if (auerr) {
                NSLog(@"errpr: %@", auerr);
            } else {
                [weakSelf.player setDelegate: weakSelf];
                [weakSelf.player play];
            }
        }
    }];
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"play: %d", flag);
    if (flag && self.isReading) {
        flag = NO;
        NSString * word = self.explanation[@"word"];
        NSUInteger len = [word length];
        NSMutableArray * wordArr = [[NSMutableArray alloc] initWithCapacity: len];
        for (NSUInteger i = 0; i < len; i++) {
            [wordArr addObject: [NSString stringWithFormat:@"%c", [word characterAtIndex:i]]];
        }
        
        NSString * spellWord = [wordArr componentsJoinedByString:@"--"];
        NSString * explain = [NSString stringWithFormat: @"%@, -lexical: %@, -definition: %@, -example: %@", spellWord, self.explanation[@"lexicalCategory"], self.explanation[@"definition"], self.explanation[@"example"]];
        AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc] initWithString: explain];
        [utterance setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"]];
        [utterance setRate: 0.38];
        [self.speaker speakUtterance: utterance];
    }
}

-(void) readWord
{
    self.isReading = YES;
    [self pronunciation];
}

-(void) spell
{
    NSString * word = self.explanation[@"word"];
    NSUInteger len = [word length];
    NSMutableArray * wordArr = [[NSMutableArray alloc] initWithCapacity: len];
    for (NSUInteger i = 0; i < len; i++) {
        [wordArr addObject: [NSString stringWithFormat:@"%c", [word characterAtIndex:i]]];
    }
    
    NSString * spellWord = [wordArr componentsJoinedByString:@" "];
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc] initWithString: spellWord];
    [utterance setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"]];
    [utterance setRate: 0.3];
    [self.speaker speakUtterance:utterance];
}

-(void) save
{
     [Word addWord: self.explanation inContext: self.dataCtx];
}

#pragma make utterance finish
-(void) speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"finish");
}

#pragma make end explation
-(void) explainDidFinished:(NSDictionary *)word
{
    NSLog(@"word: %@", word);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
