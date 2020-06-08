//
//  MasterViewController.m
//  test2
//
//  Created by Mac on 2020/6/8.
//  Copyright © 2020 test. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MYTableViewDiffableDataSource.h"

@interface MasterViewController ()

@property NSMutableArray *objects;

@property (nonatomic) MYTableViewDiffableDataSource *datasource;   //创建自己的类以便实现更多的UITableViewDataSource代理方法

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //指定新的代理
    self.tableView.dataSource = self.datasource;
    
}

- (UITableViewDiffableDataSource *)datasource {
    
    if (!_datasource) {
        _datasource = [[MYTableViewDiffableDataSource alloc] initWithTableView:self.tableView cellProvider:^UITableViewCell * _Nullable(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, id _Nonnull date) {
            //
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

            NSDate *object = date;
            cell.textLabel.text = [object description];
            return cell;
            
        }];
    }
    return _datasource;
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)insertNewObject:(id)sender {
    
    NSDiffableDataSourceSnapshot *snapshot = self.datasource.snapshot;
    
    //不可以每次都创建新的snapshot⚠️，否则数据都是新的！
    //NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
    
    //数据太多了清空一下
    if (snapshot.numberOfItems >= 10) {
        [snapshot deleteAllItems];
        [self.datasource applySnapshot:snapshot animatingDifferences:YES completion:^{
        }];
        return;
    }
    
    //必须先创建Section才可以插入数据
    if(snapshot.numberOfSections==0)
    {
        [snapshot appendSectionsWithIdentifiers:@[@"1"]];   //SectionIdentifierType不可以重复⚠️
    }else
    {
        if (snapshot.numberOfItems == 5) {
            [snapshot appendSectionsWithIdentifiers:@[@"2"]];  //根据需求添加更多的Section
        }
    }
    
    //往Section中添加数据，默认添加到最后一个Section中
    [snapshot appendItemsWithIdentifiers:@[[NSDate date]]];  //ItemIdentifierType也不可以重复⚠️
    
    //往指定Section中添加数据
    //[snapshot appendItemsWithIdentifiers:@[[NSDate date]] intoSectionWithIdentifier:@"2"];
    
    [self.datasource applySnapshot:snapshot animatingDifferences:YES completion:^{
        //
    }];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = [self.datasource itemIdentifierForIndexPath:indexPath];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.detailItem = object;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        self.detailViewController = controller;
    }
}

//⚠️不可以再实现以下方法⚠️
//#pragma mark - Table View
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.objects.count;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//
//    NSDate *object = self.objects[indexPath.row];
//    cell.textLabel.text = [object description];
//    return cell;
//}


@end
