//
//  SHLightViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHLightViewController.h"
#import "SHMacroCollectionViewCell.h"


@interface SHLightViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

// MARK: - UI控件相关

/// 灯泡列表(底部)
@property (weak, nonatomic) IBOutlet UICollectionView *lightListView;

/// 继电器模块列表(中间)
@property (weak, nonatomic) IBOutlet UICollectionView *realayListView;

/// 场景列表(底部)
@property (weak, nonatomic) IBOutlet UICollectionView *senceListView;


// MARK: - 其它

/// 所有场景
@property (strong, nonatomic) NSMutableArray *allSences;

@end

@implementation SHLightViewController


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
     
    NSInteger numberOfItems = [collectionView numberOfItemsInSection:0];
    
    CGFloat combinedItemWidth = (numberOfItems * collectionViewLayout.itemSize.width) + ((numberOfItems - 1)*collectionViewLayout.minimumLineSpacing);
    
    CGFloat padding = (collectionView.frame.size.width - combinedItemWidth) * 0.5;
    
    padding = padding > 0 ? padding :0 ;
    
    return UIEdgeInsetsMake(0, padding * 0.5, 0, 0);
}

// MARK: - 数据源

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.senceListView) {
        
        SHMacroCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SHMacroCollectionViewCell class]) forIndexPath:indexPath];
        
        cell.macro = self.allSences[indexPath.item];
        
        return cell;
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.senceListView) {
        
        return self.allSences.count;
    }
    
    return 0;
}

// MARK: - 视图加协显示

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    
    // 场景的布局
    CGFloat sencesItemMarign  = defaultHeight;
    NSUInteger sencesTotalCols = 5;
    
    CGFloat sencesItemWidth = (self.senceListView.frame_width - (sencesTotalCols * sencesItemMarign)) / sencesTotalCols;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.self.senceListView.collectionViewLayout;
    
    flowLayout.itemSize = CGSizeMake(sencesItemWidth, self.senceListView.frame_height * 0.99);
    flowLayout.minimumLineSpacing = sencesItemMarign;
    flowLayout.minimumInteritemSpacing = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.allSences = [[SHSQLManager shareSHSQLManager] getAllSences];
    
    [self.senceListView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Lights"];
    
    self.lightListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Share_SmallBG"]];
    
    self.realayListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Share_SmallBG"]];
    
    self.senceListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Share_SmallBG"]];
    
    [self.senceListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHMacroCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHMacroCollectionViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
