//
//  WordSet+addon.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/7/29.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "WordSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface WordSet (addon)
+(WordSet *) addSet: (NSString *) title inContext: (NSManagedObjectContext *) ctx;
+(NSArray<WordSet *> *) getWordSet: (NSManagedObjectContext *) ctx;
@end

NS_ASSUME_NONNULL_END
