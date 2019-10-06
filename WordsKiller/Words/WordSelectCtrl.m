//
//  WordSelectCtrl.m
//  WordsKiller
//
//  Created by WENTAO XING on 2019/8/5.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "WordSelectCtrl.h"
#import "../model/WordSet.h"
#import "../model/Word.h"

@interface WordSelectCtrl ()
@property(nonatomic, strong) NSMutableSet<Word *> * saveSet;
@end

@implementation WordSelectCtrl

-(NSMutableSet *) saveSet
{
    if (!_saveSet) {
        _saveSet = [NSMutableSet setWithCapacity: 20];
    }
    return _saveSet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSFetchRequest * fq = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"(belongto = %@) OR (belongto.title = %@)", nil, self.wordset.title];
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"text" ascending:YES];
    
    fq.predicate = predicate;
    fq.sortDescriptors = @[sort];
    
    self.dataCtrl = [[NSFetchedResultsController alloc] initWithFetchRequest:fq managedObjectContext:self.dataCtx sectionNameKeyPath:nil cacheName:nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"_SELECT_WORD"];
    
    self.navigationItem.title = @"Select Words";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Ok" style:(UIBarButtonItemStyleDone) target:self action:@selector(save)];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_SELECT_WORD" forIndexPath:indexPath];
    
    Word * word = [self.dataCtrl objectAtIndexPath:indexPath];
    cell.textLabel.text = word.text;
    if (word.belongto != nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.saveSet addObject:word];
    } else if ([self.saveSet containsObject:word]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
         cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}

-(void) cancel
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) save
{
    NSError * err;
    [self.wordset setValue:[self.saveSet copy] forKey:@"words"];
    [self.dataCtx save: &err];
    if (err) {
        NSLog(@"error: %@", err);
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Word * word = [self.dataCtrl objectAtIndexPath:indexPath];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.saveSet containsObject:word]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.saveSet removeObject:word];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.saveSet addObject:word];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
