//
//  PortfolioViewController.h
//  App
//
//  Created by Prem Nirmal on 4/22/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StocksProvider.h"

@interface PortfolioViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) StocksProvider *manager;

-(void) refresh;

@end

