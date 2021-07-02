//
//  ServerSocket.m
//  TeskSocket
//
//  Created by apple on 13-5-24.
//  Copyright (c) 2013年 Kid-mind Studios. All rights reserved.
//

#import "ServerSocket.h"

@implementation BlockObject

@end

@implementation ServerSocket

- (void)sendMessageToAll:(NSData*)data
{
    for (AsyncSocket * s in connectedSockets)
    {
        [s writeData:data withTimeout:-1 tag:0];
    }
}

- (void)startListen:(unsigned int)port
{
    if (!isRunning)
    {
        NSError *error = nil;
        [listenSocket acceptOnPort:port error:&error];
        if (error == nil)
            isRunning = YES;
        else
            isRunning = NO;
        
    }
}

- (void)addBlock:(void(^)(NSData* data,AsyncSocket* socket))block withTag:(NSInteger)tag{
    BlockObject* blockObject = [[BlockObject alloc] init];
    blockObject.block = block;
    blockObject.blockTag = tag;
    [blocks addObject:blockObject];
}

- (void)removeBlockWithTag:(NSInteger)tag{
    for (int i=0; i<blocks.count; i++) {
        BlockObject* blockObject = [blocks objectAtIndex:i];
        if (blockObject.blockTag == tag) {
            [blocks removeObject:blockObject];
            break;
        }
    }
}

- (void)stopListen
{
    if (isRunning)
    {
        [listenSocket disconnect];
        
        for (AsyncSocket *socket in connectedSockets)
        {
            [socket disconnect];
        }
        
        isRunning = NO;
    }
}

+ (instancetype)sharedManager{
    static dispatch_once_t once;
    static ServerSocket* serverSockert = nil;
    dispatch_once(&once, ^{
        serverSockert = [[ServerSocket alloc] init];
        
    });
    return serverSockert;
}

- (id)init {
    self = [super init];
    if (self)
    {
        listenSocket = [[AsyncSocket alloc] initWithDelegate:self];
        
        connectedSockets = [[NSMutableArray alloc] initWithCapacity:1];
        
        [listenSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        
        isRunning = NO;
        
        blocks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [listenSocket disconnect];
    listenSocket.delegate = nil;
    
    for (AsyncSocket *s in connectedSockets)
    {
        [s disconnect];
    }
}

#pragma mark - AsyncSocketDelegate

/*socket断开连接后被调用，你调用disconnect方法，还没有断开连接，只有调用这个方法时，才断开连接；可以在这个方法中release 一个 socket*/
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    [connectedSockets removeObject:sock];
    
    [self setIPInformation];
}

/*监听到新连接时被调用，这个新socket的代理和listen socket相同*/
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    [connectedSockets addObject:newSocket];
//    NSLog(@"host:%@,port:%i",newSocket.localHost,newSocket.localPort);//服务器主机，端口信息
//    NSLog(@"host:%@,port:%i",newSocket.connectedHost,newSocket.connectedPort);//客户端主机，端口信息
}

/**
 * Called when a new socket is spawned to handle a connection.  This method should return the run-loop of the
 * thread on which the new socket and its delegate should operate. If omitted, [NSRunLoop currentRunLoop] is used.
 **/

- (void)setIPInformation
{
    if (_clientblock)
    {
        NSMutableString* string = [NSMutableString string];
        
        for (int i=0; i<connectedSockets.count; i++)
        {
            AsyncSocket* socket = [connectedSockets objectAtIndex:i];
            [string appendFormat:@"host:%@ port:%i\n",socket.connectedHost,socket.connectedPort];
        }
        _clientblock(string);
    }
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [self setIPInformation];
    
    [sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    for (int i=0; i<blocks.count; i++) {
        BlockObject* blockObject = blocks[i];
        blockObject.block(data, sock);
    }

    [sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
    NSLog(@"Server didReadPartialDataOfLength = %lu",(unsigned long)partialLength);
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
}

- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
    NSLog(@"Server didWritePartialDataOfLength = %lu",(unsigned long)partialLength);
}
@end
