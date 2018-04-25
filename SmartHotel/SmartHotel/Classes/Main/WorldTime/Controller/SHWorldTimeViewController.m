//
//  SHWorldTimeViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHWorldTimeViewController.h"
#import "SHTimeZoneWrapper.h"

@interface SHWorldTimeViewController () <UITableViewDelegate, UITableViewDataSource>

/// 排序器
@property (strong, nonatomic) UILocalizedIndexedCollation *indexCollation;

/// 定时器
@property (weak, nonatomic) NSTimer *timer;

/// 时间区域列表
@property (weak, nonatomic) IBOutlet UITableView *timeZoneListView;

/// 时区分组列表
@property (strong, nonatomic) NSMutableArray *sectionsArray;

/// 所有需要排序的内容
@property (retain,nonatomic) NSMutableArray *allContentSortedArray;

@end

@implementation SHWorldTimeViewController

// MARK: - 数据源 && 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}



// MARK: - UI初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"WorldClock"];
    
    // 设置定时器
    [self setUpTimer];
    
    /// 添加搜索栏
    [self setUpSearchBar];
    
    [self configureSections];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 更新时间
- (void)updatetime {
    
    printLog(@"需要进行时间的重新显示"); // updateTime:
    
}

/// 设置定时器
- (void)setUpTimer  {
 
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updatetime) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [timer fire];
    
    self.timer = timer;
}


/// 添加搜索栏
- (void)setUpSearchBar {
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.barStyle = UIBarStyleBlack;
    searchBar.tintColor = [UIColor whiteColor];
    searchBar.placeholder = @"Enter the name of the city";
    searchBar.frame_height = navigationBarHeight;
    self.timeZoneListView.tableHeaderView = searchBar;
}

/// 配置时间
- (void)configureSections {
    
    
    // ========= 排序数组索引
    
    self.indexCollation = [UILocalizedIndexedCollation currentCollation];

    NSUInteger count = [[self.indexCollation sectionTitles] count];
    
    /// 新的索引数组
    NSMutableArray *newSectionsArray = [NSMutableArray arrayWithCapacity:count];
    
    // 数组中存储数组
    for (NSUInteger index = 0; index < count; index++) {
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        [newSectionsArray addObject:array];
    }
    
    // ======== 时间相关
    
    NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
    NSMutableArray *timeZones = [NSMutableArray arrayWithCapacity:timeZoneNames.count];
    
    for (NSUInteger index = 0; index < timeZoneNames.count; index ++) {
        
        NSString *timeZoneName = timeZoneNames[index];
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
        
        NSArray *nameComponents = [timeZoneName componentsSeparatedByString:@"/"];
        
        SHTimeZoneWrapper *timeZoneWrapper = [[SHTimeZoneWrapper alloc] initWithTimeZone:timeZone nameComponents:nameComponents];
        
        [timeZones addObject:timeZoneWrapper];
    }
    
    for (SHTimeZoneWrapper *timeZone in timeZones) {
        
        NSInteger sectionNumber = [self.indexCollation sectionForObject:timeZone collationStringSelector:@selector(localeName)];
        
        NSMutableArray *sectionTimeZones = [newSectionsArray objectAtIndex:sectionNumber];
        
        [sectionTimeZones addObject:timeZone];
    }
    
    /// 每个时区分组进行排序
    for (NSUInteger index = 0; index < count; index++) {
        
        NSMutableArray *timeZonesArrayForSection = [newSectionsArray objectAtIndex:index];
        
        NSArray *sortedTimeZonesArrayForSection = [self.indexCollation sortedArrayFromArray:timeZonesArrayForSection collationStringSelector:@selector(localeName)];
        
        // 获得最扣的结果（排序的结果替换新数组）
        [newSectionsArray replaceObjectAtIndex:index withObject:sortedTimeZonesArrayForSection];
    }
    
    self.sectionsArray = newSectionsArray;
    
    // 所有排序的内容
    NSMutableArray *contentSortedArray = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger index = 0; index < self.sectionsArray.count; index++) {
        
        NSMutableArray *timeZonesArrayForSection = [newSectionsArray objectAtIndex:index];
        
        for (NSUInteger i = 0; i < timeZonesArrayForSection.count; i++) {
            
            [contentSortedArray addObject:[timeZonesArrayForSection objectAtIndex:i]
             ];
            
        }
    }
    
    self.allContentSortedArray = contentSortedArray;
    
    printLog(@"获得结果: %@", self.sectionsArray);
}


- (void)dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
}

@end
