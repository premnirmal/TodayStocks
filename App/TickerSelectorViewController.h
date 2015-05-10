//
//  TickerSelectorTableViewController.h
//  StocksWidget
//
//  Created by Prem on 5/8/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TickerSearchDelegate.h"

@interface TickerSelectorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,TickerSearchDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
