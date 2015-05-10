//
//  TickerSelectorTableViewController.m
//  StocksWidget
//
//  Created by Prem on 5/8/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import "TickerSelectorViewController.h"
#import "TickerSearchRequest.h"
#import "TickerSearchDelegate.h"
#import "Portfolio.h"
#import "StocksProvider.h"

@interface TickerSelectorViewController ()

@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation TickerSelectorViewController

@synthesize array;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [[NSMutableArray alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - TickerSearch delegate

-(void) retrievedTickersFromSearch:(NSArray *)tickers :(NSError*) error {
    if(error) {
        NSLog(@"Error %@", error);
        NSString *reason = [error localizedDescription];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:reason
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [array removeAllObjects];
        [array addObjectsFromArray:tickers];
        NSLog(@"%@", @"calling reloaddata");
        [self.tableView reloadData];
    }
}

#pragma mark - SearchBar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length == 0) {
        [array removeAllObjects];
        [self.tableView reloadData];
    } else {
        [TickerSearchRequest searchForTicker:searchText :self];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    [array removeAllObjects];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Ticker *ticker = [array objectAtIndex:indexPath.row];
    NSString *desc = [NSString stringWithFormat:@"%@ - %@",ticker.symbol, ticker.name];
    NSLog(@"desc: %@",desc);
    [cell.textLabel setText:desc];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchBar setText:@""];
    Ticker *ticker = [array objectAtIndex:indexPath.row];
    if([ticker.symbol containsString:@"^"]) {
        [Portfolio removeTicker:ticker.symbol];
        NSString *message = [NSString stringWithFormat:@"%@ is not available in the market, please select another stock",ticker.symbol];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        if([Portfolio containsTicker:ticker.symbol]) {
            NSString *message = [NSString stringWithFormat:@"%@ is already in your portfolio.",ticker.symbol];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            [Portfolio addTicker:ticker.symbol];
            [[StocksProvider sharedManager] fetchStocks:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
