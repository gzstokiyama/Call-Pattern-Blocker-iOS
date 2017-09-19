//
//  AddRangeViewController.m
//  batchPhoneBlock
//
//  Created by legend on 2017/9/7.
//  Copyright © 2017年 legend. All rights reserved.
//

#import "AddRangeViewController.h"
#import "APP_CONSTANTS.h"
#import "SharedFileOperator.h"

@interface AddRangeViewController ()

@end

@implementation AddRangeViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.textField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加号码段";
    [self addSomeUI];
}


-(void)addSomeUI {
    //说明文字
    UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 40)];
    noticeLabel.text = @"固定电话请加区号,通配符用星号代替";
    noticeLabel.textColor = [UIColor whiteColor];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    noticeLabel.backgroundColor = RGBCOLOR(24, 187, 242);
    noticeLabel.numberOfLines = 0;
    [noticeLabel setFont:[UIFont systemFontOfSize:18]];
    
    [self.view addSubview:noticeLabel];
    //输入框
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 130, Main_Screen_Width-60, 40)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;//设置输入框的边框类型为圆角
    self.textField.delegate = self;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    [self.textField setFont:[UIFont systemFontOfSize:18]];
    [self.textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.textField setPlaceholder:@"输入号段,例如:1381234****"];
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.text=@" +86";
    leftLabel.frame = CGRectMake(0, 0, 45, 40);
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [leftLabel setFont:[UIFont systemFontOfSize:20]];
    
    self.textField.leftView = leftLabel;
    
    [self.view addSubview:self.textField];
    
    
    //确认添加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(30, 190, Main_Screen_Width-60, 40)];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor colorWithRed:24/255.0 green:187/255.0 blue:242/255.0 alpha:1];
    addBtn.tintColor = [UIColor whiteColor];
    [addBtn addTarget:self action:@selector(addNumber:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:addBtn];
    
    
}

-(NSString *)getRangeValue {
    NSString *raw = self.textField.text;
    NSString *simpleReplace = [[[raw stringByReplacingOccurrencesOfString:@"-" withString:@""]stringByReplacingOccurrencesOfString:@"+" withString:@""]stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSUInteger length = [simpleReplace length];
    for (NSUInteger i = 0; i < length; i++)
    {
        if ([simpleReplace characterAtIndex:i] != '0')
        {
            return [NSString stringWithFormat:@"86%@",[simpleReplace substringFromIndex:i]];
        }
    }
    return @"0";
}



-(void)addNumber:(UIButton *)sender
{
    NSString *num = [self getRangeValue];
    NSDecimalNumber *start=[[NSDecimalNumber alloc]initWithString:[num stringByReplacingOccurrencesOfString:@"*" withString:@"0"]];
    
    NSDecimalNumber *end = [[NSDecimalNumber alloc]initWithString:[num stringByReplacingOccurrencesOfString:@"*" withString:@"9"]];
    
    //一次不允许超过5个星号
    if([self subStringCount:num findString:@"*"] >5){
        [self showAlert:@"一次最多输入5个星号"];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"range from %@ to %@",start,end];
    NSLog(@"%@", message);
    
    
    if([start longLongValue] == [end longLongValue]){
        [self showAlert:@"本APP不支持精确拉黑，请设置号段"];
    }else{
        [self checkAndSaveRanges:start end:end];
    }

}

-(NSUInteger)subStringCount:str findString:(NSString *)findString {
    NSUInteger count = 0, length = [str length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [str rangeOfString: findString options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++; 
        }
    }
    return  count;
}


-(void)checkAndSaveRanges:(NSNumber *)start end:(NSNumber *)end {
    //读取已有记录，然后便利确认是否冲突
    SharedFileOperator *shared = [[SharedFileOperator alloc]initWithSuiteName:@"group.batchblocker" fileName:@"last.plist"];
    NSArray *rangeDict = [shared valueForKey:@"ranges"];
    if([rangeDict count]>0){
        NSLog(@"%@",rangeDict);
        //便利所有
        for(id obj in rangeDict){
            NSLog(@"%@",obj);
            if([self checkIfTwoRangesHaveCrossArea:start range1_end:end range2_start:[obj objectForKey:@"start"] range2_end:[obj objectForKey:@"end"]]){
                
                [self showAlert:@"添加的号码和已经屏蔽的有冲突！！！！"];
                return;
            }
        }
        
    }else{
        NSLog(@"没有本地存储的记录");
    }
    //重新排序病插入，保存
    NSDictionary *single_data = [NSDictionary dictionaryWithObjectsAndKeys:
                                 start,@"start",
                                 end, @"end",
                                 nil];

    NSMutableArray *range_dict_new = [[NSMutableArray alloc]init];
    [range_dict_new addObjectsFromArray:rangeDict];
    [range_dict_new addObject:single_data];
    //排序
    
    NSArray *newResult =
    [range_dict_new sortedArrayUsingComparator:^(id obj1,id obj2)
     {
         NSDictionary *dic1 = (NSDictionary *)obj1;
         NSDictionary *dic2 = (NSDictionary *)obj2;
         NSNumber *num1 = (NSNumber *)[dic1 objectForKey:@"start"];
         NSNumber *num2 = (NSNumber *)[dic2 objectForKey:@"start"];
         if ([num1 longLongValue]  < [num2 longLongValue])
         {
             return (NSComparisonResult)NSOrderedAscending;
         }
         else
         {
             return (NSComparisonResult)NSOrderedDescending;
         }
         return (NSComparisonResult)NSOrderedSame;
     }];
    
    
    
    [shared setValue:newResult forKey:@"ranges"];
    [shared setValue:[NSDate date] forKey:@"last_edit"];
    [shared synchronize];
    self.textField.text = @"";
    [self showAlert:@"添加成功"];
    
}

//逻辑检查部分
-(BOOL)checkIfTheNumberIsInRange:(NSNumber *)detectNumber startNumber:(NSNumber *)start endNumber:(NSNumber *)end {
    if([detectNumber longLongValue]>=[start longLongValue] && [detectNumber longLongValue]<=[end longLongValue]){
        return YES;
    }
    return NO;
}

-(BOOL)checkIfTwoRangesHaveCrossArea:(NSNumber *)range1_start range1_end:(NSNumber *)range1_end range2_start:(NSNumber *)range2_start range2_end:(NSNumber *)range2_end {
    if([self checkIfTheNumberIsInRange:range1_start startNumber:range2_start endNumber:range2_end]){
        return YES;
    }
    if([self checkIfTheNumberIsInRange:range1_end startNumber:range2_start endNumber:range2_end]){
        return YES;
    }
    if([self checkIfTheNumberIsInRange:range2_start startNumber:range1_start endNumber:range1_end]){
        return YES;
    }
    if([self checkIfTheNumberIsInRange:range2_end startNumber:range1_start endNumber:range1_end]){
        return YES;
    }
    return NO;
}

//键盘按return隐藏
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
/*
 * 触摸空白处隐藏键盘
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
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

#pragma mark - textField delegate functions

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"keyboard begin edit");
    
    //delay some seconds because button appears after the keyboard, this method works but not well T_T
    [self performSelector:@selector(addXButtonToKeyboard) withObject:nil afterDelay:0.3];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //when the keyboard hide, remove the Xbutton
    NSLog(@"keyboard end edit");
    [self removeXButtonFromKeyBoard];
    
}



#pragma mark - modify method:add button and callback

- (void)addXButtonToKeyboard
{
    [self addXButtonToKeyboardWithSelector:@selector(onXButtonClicked)
                                 normalImg:[UIImage imageNamed:@"x_normal.png"]
                              highlightImg:[UIImage imageNamed:@"x_pressed.png"]];
    
}

- (void)addXButtonToKeyboardWithSelector:(SEL)button_callback normalImg:(UIImage *)normal_icon highlightImg:(UIImage *)highlight_icon
{
    //create the XButton
    UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    xButton.tag = 8;
    xButton.frame = CGRectMake(0, 0, KEY_WIDTH, KEY_HEIGHT); //the half size of the original image
    xButton.adjustsImageWhenDisabled = NO;
    
    [xButton setImage:normal_icon forState:UIControlStateNormal];
    [xButton setImage:highlight_icon forState:UIControlStateHighlighted];
    [xButton addTarget:self action:button_callback forControlEvents:UIControlEventTouchUpInside];
    
    //add to keyboard
    long cnt = [[UIApplication sharedApplication] windows].count ;
    UIWindow *keyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:cnt - 1];
    xButton.frame = CGRectMake(0, keyboardWindow.frame.size.height - KEY_HEIGHT, KEY_WIDTH, KEY_HEIGHT);
    [keyboardWindow addSubview:xButton];
    
}

//when XButton clicked, textField add '*' char
- (void)onXButtonClicked
{
    self.textField.text = [self.textField.text stringByAppendingString:@"*"];
}

//remove XButton from keyboard when the keyboard hide
- (void)removeXButtonFromKeyBoard
{
    long cnt = [[UIApplication sharedApplication] windows].count;
    UIWindow *keyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:cnt - 1];
    [[keyboardWindow viewWithTag:8] removeFromSuperview];
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
