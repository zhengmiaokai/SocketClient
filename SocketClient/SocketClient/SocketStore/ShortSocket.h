//
//  ShortSocket.h
//  CommonFramework
//
//  Created by zhengMK on 15/5/3.
//  Copyright (c) 2015年 zhengMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@interface ShortSocket : NSObject<AsyncSocketDelegate>
{
    AsyncSocket* socketClient;
    NSTimer* _timer;
    
    @private
    NSString* _ipStr;
    unsigned int _port;
}

@property (nonatomic, strong) NSData* bodyData;

@property (nonatomic, strong) void(^success)(id data);

@property (nonatomic, strong) void(^failure)(NSError* error);

- (BOOL)startRequest;

- (instancetype)initWithConnectIp:(NSString*)ipStr port:(unsigned int)port;

@end
