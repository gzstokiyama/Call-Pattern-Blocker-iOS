//
//  FirstViewController.h
//  batchPhoneBlock
//
//  Created by legend on 2017/9/7.
//  Copyright © 2017年 legend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) NSArray *dataList;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UILabel *statusLabel;

@end

