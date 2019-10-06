//
//  WorldListCtrl.m
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/24.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import "WorldListCtrl.h"
#import "../Dictionary/Dictionary.h"
#import "ResultCtrl.h"
#import "SearchResult.h"
#import "../model/Word.h"

@interface WorldListCtrl ()<UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>
@property(nonatomic, strong) UISearchController * searchBarCtrl;
@property(nonatomic, strong) SearchResult * searchResult;
@property(nonatomic, strong) Dictionary * dict;
@end

@implementation WorldListCtrl

-(SearchResult *) searchResult
{
    if (!_searchResult) {
        _searchResult = [[SearchResult alloc] init];
    }
    
    return _searchResult;
}

-(UISearchController *) searchBarCtrl
{
    if (!_searchBarCtrl) {
        _searchBarCtrl = [[UISearchController alloc] initWithSearchResultsController: nil];
        _searchBarCtrl.searchResultsUpdater = self;
        
        _searchBarCtrl.delegate = self;
        _searchBarCtrl.dimsBackgroundDuringPresentation = NO;
        _searchBarCtrl.searchBar.delegate = self;
    }
    
    return _searchBarCtrl;
}

-(Dictionary *) dict
{
    if (!_dict) {
        _dict = [Dictionary shareDictionary];
    }
    
    return _dict;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.searchController = self.searchBarCtrl;
    self.definesPresentationContext = YES;
    
    NSFetchRequest * wordReq = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"text" ascending:YES];
    wordReq.sortDescriptors = @[sort];
    
    self.dataCtrl = [[NSFetchedResultsController alloc] initWithFetchRequest:wordReq managedObjectContext:self.dataCtx sectionNameKeyPath:nil cacheName:nil];
}

#pragma make search bar delegate
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString * word = searchBar.text;
    [self.dict search: word completion:^(NSError * err, NSDictionary * res) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (err) {
                // todo
            } else {
                ResultCtrl * result = [[ResultCtrl alloc] init];
                result.explanation = res;
                result.dataCtx = self.dataCtx;
                [self pushToCtrl:result];
            }
        });
    }];
}

-(void) pushToCtrl: (UIViewController *) ctrl
{
    [self setHidesBottomBarWhenPushed: YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [self setHidesBottomBarWhenPushed: NO];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier: @"wordReuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"wordReuse"];
    }
    Word * word = [self.dataCtrl objectAtIndexPath:indexPath];
    cell.textLabel.text = word.text;
    cell.detailTextLabel.text = word.definition;
    cell.editing = YES;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Word * word = [self.dataCtrl objectAtIndexPath:indexPath];
    NSDictionary * explaination = @{
                               @"word": word.text,
                               @"definition": word.definition,
                               @"example": word.example,
                               @"lexicalCategory": word.lexicalCategory,
                               @"pronounceUrl": word.pronounceUrl,
                               @"phoneticSpell": word.phoneticSpell,
                               };
    
    ResultCtrl * result = [[ResultCtrl alloc] init];
    result.explanation = explaination;
    result.dataCtx = self.dataCtx;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushToCtrl:result];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    CGSize size = CGSizeMake(100, 100);
    return size;
}

-(void) updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //
}

#pragma make delete word
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction * deleteBtn = [UITableViewRowAction rowActionWithStyle:
                        UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                            Word * word = [self.dataCtrl objectAtIndexPath:indexPath];
                            [self.dataCtx deleteObject: word];
                            [self.dataCtx save:nil];
    }];
    
    return @[deleteBtn];
}


@end
