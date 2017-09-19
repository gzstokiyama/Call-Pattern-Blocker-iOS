//
//  MoreInfoViewController.m
//  batchPhoneBlock
//
//  Created by legend on 2017/9/12.
//  Copyright © 2017年 legend. All rights reserved.
//

#import "MoreInfoViewController.h"
#import "APP_CONSTANTS.h"

@interface MoreInfoViewController ()

@end

@implementation MoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"更多";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self displayText];
}

-(void)displayText {
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, Main_Screen_Width , Main_Screen_Height-64)];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"info" ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    textView.text = content;
    textView.editable = NO;
    textView.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    textView.textColor = RGBCOLOR(75, 75, 75);
    textView.textAlignment = NSTextAlignmentLeft;
    textView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:textView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
