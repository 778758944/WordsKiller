//
//  WordSelectCtrl.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/8/5.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "CoreDataTableViewCtrl.h"
@class WordSet;

NS_ASSUME_NONNULL_BEGIN

@interface WordSelectCtrl : CoreDataTableViewCtrl
@property(nonatomic, strong) NSManagedObjectContext * dataCtx;
@property(nonatomic, strong) WordSet * wordset;
@end

NS_ASSUME_NONNULL_END
