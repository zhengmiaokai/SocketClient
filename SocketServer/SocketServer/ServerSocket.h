//
//  ServerSocket.h
//  TeskSocket
//
//  Created by apple on 13-5-24.
//  Copyright (c) 2013年 Kid-mind Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@interface BlockObject: NSObject

@property (nonatomic, strong) void(^block)(NSData* data, AsyncSocket* socket);
@property (nonatomic) NSInteger blockTag;

@end

@interface ServerSocket : NSObject <AsyncSocketDelegate>
{
    AsyncSocket *listenSocket;
    
    NSMutableArray *connectedSockets;
    
    BOOL isRunning;
    
    NSMutableArray* blocks;
}

@property (nonatomic, copy) void(^clientblock)(NSString* string);

@property (nonatomic, copy) void(^shortResponse)(AsyncSocket* socket,NSData *data);


+ (instancetype)sharedManager;

- (void)sendMessageToAll:(NSData*)data;

- (void)startListen:(unsigned int)port;

- (void)stopListen;

- (void)addBlock:(void(^)(NSData* data, AsyncSocket* socket))block withTag:(NSInteger)tag;

- (void)removeBlockWithTag:(NSInteger)tag;

@end
