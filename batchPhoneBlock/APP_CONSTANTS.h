//
//  APP_CONSTANTS.h
//  batchPhoneBlock
//
//  Created by legend on 2017/9/9.
//  Copyright © 2017年 legend. All rights reserved.
//

#ifndef APP_CONSTANTS_h
#define APP_CONSTANTS_h

//** 沙盒路径 ***********************************************************************************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
/* ****************************************************************************************************************** */
/** DEBUG LOG **/
#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif
/** DEBUG RELEASE **/
#if DEBUG
#define MCRelease(x)            [x release]
#else
#define MCRelease(x)            [x release], x = nil
#endif
/** NIL RELEASE **/
#define NILRelease(x)           [x release], x = nil
/* ****************************************************************************************************************** */
#pragma mark - Frame (宏 x, y, width, height)
// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height
#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)
#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)
#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)
// 系统控件默认高度
#define kStatusBarHeight        (20.f)
#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)
#define kCellDefaultHeight      (44.f)
#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)
/* ****************************************************************************************************************** */
#pragma mark - Funtion Method (宏 方法)
// PNG JPG 图片路径
#define PNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]
// 加载图片
#define PNGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]
// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]
// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]
// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]
// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])
// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])
// 是否Retina屏
#define isRetina                ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), \
[[UIScreen mainScreen] currentMode].size) : \
NO)
// 是否iPhone5
#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), \
[[UIScreen mainScreen] currentMode].size) : \
NO)
// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
// UIView - viewWithTag
#define VIEWWITHTAG(_OBJECT, _TAG)\
\
[_OBJECT viewWithTag : _TAG]
// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define LocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)
// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
#if TARGET_OS_IPHONE
/** iPhone Device */
#endif
#if TARGET_IPHONE_SIMULATOR
/** iPhone Simulator */
#endif
// ARC
#if __has_feature(objc_arc)
/** Compiling with ARC */
#else
/** Compiling without ARC */
#endif
//宏定义，用来读取应用程序的文件，比如图片等
#define App_ContentFile(aFileName,aFileType) [[NSBundle mainBundle]pathForResource:aFileName ofType:aFileType]
//宏定义，定义应用程序的文件路径，该路径指向程序的Library文件夹
#define App_FilePath_Library [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//宏定义，定义应用程序的文件路径，该路径指向程序的Document文件夹
#define App_FilePath_Document [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//数字键盘
#define KEY_WIDTH Main_Screen_Width/3 -3
#define KEY_HEIGHT 53

#endif /* APP_CONSTANTS_h */
