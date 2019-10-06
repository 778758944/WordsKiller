//
//  CoreDataTableViewCtrl.h
//  WordsKiller
//
//  Created by WENTAO XING on 2019/4/24.
//  Copyright © 2019 WENTAO XING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataTableViewCtrl : UITableViewController<NSFetchedResultsControllerDelegate>
@property(nonatomic, strong) NSFetchedResultsController * dataCtrl;
-(void) fetchData;
@end

NS_ASSUME_NONNULL_END
