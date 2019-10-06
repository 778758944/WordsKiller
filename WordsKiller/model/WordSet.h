//
//  WordSet.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/7/29.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import <CoreData/CoreData.h>
@class Word;

NS_ASSUME_NONNULL_BEGIN

@interface WordSet : NSManagedObject
@property(nonatomic, strong) NSString * title;
@property(nonatomic, strong) NSSet<Word *> * words;
@end

NS_ASSUME_NONNULL_END
