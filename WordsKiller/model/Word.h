//
//  Word.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/23.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import <CoreData/CoreData.h>
@class WordSet;

NS_ASSUME_NONNULL_BEGIN

@interface Word : NSManagedObject
@property(nonatomic, strong) NSString * text;
@property(nonatomic, strong) NSString * definition;
@property(nonatomic, strong) NSString * example;
@property(nonatomic, strong) NSString * lexicalCategory;
@property(nonatomic, strong) NSString * pronounceUrl;
@property(nonatomic, strong) NSString * phoneticSpell;
@property(nonatomic, strong) WordSet * belongto;
@end

NS_ASSUME_NONNULL_END
