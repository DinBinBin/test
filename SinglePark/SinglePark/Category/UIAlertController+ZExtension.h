//
//  UIAlertController+ZExtension.h
//  KYFinance
//
//  Created by Zhang_yD on 16/5/24.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (ZExtension)

+ (void)showNormalAlertVCInVC:(UIViewController * _Nonnull)rootVC
                      message:(NSString * _Nullable)message
                        style:(UIAlertControllerStyle)style
                           ok:(void (^ __nullable)())okHandler
                       cancel:(void (^ __nullable)())cancelHandler;

+ (void)showInfoAlertVCInVC:(UIViewController * _Nonnull)rootVC
                    message:(NSString * _Nullable)message
                         ok:(void (^ __nullable)())okHandler;

@end
