//
//  WordReview.m
//  WordsKiller
//
//  Created by WENTAO XING on 2019/8/2.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "WordReview.h"
#import "./WordSelectCtrl.h"
#import "../model/WordSet.h"
#import "../model/Word.h"
#import "../View/WordView.h"
#import "../View/WordViewDelegate.h"
#import "../View/CtrlView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface WordReview ()<WordViewDelegate>
@property(nonatomic, strong) NSArray<Word *> * words;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, strong) WordView * wordview;
@property(nonatomic, strong) CtrlView * ctrlView;
@property(nonatomic, assign) BOOL isPlaying;
@end

@implementation WordReview

-(CtrlView *) ctrlView
{
    if (!_ctrlView) {
        _ctrlView = [[CtrlView alloc] init];
    }
    
    return _ctrlView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 0;
    self.isPlaying = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.wordset.title;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(addWord)];
    [self setRemoteCtrl];
    if (self.wordset.words.count > 0) {
        self.words = [self.wordset.words allObjects];
        Word * word = [self.words objectAtIndex:0];
        self.wordview = [self showWord:word];
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (!!self.wordview) [self.wordview stop];
}

-(WordView *) showWord: (Word *) word
{
    [self updateCenterInfo];
    NSDictionary * explaination = @{
                                    @"word": word.text,
                                    @"definition": word.definition,
                                    @"example": word.example,
                                    @"lexicalCategory": word.lexicalCategory,
                                    @"pronounceUrl": word.pronounceUrl,
                                    @"phoneticSpell": word.phoneticSpell,
                                    };
    WordView * wordView = [[WordView alloc] initWithWord: explaination];
    wordView.delegate = self;
    [self.view addSubview: wordView];
    [self.view addSubview: self.ctrlView];
    [self.ctrlView.heightAnchor constraintEqualToConstant:50].active = YES;
    [self.ctrlView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor].active = YES;
    [self.ctrlView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor].active = YES;
    [self.ctrlView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [wordView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [wordView.bottomAnchor constraintEqualToAnchor: self.ctrlView.topAnchor].active = YES;
    [wordView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [wordView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.ctrlView.play addTarget:self action:@selector(play) forControlEvents:(UIControlEventTouchDown)];
    
    return wordView;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) addWord
{
    //todo
    WordSelectCtrl * wordSeclect = [[WordSelectCtrl alloc] init];
    wordSeclect.wordset = self.wordset;
    wordSeclect.dataCtx = self.dataCtx;
    
    UINavigationController * addWordNav = [[UINavigationController alloc] initWithRootViewController:wordSeclect];
    
    
    [self presentViewController:addWordNav animated:YES completion:nil];
}



-(void) explainDidFinished:(Word *)word
{
    self.index++;
    if (self.index == [self.words count]) {
        self.index = 0;
    }
    
    Word * nextWord = [self.words objectAtIndex:self.index];
    NSDictionary * explaination = @{
                                    @"word": nextWord.text,
                                    @"definition": nextWord.definition,
                                    @"example": nextWord.example,
                                    @"lexicalCategory": nextWord.lexicalCategory,
                                    @"pronounceUrl": nextWord.pronounceUrl,
                                    @"phoneticSpell": nextWord.phoneticSpell,
                                    };
    self.wordview.explanation = explaination;
    [NSThread sleepForTimeInterval:3];
    [self updateCenterInfo];
    [self.wordview play];
    
}

-(void) play
{
    if (self.isPlaying) {
        [self.ctrlView.play setTitle:@"Play" forState:(UIControlStateNormal)];
        [self.wordview pause];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    } else {
        [self.ctrlView.play setTitle:@"Pause" forState:(UIControlStateNormal)];
        [self.wordview play];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    self.isPlaying = !self.isPlaying;
}

-(void) setRemoteCtrl
{
    MPRemoteCommandCenter * commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.playCommand addTarget:self action:@selector(play)];
    [commandCenter.pauseCommand addTarget:self action:@selector(play)];
}

-(void) updateCenterInfo
{
    Word * word = [self.words objectAtIndex:self.index];
    NSDictionary * info = @{
                            MPMediaItemPropertyTitle: word.text,
                        };
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
}


@end
