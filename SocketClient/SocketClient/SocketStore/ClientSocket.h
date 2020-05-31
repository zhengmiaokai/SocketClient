//
//  ClientSocket.h
//  CommonFramework
//
//  Created by zhengMK on 15/5/3.
//  Copyright (c) 2015年 zhengMK. All rights reserved.
//

/*socket设置tag，下次接收到的回调就是设置tag的socket*/

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

typedef  void(^SocketBlock)(BOOL isSuccess, id data);

@interface BlockObject: NSObject

@property (nonatomic, copy) SocketBlock block;
@property (nonatomic)  NSInteger blockTag;

@end

@interface ClientSocket : NSObject<AsyncSocketDelegate>
{
    AsyncSocket* socketClient;
    NSMutableArray* blocks;
}

@property (nonatomic) BOOL isConnected;

- (BOOL)connectIp:(NSString*)ipStr port:(unsigned int)port;

- (void)disconnect;

- (BOOL)isConnect;

- (void)sendData:(NSData*)data;

+ (instancetype)shareManager;

- (void)addBlock:(SocketBlock)block withTag:(NSInteger)tag;

- (void)removeBlockWithTag:(NSInteger)tag;

@end
