//
//  ViewController.h
//  SocketServer
//
//  Created by zhengMK on 15/5/3.
//  Copyright (c) 2015年 zhengMK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ClassA : NSObject<NSCopying,NSMutableCopying>

@property (nonatomic, strong) NSString* str1;
@property (nonatomic, strong) NSString* str2;

@end

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *longLab;
@property (weak) IBOutlet NSTextField *shortLab;
@property (weak) IBOutlet NSButton *sendBtn;
@property (weak) IBOutlet NSTextField *contentTextField;
@property (weak) IBOutlet NSTextField *ipLab;


- (IBAction)target:(id)sender;

@end

