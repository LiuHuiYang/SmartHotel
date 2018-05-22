//
//  SHWorldTimeViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHWorldTimeViewController.h"
#import "SHTimeZoneWrapper.h"
#import "SHWordTimeViewCell.h"


#define SHTextDefaultColor ([UIColor colorWithWhite:215/255.0 alpha:1.0])

@interface SHWorldTimeViewController () <UITableViewDelegate,
UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate>


/// 时间区域列表
@property (weak, nonatomic) IBOutlet UITableView *timeZoneListView;

@property (strong,nonatomic) NSMutableArray *sectionsArray;

@property (strong,nonatomic) NSMutableArray *allContentSorted;
@property (nonatomic,strong) NSMutableArray *filteredListContent;


@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, weak) NSTimer *minuteTimer;


@property (strong,nonatomic)NSArray *arrTimezone;
@property (strong,nonatomic)NSIndexPath *indexPathLast,*indexPathSaved;//区域选择的单选表。


@property (strong,nonatomic)NSMutableDictionary *mtbDicConnects;
@property (strong,nonatomic)UILocalizedIndexedCollation *collation;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

/// 搜索框
@property (strong, nonatomic) UISearchController *searchController;


/// 查询结果
@property (strong, nonatomic) NSMutableArray *results;

@end

@implementation SHWorldTimeViewController

// MARK: - 搜索栏的代理


- (void)willPresentSearchController:(UISearchController *)searchController {
     printLog(@"%s", __func__);
    
//    CGRect tableFrame = self.timeZoneListView.frame;
//    self.timeZoneListView.frame_y = statusBarHeight;
////    self.timeZoneListView = self.view.frame_height - statusBarHeight;
////    self.timeZoneListView.frame = tableFrame;
//    [UIView animateWithDuration:0.4 animations:^{
//        [self.view layoutIfNeeded];
//        [self.timeZoneListView layoutIfNeeded];
//    }];
    
//    [self.view addSubview:self.searchController.searchBar];
    
//    searchController.searchBar.frame_width = self.timeZoneListView.frame_width;
//    self.searchController.searchBar.frame_centerX = self.timeZoneListView.frame_centerX;
//    [self.view layoutIfNeeded];
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    
    searchController.searchBar.frame_width = self.timeZoneListView.frame_width;
    self.searchController.searchBar.frame_x = self.timeZoneListView.frame_x;
    [self.view layoutIfNeeded];
//    [self.view addSubview:self.searchController.searchBar];
    
}
- (void)willDismissSearchController:(UISearchController *)searchController {
     printLog(@"%s", __func__);
}
- (void)didDismissSearchController:(UISearchController *)searchController {
     printLog(@"%s", __func__);
}


- (void)presentSearchController:(UISearchController *)searchController {
    
    printLog(@"%s", __func__);
}


// MARK: - 搜索栏的代理

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *inputString = searchController.searchBar.text;
    
    if (!inputString.length || [inputString isEqualToString:@"(null)"]) {
        
        if (self.results.count) {
            
            [self.results removeAllObjects];
        }
        
        [self.results addObjectsFromArray:self.allContentSorted];
        
        [self.timeZoneListView reloadData];
        
        return;
    }
    
    if (self.results.count) {
        
        [self.results removeAllObjects];
    }
    
    for (SHTimeZoneWrapper *wrapper in self.allContentSorted) {
        
        // 不管是全大写或全小写 或者原样查找
        if ([wrapper.localeName hasPrefix:[inputString lowercaseString]] ||
            [wrapper.localeName hasPrefix:[inputString uppercaseString]] ||
            [wrapper.localeName hasPrefix:inputString]) {
            
            [self.results addObject:wrapper];
        }
    }
    
    [self.timeZoneListView reloadData];
    
}

// MARK: - 数据源 && 代理

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return [self.collation sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (self.searchController.active) {
        return nil;
    }
    
    return [self.collation sectionIndexTitles][section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.searchController.active) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = [self.collation sectionIndexTitles][section];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.textColor = SHTextDefaultColor;
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.searchController.active) {
        
        return 0;
    }
    
    return defaultHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.searchController.active) {
        
        return 1;
    }
    
    return [[self.collation sectionTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchController.active) {
        
        return self.results.count;
    }
    
    NSArray *timeZonesInSection = [self.sectionsArray objectAtIndex:section];
    
    return [timeZonesInSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHWordTimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHWordTimeViewCell class]) forIndexPath:indexPath];
    
    if (self.searchController.active) {
        
        SHTimeZoneWrapper *wrapper = [self.results objectAtIndex:indexPath.row];
        
        cell.showName = wrapper.localeName;
        [self.dateFormatter setTimeZone:wrapper.timeZone];
        cell.showTime = [self.dateFormatter stringFromDate:[NSDate date]];
        
        return cell;
    }
    
    NSMutableArray *mtbArrZones = (NSMutableArray *)[self.sectionsArray objectAtIndex:indexPath.section];
    SHTimeZoneWrapper *wrapper = [mtbArrZones objectAtIndex:indexPath.row];
    
    cell.showName = wrapper.localeName;
    
    [self.dateFormatter setTimeZone:wrapper.timeZone];
    cell.showTime = [self.dateFormatter stringFromDate:[NSDate date]];
    
    return cell;
}


// MARK: - UI初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"WorldClock"];
    
    self.timeZoneListView.rowHeight = [SHWordTimeViewCell rowHeightForWordTimeViewCell];
    [self.timeZoneListView registerNib:[UINib nibWithNibName
                                        :NSStringFromClass([SHWordTimeViewCell class])
                                        bundle:nil]
                forCellReuseIdentifier:NSStringFromClass([SHWordTimeViewCell class])];
    
    self.timeZoneListView.sectionIndexColor = SHTextDefaultColor;
    self.timeZoneListView.sectionFooterHeight = 0;
    
    [self configureSections];
    
    self.filteredListContent = [[NSMutableArray alloc]init];
    
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // 添加搜索栏
    UISearchController *searchController = [[UISearchController alloc]
                                            initWithSearchResultsController:nil];
    
    searchController.searchResultsUpdater = self;
    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.delegate = self;
    searchController.searchBar.barTintColor =
        [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_showTime_iPad"]];
    searchController.searchBar.placeholder= @"Input a city name";
    searchController.searchBar.showsCancelButton = YES;
    searchController.searchBar.showsScopeBar = YES;
    [searchController.searchBar sizeToFit];
    
    self.timeZoneListView.tableHeaderView = searchController.searchBar;
    self.searchController = searchController;
    
    [self setUpTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

/// 更新时间
- (void)updatetime {
    
    [self.timeZoneListView reloadData];
}

/// 设置定时器
- (void)setUpTimer  {
    
    // 获得当前时间
    // 由于每次进入这个界面不一定都是 00秒
    [self updatetime]; // 先设置第一次的时间
    
    NSInteger second = [[NSDate getCurrentDateComponents] second];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((60 - second) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 此时是00
        [self updatetime];
        
        // 增加定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updatetime) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        self.minuteTimer = timer;
    });
}


/// 配置时间
- (void)configureSections {
    
    // Get the current collation and keep a reference to it.
    self.collation = [UILocalizedIndexedCollation currentCollation];
    
    NSInteger index, sectionTitlesCount = [[self.collation sectionTitles] count];
    
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    // Set up the sections array: elements are mutable arrays that will contain the time zones for that section.
    for (index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
    NSMutableArray *timeZones = [[NSMutableArray alloc] initWithCapacity:[timeZoneNames count]];
    
    
    for (int i = 0; i < [timeZoneNames count];i++) {
        
        NSString *timeZoneName = [timeZoneNames objectAtIndex:i];
        NSArray *nameComponents = [timeZoneName componentsSeparatedByString:@"/"];
        // For this example, the time zone itself isn't needed.
        
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:timeZoneName];
        
        SHTimeZoneWrapper *timeZoneWrapper = [[SHTimeZoneWrapper alloc] initWithTimeZone:timeZone nameComponents:nameComponents];
        
        [timeZones addObject:timeZoneWrapper];
    }
    
    // Segregate the time zones into the appropriate arrays.
    for (SHTimeZoneWrapper *timeZone in timeZones) {
        
        // Ask the collation which section number the time zone belongs in, based on its locale name.
        NSInteger sectionNumber = [self.collation sectionForObject:timeZone collationStringSelector:@selector(localeName)];
        
        // Get the array for the section.
        NSMutableArray *sectionTimeZones = [newSectionsArray objectAtIndex:sectionNumber];
        
        //  Add the time zone to the section.
        [sectionTimeZones addObject:timeZone];
    }
    
    // Now that all the data's in place, each section array needs to be sorted.
    for (index = 0; index < sectionTitlesCount; index++) {
        
        NSMutableArray *timeZonesArrayForSection = [newSectionsArray objectAtIndex:index];
        
        // If the table view or its contents were editable, you would make a mutable copy here.
        NSArray *sortedTimeZonesArrayForSection = [self.collation sortedArrayFromArray:timeZonesArrayForSection collationStringSelector:@selector(localeName)];
        
        // Replace the existing array with the sorted array.
        [newSectionsArray replaceObjectAtIndex:index withObject:sortedTimeZonesArrayForSection];
    }
    
    self.sectionsArray = newSectionsArray;
    
    NSMutableArray *mtbArrTemp =
        [[NSMutableArray alloc]initWithCapacity:sectionTitlesCount];
    
    for (int i = 0; i< [self.sectionsArray count]; i++) {
        NSMutableArray *timeZonesArrayForSection =
            [newSectionsArray objectAtIndex:i];
        
        for (int j = 0; j<[timeZonesArrayForSection count]; j++) {
            [mtbArrTemp addObject:[timeZonesArrayForSection objectAtIndex:j]];
            
        }
    }
    
    self.allContentSorted = mtbArrTemp;
}


// MARK: - getter && setter

- (NSMutableArray *)results {
    
    if (!_results) {
        
        _results = [NSMutableArray array];
    }
    
    return _results;
}

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        
        [_dateFormatter setDateFormat:@"h:mm a"];
    }
    return _dateFormatter;
}

- (void)dealloc {
    
    [self.minuteTimer invalidate];
    self.minuteTimer = nil;
}

@end
