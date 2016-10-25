//
//  OPAYMockDataTableViewController.m
//
//  Created by sachin on 23/02/15.
//  Copyright (c) 2015 opus. All rights reserved.
//
#import <Availability.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#import "PaySafeMockDataTableViewController.h"

@interface PaySafeMockDataTableViewController()
@property(nonatomic)id<PaySafeMockDataStore>store;
@end

@interface OPAYMockDataTableViewCell : UITableViewCell
@end

@implementation OPAYMockDataTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}
@end

@implementation PaySafeMockDataTableViewController

- (instancetype)initWithStore:(id<PaySafeMockDataStore>)store {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _store = store;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[OPAYMockDataTableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.store.allItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    id item = self.store.allItems[indexPath.row];
    NSArray *descriptions = [self.store descriptionsForItem:item];
    cell.textLabel.text = descriptions[0];
    cell.detailTextLabel.text = descriptions[1];
    cell.accessoryType = ([item isEqual:self.store.selectedItem]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.store.selectedItem = self.store.allItems[indexPath.row];
    [self.tableView reloadData];
    if (self.callback) {
        self.callback(self.store.selectedItem);
    }
}

@end
#endif