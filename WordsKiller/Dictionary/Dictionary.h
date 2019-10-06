//
//  Dictionary.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/17.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dictionary : NSObject
+(instancetype) shareDictionary;
@property(nonatomic, strong) NSString * language;
@property(nonatomic, strong) NSString * fields;
@property(nonatomic, strong) NSString * strictMatch;
-(void) search: (NSString *) word completion: (void(^)(NSError * err, NSDictionary * res)) handler;
-(void) pronounce: (NSString *) pronounceUrl completion: (void(^)(NSError * err, NSData * pdata)) handler;
@end

NS_ASSUME_NONNULL_END
