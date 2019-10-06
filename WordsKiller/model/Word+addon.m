//
//  Word+addon.m
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/23.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "Word+addon.h"

@implementation Word (addon)
+(BOOL) isExist: (NSString *) text inContext: (NSManagedObjectContext *) ctx
{
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"text=%@", text];
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"text" ascending:YES];
    fetch.predicate = predicate;
    fetch.sortDescriptors = @[sort];
    fetch.fetchLimit = 1;
    NSError * fetchErr;
    
    NSArray<Word *> * words = [ctx executeFetchRequest:fetch error:&fetchErr];
    
    if (words && [words count] == 1) {
        return YES;
    }
    
    return NO;
}
+(Word *) addWord: (NSDictionary *) dic inContext: (NSManagedObjectContext *) ctx
{
    NSString * text = (NSString *) dic[@"word"];
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"text=%@", text];
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"text" ascending:YES];
    fetch.predicate = predicate;
    fetch.sortDescriptors = @[sort];
    fetch.fetchLimit = 1;
    NSError * fetchErr;
    
    NSArray<Word *> * words = [ctx executeFetchRequest:fetch error:&fetchErr];
    
    if (fetchErr) {
        NSLog(@"error: %@", fetchErr);
        return nil;
    } else if ([words count] == 1) {
        Word * w = [words objectAtIndex:0];
        NSLog(@"word: %@", w.text);
        return [words objectAtIndex: 0];
    } else {
        Word * newWord = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:ctx];
        newWord.definition = (NSString *) dic[@"definition"];
        newWord.text = (NSString *) dic[@"word"];
        newWord.example = (NSString *) dic[@"example"];
        newWord.lexicalCategory = (NSString *) dic[@"lexicalCategory"];
        newWord.pronounceUrl = (NSString *) dic[@"pronounceUrl"];
        newWord.phoneticSpell = (NSString *) dic[@"phoneticSpell"];
        
        NSError * saveErr;
        [ctx save: &saveErr];
        
        if (saveErr) {
            NSLog(@"error: %@", saveErr);
        }
        
        return newWord;
    }
}
@end
