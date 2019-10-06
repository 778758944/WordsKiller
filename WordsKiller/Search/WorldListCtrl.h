//
//  WorldListCtrl.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/24.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "CoreDataTableViewCtrl.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorldListCtrl : CoreDataTableViewCtrl
@property(nonatomic, strong) NSManagedObjectContext * dataCtx;
@end

NS_ASSUME_NONNULL_END
