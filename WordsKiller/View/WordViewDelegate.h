//
//  WordViewDelegate.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/7/29.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Word;

NS_ASSUME_NONNULL_BEGIN

@protocol WordViewDelegate <NSObject>
@required
-(void) explainDidFinished: (NSDictionary *) word;

@end

NS_ASSUME_NONNULL_END
