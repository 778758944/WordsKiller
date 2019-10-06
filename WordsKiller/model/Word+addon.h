//
//  Word+addon.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/23.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "Word.h"

NS_ASSUME_NONNULL_BEGIN

@interface Word (addon)
+(BOOL) isExist: (NSString *) text inContext: (NSManagedObjectContext *) ctx;
+(Word *) addWord: (NSDictionary *) dic inContext: (NSManagedObjectContext *) ctx;
@end

NS_ASSUME_NONNULL_END
