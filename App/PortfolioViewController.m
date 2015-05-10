//
//  PortfolioViewController.m
//  App
//
//  Created by Prem Nirmal on 4/22/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import "PortfolioViewController.h"
#import "Portfolio.h"
#import "Stock.h"
#import "StocksProvider.h"
#import "PortfolioCell.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PortfolioViewController ()<StocksProviderDelegate>

@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation PortfolioViewController

static NSString * const CellIdentifier = @"CELL";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.manager = [StocksProvider sharedManager];
    [self.manager registerStocksProviderDelegate:self];
    NSArray *stocks = [Portfolio getStocks];
    if(!stocks || stocks.count == 0) {
        [self refresh];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"PortfolioCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:CellIdentifier];
    self.array = [[NSMutableArray alloc] initWithArray:[Portfolio getStocks]];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

-(void) refresh {
    [self.manager fetchStocks:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.manager unregisterStocksProviderDelegate:self];
}


#pragma Table View Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [Portfolio lastUpdated];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.backgroundColor = [UIColor whiteColor];
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont systemFontOfSize:12];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentRight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PortfolioCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Stock *stock = [self.array objectAtIndex:indexPath.row];
    UIColor *color;
    if(stock.Change < 0.0) {
        color = UIColorFromRGB(0xE65B4A);
    } else {
        color = UIColorFromRGB(0x19D886);
    }
    
    cell.changeLabel.backgroundColor = color;
    [cell.changeLabel setCornerRadius:3];
    [cell.symbolLabel setText:stock.symbol];
    [cell.valueLabel setText:[NSString stringWithFormat:@"$%.2f",stock.LastTradePriceOnly]];
    [cell.changeLabel setText:stock.ChangeinPercent];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Stock *stock = [_array objectAtIndex:indexPath.row];
        [Portfolio removeTicker:stock.symbol];
        [Portfolio removeStock:stock];
        [_array removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else {
        NSLog(@"Unhandled editing style! %ld", (long)editingStyle);
    }
}

#pragma mark - StocksProviderDelegate

- (void)didReceiveStocks:(NSArray *)stocklist {
    [self.array removeAllObjects];
    [self.array addObjectsFromArray:stocklist];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)fetchingStocksFailedWithError:(NSError *)error {
    [self.refreshControl endRefreshing];
    NSLog(@"Error %@", error);
    NSString *reason = [error localizedDescription];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:reason
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
