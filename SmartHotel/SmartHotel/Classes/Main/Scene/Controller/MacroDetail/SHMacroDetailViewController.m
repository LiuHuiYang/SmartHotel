//
//  SHMacroDetailViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHMacroDetailViewController.h"
#import "SHMacroDetailViewCell.h"
#import "SHMacroCommandDetailViewController.h"
#import "SHChangeMacroImageViewController.h"

@interface SHMacroDetailViewController () <
    UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>


/**
 宏命令集合
 */
@property (strong, nonatomic) NSMutableArray *macroCommands;


/**
 命令集合
 */
@property (weak, nonatomic) IBOutlet UITableView *listView;

/// 名称
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;


/**
 图标按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *iconButton;


@end

@implementation SHMacroDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    self.macroCommands = [SHSQLManager.shareSHSQLManager getMacroCommands:self.macro];
    
    [self.listView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"Scene Detail";
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"addDevice_navigationbar"
                          hightlightedImageName:@"addDevice_navigationbar"
                                      addTarget:self
                                         action:@selector(addMacroCommand)
                                         isLeft:false
     ];
    
    self.nameTextField.text = self.macro.macroName;
    [self.iconButton setImage:[UIImage imageNamed:self.macro.macroIconName]
                     forState:UIControlStateNormal
    ];
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHMacroDetailViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHMacroDetailViewCell class])];
    
    self.listView.rowHeight =
        SHMacroDetailViewCell.rowHeight;
    
}


/**
 图标按钮点击
 */
- (IBAction)iconButtonClick {
    
    SHChangeMacroImageViewController *changeImage =
        [[SHChangeMacroImageViewController alloc] init];
    
    changeImage.selectImageName = ^(NSString *iconName) {
        
        self.macro.macroIconName = iconName;
        
        [self.iconButton setImage:[UIImage imageNamed:self.macro.macroIconName]
                         forState:UIControlStateNormal
         ];
        
        [SHSQLManager.shareSHSQLManager updateMacro:self.macro];
        
    };
    
    [self.navigationController pushViewController:changeImage animated:YES];
}


// MARK: - 设备的添加与删除


/**
 添加宏命令
 */
- (void)addMacroCommand {
    
    SHMacroCommand *macroCommand =
        [[SHMacroCommand alloc] init];
    
    macroCommand.remark = @"scene command";
    macroCommand.macroID = self.macro.macroID;
    macroCommand.macroCommandID = [SHSQLManager.shareSHSQLManager getAvailableMacroCommandID:self.macro.macroID];
    
    [SHSQLManager.shareSHSQLManager insertMacroCommand:macroCommand];
    
    SHMacroCommandDetailViewController *detailController =
        [[SHMacroCommandDetailViewController alloc] init];
    
    detailController.macroCommand = macroCommand;
    
    [self.navigationController pushViewController:detailController animated:YES];
}

// MARK: - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = UIColor.whiteColor;
    textField.textColor =
        [UIColor colorWithWhite:0.3 alpha:1.0];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = UIColor.clearColor;
    textField.textColor = UIColor.whiteColor;
    
    NSString *newName = textField.text;
    
    if (newName.length == 0 ||
        [newName isEqualToString:self.macro.macroName]) {
        
        [SVProgressHUD showErrorWithStatus:@"invalid name"];
        
        return;
    }
    
    self.macro.macroName = newName;
    
    [SHSQLManager.shareSHSQLManager updateMacro:self.macro];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self textFieldDidEndEditing:textField];
    
    [textField resignFirstResponder];
    
    return YES;
}

// MARK: - UITableView 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHMacroCommandDetailViewController *detailController =
    [[SHMacroCommandDetailViewController alloc] init];
    
    detailController.macroCommand =
        self.macroCommands[indexPath.row];
    
    [self.navigationController pushViewController:detailController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 删除操作
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHMacroCommand *macroCommand =
            self.macroCommands[indexPath.row];
        
        [self.macroCommands removeObject:macroCommand];
        
        [SHSQLManager.shareSHSQLManager deleteMacroCommand:macroCommand];
        
        [tableView reloadData];
    }];
    
    
    // 编辑操作
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHMacroCommandDetailViewController *detailController =
        [[SHMacroCommandDetailViewController alloc] init];
        
        detailController.macroCommand =
        self.macroCommands[indexPath.row];
        
        [self.navigationController pushViewController:detailController animated:YES];
    }];
    
    
    return @[deleteAction, editAction];
}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.macroCommands.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHMacroDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHMacroDetailViewCell class]) forIndexPath:indexPath];
    
    cell.macroCommand = self.macroCommands[indexPath.row];
    
    return cell;
}

@end
