//
//  ShortSocket.m
//  CommonFramework
//
//  Created by zhengMK on 15/5/3.
//  Copyright (c) 2015年 zhengMK. All rights reserved.
//

#import "ShortSocket.h"



@implementation ShortSocket

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        socketClient = [[AsyncSocket alloc] initWithDelegate:self];

    }
    return self;
}

- (void)dealloc {
    
}


- (instancetype)initWithConnectIp:(NSString*)ipStr port:(unsigned int)port {
    self = [self init];
    if (self) {
        _ipStr = ipStr;
        _port = port;
    }
    return self;
}

- (BOOL)startRequest {

    __weak ShortSocket *weakSelf = self;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(timeCount:) userInfo:nil repeats:YES];
    
    return [self connectIp:_ipStr port:_port];
}

- (BOOL)connectIp:(NSString*)ipStr port:(unsigned int)port {
    
    if ([self isConnect] == YES) {
        [self disconnect];
    }
    
    NSError* error = nil;
    [socketClient connectToHost:ipStr onPort:port error:&error];
    if (error) {
        return NO;
    }
    else
        return YES;
}

- (BOOL)isConnect {
    return [socketClient isConnected];
}

- (void)disconnect {
    [socketClient disconnect];
}

- (void)sendData:(NSData*)data {
    NSMutableData* mData = [NSMutableData dataWithData:data];
    [mData appendData:[AsyncSocket CRLFData]];
    [socketClient writeData:mData withTimeout:-1 tag:0];
}
static int timeCount = 0;
- (void)timeCount:(NSTimer*)timer {
    timeCount ++;
    
    if (timeCount >=15) {
        [self invalidateTimer];
        NSLog(@"超时连接");
        timeCount = 0;
        
        if (_failure) {
            _failure([NSError errorWithDomain:@"请求超时" code:0 userInfo:nil]);
        }
    }
}


- (void)invalidateTimer {
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    timeCount= 0;
    
    [self disconnect];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    if (_success) {
        _success(data);
    }
    [self invalidateTimer];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    NSLog(@"断开连接");
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    [sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
    
    [self sendData:_bodyData];
    
    NSLog(@"连接成功");
}

@end
