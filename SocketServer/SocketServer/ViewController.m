//
//  ViewController.m
//  SocketServer
//
//  Created by zhengMK on 15/5/3.
//  Copyright (c) 2015年 zhengMK. All rights reserved.
//

#import "ViewController.h"
#import "ServerSocket.h"

@implementation ClassA

- (id)copyWithZone:(NSZone *)zone{
    ClassA* class = [[self class] allocWithZone:zone];
    class.str1 = _str1;
    return class;
//    return  self;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    ClassA* class = [[self class] allocWithZone:zone];
    class.str1 = _str1;
    return class;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [[ServerSocket sharedManager] startListen:8888];
    
    __block ViewController* weakSelf = self;
    [[ServerSocket sharedManager] addBlock:^(NSData *data, AsyncSocket* socket) {
        
        Byte bytes[2] = {0xaa,0x55};
        
        if ([[data subdataWithRange:NSMakeRange(0, 2)] isEqualToData:[NSData dataWithBytes:bytes length:2]]) {
            weakSelf.shortLab.stringValue = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(2, data.length - 2)] encoding:NSUTF8StringEncoding];
            
            NSMutableData* mData = [NSMutableData dataWithData:[_contentTextField.stringValue dataUsingEncoding:NSUTF8StringEncoding]];
            
            [mData appendData:[AsyncSocket CRLFData]];
            
            [socket writeData:mData withTimeout:-1 tag:0];
        }
        else{
            weakSelf.longLab.stringValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    } withTag:11];
    
    [[ServerSocket sharedManager] setClientblock:^(NSString *string) {
        weakSelf.ipLab.stringValue = string;
    }];
    
    [[ServerSocket sharedManager] setShortResponse:^(AsyncSocket *s,NSData* data) {
        
    }];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (NSData *)getData1
{
    Byte byte[2] = {0x6c,1&0xff};
    
    NSMutableData* data =  [NSMutableData dataWithBytes:byte length:2];
    
    [data appendData:[_contentTextField.stringValue dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSInteger sum = data.length;
    
    Byte byte1[2] = {sum&0xff,0x16};
    
    [data appendBytes:byte1 length:2];
    
    return data;
}

- (NSData *)getData2
{
    Byte byte[2] = {0x6c,2&0xff};
    
    NSMutableData* data =  [NSMutableData dataWithBytes:byte length:2];
    
    NSError* error = nil;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"title":@"我是Server",
                                                                 @"content":@"很高兴你的到来"}
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    [data appendData:jsonData];
    
    NSInteger sum = data.length;
    
    Byte byte1[2] = {sum&0xff,0x16};
    
    [data appendBytes:byte1 length:2];
    
    return data;
}

- (NSData *)getData3
{
    Byte byte[10] = {0x6c,3&0xff,16&0xff,54&0xff,50&0xff,18&0xff,9&0xff,20&0xff}; //时间 16:54:50 2018年09月20日
    
    int sum = 8;
    
    byte[8] = sum&0xff;
    byte[9] = 0x16;
    
    NSData* data = [NSData dataWithBytes:byte length:10];
    
    return data;
}

static int tag = 1;

- (IBAction)target:(id)sender
{
    NSData* data = nil;
    if (tag == 1) {
        data = [self getData1];
        tag = 2;
    }
    else if (tag == 2) {
        data = [self getData2];
        tag = 3;
    }
    else if (tag == 3) {
        data = [self getData3];
        tag = 1;
    }
    
    NSMutableData* mData = [[NSMutableData alloc] initWithData:data];
    [mData appendData:[AsyncSocket CRLFData]];
    [[ServerSocket sharedManager] sendMessageToAll:mData];
}



@end
