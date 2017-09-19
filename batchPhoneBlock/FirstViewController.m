//
//  FirstViewController.m
//  batchPhoneBlock
//
//  Created by legend on 2017/9/7.
//  Copyright © 2017年 legend. All rights reserved.
//

#import "FirstViewController.h"
#import "AddRangeViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "APP_CONSTANTS.h"
#import "SharedFileOperator.h"
#import <CallKit/CallKit.h>
#import <Lottie/Lottie.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"号段拦截器";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    [self initUseStatus];
    [self initAddBtnUI];
    [self initTableView];
    [self checkEnableStatus];
    
}

-(void)viewWillAppear:(BOOL)animated {
//    NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.batchblocker"];
    SharedFileOperator *shared = [[SharedFileOperator alloc]initWithSuiteName:@"group.batchblocker" fileName:@"last.plist"];
    //确认是否有更新
    NSDate *lastEdit = [shared valueForKey:@"last_edit"];
    NSDate *lastSync = [shared valueForKey:@"last_sync"];
    if([self compareOneDay:lastEdit withAnotherDay:lastSync] !=0 ){
        NSLog(@"need reload and show sync btn!");
        UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:@"写入" style:UIBarButtonItemStylePlain target:self action:@selector(updateData:)];
        self.navigationItem.rightBarButtonItem = reloadButton;
        NSArray *rangeDict = [shared valueForKey:@"ranges"];
        self.dataList = rangeDict;
        [self.myTableView reloadData];
        //更新notice label
        self.statusLabel.backgroundColor =RGBCOLOR(255, 133, 27);//orange
        self.statusLabel.text = @"号段数据已修改，点[写入]按钮生效";
    }else{
        NSLog(@"not need to sync data");
        self.navigationItem.rightBarButtonItem = nil;
    }

}

//绘制导航台上的各组件
- (void)setNav
{
    //about按钮
    UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithTitle:@"关于" style:UIBarButtonItemStylePlain target:self action:@selector(aboutMe:)];
    self.navigationItem.leftBarButtonItem = aboutButton;
}

//在界面上绘制添加按钮
-(void)initAddBtnUI{
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, Main_Screen_Height-60,Main_Screen_Width, 60);
    NSLog(@"%f",Main_Screen_Height);
    addBtn.backgroundColor = [UIColor clearColor];
    
    [addBtn setTitle:@"添加号段" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    
    [addBtn addTarget:self action:@selector(addNumber:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:addBtn];
}

//绘制启用状态 label
-(void)initUseStatus {
    self.statusLabel = [[UILabel alloc]init];
    self.statusLabel.frame = CGRectMake(0, 64, Main_Screen_Width, 40);
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.backgroundColor = RGBCOLOR(143, 158, 166);//gray
    [self.view addSubview:self.statusLabel];
}

//检查是否已经启用拦截扩展
-(void)checkEnableStatus {
    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
    // 获取权限状态
    [manager getEnabledStatusForExtensionWithIdentifier:@"com.bz.batchPhoneBlock.batcher" completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        if (!error) {
            if (enabledStatus == CXCallDirectoryEnabledStatusDisabled) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.statusLabel.backgroundColor =RGBCOLOR(239, 71, 111);//red
                    self.statusLabel.text = @"拦截功能未开启";
                });
            }else if (enabledStatus == CXCallDirectoryEnabledStatusEnabled) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.statusLabel.backgroundColor =RGBCOLOR(6, 214, 160);//green
                    self.statusLabel.text = @"拦截功能已开启";
                });
            }else if (enabledStatus == CXCallDirectoryEnabledStatusUnknown) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.statusLabel.backgroundColor =RGBCOLOR(255, 133, 27);//orange
                    self.statusLabel.text = @"开启状态未知，请检查设置";
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statusLabel.backgroundColor =RGBCOLOR(239, 71, 111);//red
                self.statusLabel.text = @"发生错误，请检查设置中的启用状态";
            });
        }
    }];
}

// 初始化tableView的数据
-(void)initTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, Main_Screen_Width, Main_Screen_Height -64-40-60) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.myTableView = tableView;
    [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];//去除多余的分割线
    SharedFileOperator *shared = [[SharedFileOperator alloc]initWithSuiteName:@"group.batchblocker" fileName:@"last.plist"];
    NSArray *rangeDict = [shared valueForKey:@"ranges"];
    self.dataList = rangeDict;
    NSLog(@"本地的rang字典：%@",rangeDict);
    [self.view addSubview:self.myTableView];
}


#pragma mark - tableview delegate
//返回有多少个Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//这个方法返回   对应的section有多少个元素，也就是多少行。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}
//这个方法返回指定的 row 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 80;
}
//返回指定的section 的 header  的 title，如果这个section header  有返回view，那么title就不起作用了
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"已屏蔽的号段";
}


/*
 * 当用户选中某个行的cell的时候，回调用这个。但是首先，必须设置tableview的一个属性为可以select 才行
 * TableView.allowsSelection=YES;
 * cell.selectionStyle=UITableViewCellSelectionStyleBlue;
 * 如果不希望响应select，那么就可以用下面的代码设置属性：
 * TableView.allowsSelection=NO;
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//点击完后取消选中
    
}


//绘制Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"SeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    NSUInteger row = indexPath.row;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        //index label
        UILabel *indexLabel = [[UILabel alloc]init];
        indexLabel.frame = CGRectMake(17, 24, 36, 36);
        indexLabel.backgroundColor = RGBCOLOR(214, 214, 214);
        indexLabel.text = [NSString stringWithFormat:@"%li",indexPath.row+1];
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.tag = 1;
        indexLabel.layer.borderColor = RGBCOLOR(191, 191, 191).CGColor;
        indexLabel.layer.borderWidth = 1;
        indexLabel.layer.masksToBounds = YES;
        indexLabel.layer.cornerRadius = 18;
        
        //range connector image
        UIImageView *rangeConnector = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"range_connector"]];
        rangeConnector.frame = CGRectMake(78, 22, 19, 41);
        
        
        
        NSString *start = [NSString stringWithFormat:@"起：%@",[[self.dataList objectAtIndex:row]objectForKey:@"start"]];
        NSString *end = [NSString stringWithFormat:@"末：%@",[[self.dataList objectAtIndex:row]objectForKey:@"end"]];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(104, 5, 200, 30)];
        label.text = start;
        label.tag=2;
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(104, 45, 200, 30)];
        label2.text = end;
        label2.tag=3;
        
        
        CGRect lineFrame = CGRectMake(0,79,Main_Screen_Width,1);
        UIView *line = [[UIView alloc] initWithFrame:lineFrame];
        line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        
        [cell.contentView addSubview:rangeConnector];
        [cell.contentView addSubview:line];
        [cell.contentView addSubview:indexLabel];
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:label2];
        

    }else{
        NSString *start = [NSString stringWithFormat:@"起：%@",[[self.dataList objectAtIndex:row]objectForKey:@"start"]];
        NSString *end = [NSString stringWithFormat:@"末：%@",[[self.dataList objectAtIndex:row]objectForKey:@"end"]];
        UILabel *indexlabel = (UILabel *)[cell.contentView viewWithTag:1];      // <---- get label with tag
        indexlabel.text = [NSString stringWithFormat:@"%li",indexPath.row+1];;
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:2];      // <---- get label with tag
        label.text = start;
        UILabel *labe2 = (UILabel *)[cell.contentView viewWithTag:3];
        labe2.text = end;
    }
    return cell;
}

//设置Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//点击删除，注意：一定是先删除了数据，再执行删除的动画或者其他操作，否则会出现崩溃
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    NSLog(@"delete indexPath :%@",indexPath);
    
    SharedFileOperator *shared = [[SharedFileOperator alloc]initWithSuiteName:@"group.batchblocker" fileName:@"last.plist"];
    NSMutableArray *ranges = [shared valueForKey:@"ranges"];
    [ranges removeObjectAtIndex:indexPath.row];
    [shared setValue:ranges forKey:@"ranges"];
    [shared setValue:[NSDate date] forKey:@"last_edit"];
    [shared synchronize];
    self.dataList = ranges;
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //更新notice label
    self.statusLabel.backgroundColor =RGBCOLOR(255, 133, 27);//orange
    self.statusLabel.text = @"号段数据已修改，点[写入]按钮生效";
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:@"写入" style:UIBarButtonItemStylePlain target:self action:@selector(updateData:)];
    self.navigationItem.rightBarButtonItem = reloadButton;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self.myTableView selector:@selector(reloadData) userInfo:nil repeats:NO];

}

#pragma mark - other

//底部的添加号段按钮点击后的回调
-(void)addNumber:(UIButton *)sender
{
    AddRangeViewController * arvc= [[AddRangeViewController alloc]init];
    [self.navigationController pushViewController:arvc animated:YES];
}

//关于按钮
-(void)aboutMe:(UIButton *)sender
{
    
    AboutViewController * abvc= [[AboutViewController alloc]init];
    [self.navigationController pushViewController:abvc animated:YES];
}


//拦截号码或者号码标识的情况下,号码必须要加国标区号!!!!!!!!
-(void)updateData:(UIButton *)sender
{
    NSLog(@"reload btn clicked");
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"glow_loading"];
    animation.frame = [[UIScreen mainScreen] bounds];
    animation.center = self.view.center;
    animation.contentMode = UIViewContentModeCenter;
    animation.loopAnimation = YES;
    animation.backgroundColor = [UIColor whiteColor];
    UILabel *noticeLabel = [[UILabel alloc]init];
    noticeLabel.text = @"正在写入，请不要退出，否则会失败";
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.textColor = [UIColor lightGrayColor];
    noticeLabel.backgroundColor = [UIColor whiteColor];
    noticeLabel.font = [UIFont systemFontOfSize:12];
    noticeLabel.frame  = CGRectMake(0, Main_Screen_Height-60, Main_Screen_Width, 60);
    noticeLabel.layer.borderWidth = 0;
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    [appDelegate.window.rootViewController.view addSubview:animation];
    [appDelegate.window.rootViewController.view addSubview:noticeLabel];
    
    [animation play];
    
    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
    [manager reloadExtensionWithIdentifier:@"com.bz.batchPhoneBlock.batcher" completionHandler:^(NSError * _Nullable error) {
        //必须在主线程上面移除动画，否则会很慢，大约卡10秒钟
        dispatch_async(dispatch_get_main_queue(), ^{
            [noticeLabel removeFromSuperview];
            [animation stop];
            [animation removeFromSuperview];
        });
        
        if (error == nil) {
            SharedFileOperator *shared = [[SharedFileOperator alloc]initWithSuiteName:@"group.batchblocker" fileName:@"last.plist"];
            NSDate *last_edit = [shared valueForKey:@"last_edit"];
            [shared setValue:last_edit forKey:@"last_sync"];
            [shared synchronize];
            NSLog(@"update success!");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statusLabel.backgroundColor =RGBCOLOR(6, 214, 160);//green
                self.statusLabel.text = @"数据同步成功";
                self.navigationItem.rightBarButtonItem = nil;
            });

        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"更新失败"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/****
 iOS比较日期大小默认会比较到秒
 ****/
-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if ([oneDay compare:anotherDay] == NSOrderedDescending) {
        return 1;
    } else if ([oneDay compare:anotherDay] == NSOrderedAscending) {
        return -1;
    } else {
        return 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
