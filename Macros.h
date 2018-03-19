//
//  Macros.h
//  IPAddressDemo
//
//  Created by worktree on 19/03/2018.
//  Copyright © 2018 worktree. All rights reserved.
//

//RGB color and 0X color convert to rgb with alpha=1.0
#define ColorFromRGB(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define ColorFromHex(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

//App Info
#define AppInfoDictionary ([[NSBundle mainBundle] infoDictionary])
#define AppShortVersionString ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#define AppVersionString ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"])
#define AppBundleId ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"])
#define AppBundleName ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"])
#define AppDisplayName ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"])

//Main Screen Height-width
#define MainScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define MainScreenWidth ([UIScreen mainScreen].bounds.size.width)

//Status Bar height-width
#define StatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define StatusBarWidth ([UIApplication sharedApplication].statusBarFrame.size.width)
