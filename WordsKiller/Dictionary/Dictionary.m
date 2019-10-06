//
//  Dictionary.m
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/17.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "Dictionary.h"
#define APP_ID @"a77ea71b"
#define APP_KEY @"27c7b744530d00abde181c62eb6aa538"
#define FORMATURL @"https://od-api.oxforddictionaries.com/api/v2/entries/%@/%@?fields=%@&strictMatch=%@"
#define PRONOUNCEURL @"http://audio.oxforddictionaries.com/en/mp3/%@_gb_1.mp3"

NSErrorDomain const NSUserDictionaryDomain = @"NSUserDictionaryDomain";

static Dictionary * _dict = nil;

@interface Dictionary()
@property(nonatomic, strong) NSURLSession * session;
@end

@implementation Dictionary

+(instancetype) shareDictionary
{
    if (!_dict) {
        static dispatch_once_t token;
        dispatch_once(&token, ^{
            _dict = [[super allocWithZone: NULL] init];
        });
    }
    return _dict;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [Dictionary shareDictionary];
}

-(id) copyWithZone: (struct _NSZone *)zone
{
    return [Dictionary shareDictionary];
}

-(NSString *) language
{
    if (!_language) {
        _language = @"en-gb";
    }
    return _language;
}

-(NSString *) fields
{
    if (!_fields) {
        _fields = @"definitions,pronunciations,examples";
    }
    return _fields;
}

-(NSString *) strictMatch
{
    if (!_strictMatch) {
        _strictMatch = @"false";
    }
    return _strictMatch;
}

-(NSURLSession *) session
{
    if (!_session) {
        _session = [NSURLSession sharedSession];
    }
    
    return _session;
}


-(void) search: (NSString *) word completion:(void(^)(NSError * err, NSDictionary * res))handler {
    NSString * str = [NSString stringWithFormat: FORMATURL, self.language, word, self.fields, self.strictMatch];
    
    NSURL * url = [NSURL URLWithString: str];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod:@"GET"];
    [request setValue: APP_ID forHTTPHeaderField: @"app_id"];
    [request setValue: APP_KEY forHTTPHeaderField: @"app_key"];
    
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            handler(error, nil);
        } else {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse * res = (NSHTTPURLResponse *) response;
                if (res.statusCode == 200) {
                    NSError * err;
                    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error: &err];
                    if (err) {
                        handler(err, nil);
                    } else {
                        NSDictionary * info = [self getKeyInfo: json];
                        handler(nil, info);
                    }
                } else {
                    NSError * err = [NSError errorWithDomain:NSUserDictionaryDomain code:res.statusCode userInfo:nil];
                    handler(err, nil);
                }
            } else {
                NSError * err = [NSError errorWithDomain:NSUserDictionaryDomain code:404 userInfo:nil];
                handler(err, nil);
            }
        }
    }];
    
    [task resume];
}

-(NSDictionary *) getKeyInfo: (NSDictionary *) info
{
    NSDictionary * entry = info[@"results"][0][@"lexicalEntries"][0];
    NSLog(@"entry: %@", entry);
    NSString * lexicalCategory = entry[@"lexicalCategory"][@"text"];
    NSString * pronunciation = entry[@"pronunciations"][0][@"audioFile"];
    NSString * spell = entry[@"pronunciations"][0][@"phoneticSpelling"];
    
    // definition may lost
    NSArray * definitions = entry[@"entries"];
    NSString * definition = @"";
    NSString * example = @"";
    
    if (definitions != nil) {
        NSDictionary * defineEntry = entry[@"entries"][0][@"senses"][0];
        definition = defineEntry[@"definitions"][0];
        example = @"";
        if (defineEntry[@"examples"]) {
            example = defineEntry[@"examples"][0][@"text"];
        }
    }
    
    return @{
             @"lexicalCategory": lexicalCategory,
             @"pronounceUrl": pronunciation,
             @"definition": definition,
             @"example": example,
             @"word": entry[@"text"],
             @"phoneticSpell": spell
             };
}

-(void) pronounce: (NSString *) pronounceUrl completion: (void(^)(NSError * err, NSData * pdata)) handler
{
//    NSString * p_str = [NSString stringWithFormat: PRONOUNCEURL, word];
    NSLog(@"pronounceUrl: %@", pronounceUrl);
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: pronounceUrl]];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error: %@", error);
            handler(error, nil);
        } else {
            handler(nil, data);
        }
    }];
    [task resume];
}
@end
