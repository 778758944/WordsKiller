//
//  WordSet+addon.m
//  WordsKiller
//
//  Created by WENTAO XING on 2019/7/29.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "WordSet+addon.h"

@implementation WordSet (addon)
+(WordSet *) addSet: (NSString *) title inContext: (NSManagedObjectContext *) ctx
{
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName: @"WordSet"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"title=%@", title];
    NSSortDescriptor * sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[sortDesc];
    fetchRequest.fetchLimit = 1;
    NSError * fetchErr;
    
    NSArray<WordSet *> * wordsets = [ctx executeFetchRequest:fetchRequest error: &fetchErr];
    
    if (fetchErr) {
        NSLog(@"fetch error: %@", fetchErr);
        return nil;
    } else if ([wordsets count] == 1) {
        return [wordsets objectAtIndex:0];
    } else {
        WordSet * newSet = [NSEntityDescription insertNewObjectForEntityForName:@"WordSet" inManagedObjectContext:ctx];
        
        newSet.title = title;
        NSError * saveErr;
        [ctx save: &saveErr];
        return newSet;
    }
}

+(NSArray<WordSet *> *) getWordSet: (NSManagedObjectContext *) ctx
{
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName: @"WordSet"];
    NSError * fetchErr;
    
    NSArray<WordSet *> * res = [ctx executeFetchRequest:fetchRequest error: &fetchErr];
    if (fetchErr) {
        return nil;
    }
    
    return res;
}
@end
