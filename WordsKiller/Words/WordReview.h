//
//  WordReview.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/8/2.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WordSet;

NS_ASSUME_NONNULL_BEGIN

@interface WordReview : UIViewController
@property(nonatomic, strong) WordSet * wordset;
@property(nonatomic, strong) NSManagedObjectContext * dataCtx;
@end

NS_ASSUME_NONNULL_END
