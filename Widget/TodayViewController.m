//
//  TodayViewController.m
//  Widget
//
//  Created by Prem Nirmal on 4/22/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <NotificationCenter/NotificationCenter.h>
#import "TodayViewController.h"
#import "StocksProviderDelegate.h"
#import "Portfolio.h"
#import "Cell.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString * const GridCellIdentifier = @"CELL";

@implementation TodayViewController

@synthesize lastUpdatedLabel, stocks, manager;

-(void) setup {
    manager = [StocksProvider sharedManager];
    [manager registerStocksProviderDelegate:self];
    self.positiveColor = UIColorFromRGB(0x19D886);
    self.negativeColor = UIColorFromRGB(0xE65B4A);
    
    NSArray *tickers = [Portfolio getTickers];
    
    self.stocks = [Portfolio getStocks];
    
    if (tickers) {
        if(!self.stocks) {
            [manager fetchStocks:YES];
        }
    } else {
        tickers = [Portfolio getTickers];
        if(!self.stocks) {
            [manager fetchStocks :YES];
        } else {
            [manager fetchStocks :NO];
        }
    }
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [manager unregisterStocksProviderDelegate:self];
}

-(void) viewDidLoad {
    [super viewDidLoad];
    [self setup];
    self.collectionView.scrollEnabled = NO;
    [self collectionView].delegate = self;
    [self collectionView].dataSource = self;
    [[self collectionView] registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellWithReuseIdentifier:GridCellIdentifier];
}

-(void) openApp {
    NSURL *appUrl = [NSURL URLWithString:@"todaystocks://"];
    [self.extensionContext openURL:appUrl completionHandler:nil];
}

-(void) updateView {
    self.lastUpdatedLabel.text = [Portfolio lastUpdated];
    [self.collectionView reloadData];
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets) defaultMarginInsets {
    return UIEdgeInsetsZero;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    NSArray *tickers = [Portfolio getTickers];
    float individualStockHeight = 17;
    float divisor;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        divisor = 3;
    } else {
        divisor = 2;
    }
    unsigned long numberOfStocks = (((tickers.count + 1)  / divisor) + 1);
    float stocksTotalHeight =  numberOfStocks * individualStockHeight;
    float labelHeight = self.lastUpdatedLabel.frame.size.height;
    self.preferredContentSize = CGSizeMake(0, stocksTotalHeight + labelHeight);
    stocks = [Portfolio getStocks];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(openApp)];
    [self.view addGestureRecognizer:singleFingerTap];
    if(!stocks || stocks.count == 0) {
        [manager fetchStocks: YES];
    } else {
        [manager fetchStocks: NO];
    }
    completionHandler(NCUpdateResultNewData);
}

# pragma StocksProviderDelegate

- (void)didReceiveStocks:(NSArray *)stocklist {
    self.stocks = stocklist;
    [self updateView];
}

- (void)fetchingStocksFailedWithError:(NSError *)error {
    self.lastUpdatedLabel.text = [error localizedDescription];
}

# pragma collectionview flow delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellSize;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cellSize = collectionView.bounds.size.width/5.0;
    } else {
        cellSize = collectionView.bounds.size.width/2.0;
    }
    return CGSizeMake(cellSize, 17);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return stocks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    const Stock *stock = stocks[indexPath.row];
    
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GridCellIdentifier forIndexPath:indexPath];
    
    UIColor *color;
    if(stock.Change < 0.0) {
        color = _negativeColor;
        [cell.changeLabel setText:[NSString stringWithFormat:@"%.2f",stock.Change]];
    } else {
        color = _positiveColor;
        [cell.changeLabel setText:[NSString stringWithFormat:@"+%.2f",stock.Change]];
    }
    cell.changeLabel.textColor = color;
    cell.changePercentLabel.textColor = color;
    [cell.nameLabel setText:stock.symbol];
    [cell.priceLabel setText:[NSString stringWithFormat:@"%.2f",stock.LastTradePriceOnly]];
    [cell.changePercentLabel setText:stock.ChangeinPercent];
    
    return cell;
    
}


@end
