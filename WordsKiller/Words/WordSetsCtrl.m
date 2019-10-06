//
//  WordSetsCtrl.m
//  WordsKiller
//
//  Created by WENTAO XING on 2019/7/31.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "WordSetsCtrl.h"
#import "../model/WordSet+addon.h"
#import "../View/WordSetCell.h"
#import "./WordReview.h"

@interface WordSetsCtrl ()
@property(nonatomic, strong) NSMutableArray<WordSet *> * wordset;
@end

@implementation WordSetsCtrl

static NSString * const reuseIdentifier = @"wordsetcell";

-(NSArray<WordSet *> *) wordset
{
    if (!_wordset) {
        NSArray<WordSet *> * sets = [WordSet getWordSet: self.dataCtx];
        _wordset = [NSMutableArray arrayWithArray:sets];
    }
    return _wordset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(addSet)];
    self.navigationItem.title = @"Word Set";
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[WordSetCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return [self.wordset count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WordSetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSInteger index = [indexPath row];
    WordSet * set = [self.wordset objectAtIndex: index];
    cell.title.text = set.title;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark add word set
-(void) addSet
{
    __block UITextField * alertText;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Title" message:@"Input the title of the set" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"Ok" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // todo
        if (alertText) {
            WordSet * n_set = [WordSet addSet:alertText.text inContext:self.dataCtx];
            if (n_set) {
                [self.wordset addObject: n_set];
                NSInteger last_index = [self.wordset count] - 1;
                NSIndexPath * last_path = [NSIndexPath indexPathForRow:last_index inSection:0];
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView insertItemsAtIndexPaths:@[last_path]];
                } completion:nil];
            }
            
        }
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion: nil];
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        alertText = textField;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
//    [WordSet addSet:@"First Words" inContext:self.dataCtx];
}

-(BOOL) collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL) collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([NSStringFromSelector(action) isEqual: @"cut:"]) {
        return YES;
    }
    return NO;
}

-(void) collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    NSLog(@"%@", indexPath);
    NSInteger index = indexPath.row;
    NSError * err;
    [self.dataCtx deleteObject: self.wordset[index]];
    [self.dataCtx save: &err];
    [self.wordset removeObjectAtIndex:index];
    [collectionView performBatchUpdates:^{
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:nil];
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // todo
    NSInteger index = indexPath.row;
    WordSet * ws = [self.wordset objectAtIndex:index];
    WordReview * wr = [[WordReview alloc] init];
    wr.wordset = ws;
    wr.dataCtx = self.dataCtx;
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:wr animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

@end
