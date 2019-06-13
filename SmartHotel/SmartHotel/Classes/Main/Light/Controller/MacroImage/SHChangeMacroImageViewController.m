//
//  SHChangeMacroImageViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHChangeMacroImageViewController.h"
#import "SHIconViewCell.h"

@interface SHChangeMacroImageViewController () <UICollectionViewDataSource,
    UICollectionViewDelegate>


/**
 图标名称
 */
@property (strong, nonatomic) NSMutableArray * iconNames;

/**
 图标名称
 */
@property (weak, nonatomic) IBOutlet UICollectionView *iconListView;

@end

@implementation SHChangeMacroImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Choose Icon";
    
    [self.iconListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHIconViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHIconViewCell class])];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    CGFloat itemMarign = 1;
    CGFloat totalCols = 5;
    
    CGFloat itemWidth = (self.iconListView.frame_width - totalCols * itemMarign) / totalCols;
    
    UICollectionViewFlowLayout *flowLayout =
    (UICollectionViewFlowLayout *)self.iconListView.collectionViewLayout;
    
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    flowLayout.minimumLineSpacing = itemMarign;
    flowLayout.minimumInteritemSpacing = itemMarign;
}

// MARK: - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.iconNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SHIconViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SHIconViewCell class]) forIndexPath:indexPath];
    
    
    return cell;
}

// MARK: - getter && setter

- (NSMutableArray *)iconNames {
    
    if (!_iconNames) {
        
        _iconNames = [NSMutableArray arrayWithObjects:
                      @"Scene_1",
                      @"Scene_2",
                      @"Scene_3",
                      @"Scene_4",
                      @"Scene_5",
                      @"Scene_6",
                      nil
                    ];
    }
    
    return _iconNames;
}

@end
