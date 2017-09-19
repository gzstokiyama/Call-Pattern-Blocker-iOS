//
//  AboutViewController.m
//  batchPhoneBlock
//
//  Created by legend on 2017/9/10.
//  Copyright © 2017年 legend. All rights reserved.
//
//https://itunes.apple.com/app/id1281546886

#import "AboutViewController.h"
#import "MoreInfoViewController.h"
#import "APP_CONSTANTS.h"
#import "SharedFileOperator.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(230, 230, 230);
    self.title = @"关于";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addAboutUI];
//    //添加清空按钮
//    UIBarButtonItem *flushButton = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(flushData:)];
//    self.navigationItem.rightBarButtonItem = flushButton;
    
}


-(void)addAboutUI {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 200)];
    headerView.backgroundColor = [UIColor clearColor];
    //logo
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ban_logo"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.frame = CGRectMake(0 , 0, Main_Screen_Width, 150);
    [headerView addSubview:logo];
    //slogan
    UILabel *slogan = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, Main_Screen_Width, 40)];
    slogan.backgroundColor  = [UIColor clearColor];
    slogan.textColor = RGBCOLOR(142, 142, 142);
    slogan.text = @"神器在手，烦人电话再没有";
    slogan.contentMode = UIViewContentModeCenter;
    slogan.textAlignment = NSTextAlignmentCenter;
    slogan.font = [UIFont systemFontOfSize:16.0];
    [headerView addSubview:slogan];
    //info table
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height -64) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableHeaderView = headerView;
    self.infoTableView = tableView;
    
    NSArray *list1 = [NSArray arrayWithObjects:
                      [NSArray arrayWithObjects:@"版本号",[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"], nil],
                      [NSArray arrayWithObjects:@"Build",[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"], nil],
                      [NSArray arrayWithObjects:@"官方Q群",@"570024087", nil],
                      [NSArray arrayWithObjects:@"作者",@"殷志平", nil],
                      nil];
    NSArray *list2=[NSArray arrayWithObjects:@"去评分",@"更多", nil];
    NSArray *list3=[NSArray arrayWithObjects:@"清除全部数据", nil];
    NSArray *list =[NSArray arrayWithObjects:list1,list2,list3, nil];
    self.infoDataList = list;
    [self.view addSubview:self.infoTableView];
    
}


# pragma mark - table delegate

//返回有多少个Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//这个方法返回   对应的section有多少个元素，也就是多少行。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.infoDataList objectAtIndex:section] count];
}

//这个方法返回指定的 row 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kCellDefaultHeight;
}


//返回指定的section 的 header  的 title，如果这个section header  有返回view，那么title就不起作用了
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
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
    
    
    if (indexPath.section ==1 ) {
        if (indexPath.row==0) {
            //去评分
            //https://itunes.apple.com/app/id1281546886
            NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@?ls=1&mt=8",@"1281546886"];;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
        }else if(indexPath.row==1){
            //更多
            MoreInfoViewController *moreInfo = [[MoreInfoViewController alloc]init];
            [self.navigationController pushViewController:moreInfo animated:YES];
        }
    }
    //清空全部数据
    if (indexPath.section == [self.infoDataList count]-1) {
        [self flushData];
    }
}


//绘制Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"infoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    NSUInteger row = [indexPath row];
    if(indexPath.section==0){
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        }
    }else{
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        }
    }
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = [[[self.infoDataList objectAtIndex:indexPath.section]objectAtIndex:row]objectAtIndex:0];
        cell.detailTextLabel.text = [[[self.infoDataList objectAtIndex:indexPath.section]objectAtIndex:row]objectAtIndex:1];
    }else if(indexPath.section==1){
        cell.textLabel.text = [[self.infoDataList objectAtIndex:indexPath.section]objectAtIndex:row];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
    }else {
        cell.textLabel.text = [[self.infoDataList objectAtIndex:indexPath.section]objectAtIndex:row];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        cell.backgroundColor=[UIColor whiteColor];
    }
    
    
    
    return cell;
}


-(void)flushData
{
    SharedFileOperator *shared = [[SharedFileOperator alloc]initWithSuiteName:@"group.batchblocker" fileName:@"last.plist"];
    [shared removeObjectForKey:@"ranges"];
    [shared setValue:[NSDate date] forKey:@"last_edit"];
    [shared synchronize];
    [self showAlert:@"数据已全部清空"];
}

- (void)showAlert:(NSString *)showtext {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:showtext
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
