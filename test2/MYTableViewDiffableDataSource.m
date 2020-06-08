//
//  MYTableViewDiffableDataSource.m
//  test2
//
//  Created by Mac on 2020/6/8.
//  Copyright © 2020 test. All rights reserved.
//

#import "MYTableViewDiffableDataSource.h"

@implementation MYTableViewDiffableDataSource


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        id item = [self itemIdentifierForIndexPath:indexPath];
        
        //这里注意一下，每次调用self.snapshot都会创建新的对象⚠️⚠️⚠️
        NSDiffableDataSourceSnapshot *snapshot = self.snapshot;
        NSDiffableDataSourceSnapshot *snapshot1 = self.snapshot;   //测试⚠️
        NSDiffableDataSourceSnapshot *snapshot2 = self.snapshot;   //测试⚠️
        NSDiffableDataSourceSnapshot *snapshot3 = self.snapshot;   //测试⚠️
        
        //删除的时候不用指定Section，因为每一个item都是唯一的
        [snapshot deleteItemsWithIdentifiers:@[item]];

        [self applySnapshot:snapshot animatingDifferences:YES completion:^{
            //
        }];
        
        //不可以再使用tableview的方法删除⚠️⚠️⚠️
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%ld",section];
}

@end
