//
//  ResultCtrl.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/19.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResultCtrl : UIViewController
@property(nonatomic, strong) NSDictionary * explanation;
@property(nonatomic, strong) NSManagedObjectContext * dataCtx;
@end

NS_ASSUME_NONNULL_END
