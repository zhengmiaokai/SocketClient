//
//  ClientSocket.m
//  CommonFramework
//
//  Created by zhengMK on 15/5/3.
//  Copyright (c) 2015年 zhengMK. All rights reserved.
//

#import "ClientSocket.h"
#import "DataAnalysis.h"
#import "BodyEncode.h"

@implementation BlockObject

@end

@interface ClientSocket () {
    AsyncSocket* socketClient;
    NSMutableArray* blocks;
    NSDictionary* decoders;
}
@end

@implementation ClientSocket

- (instancetype)init {
    self = [super init];
    if (self) {
        decoders = @{[NSString stringWithFormat:@"%hhu", (Byte)(BodyEncodeTypeUTF8&0xff)] : @"URLEncodeItem",
                     [NSString stringWithFormat:@"%hhu", (Byte)(BodyEncodeTypeJson&0xff)] : @"JsonDataItem",
                     [NSString stringWithFormat:@"%hhu", (Byte)(BodyEncodeTypeHex&0xff)] : @"HexadecimalItem" };
        socketClient = [[AsyncSocket alloc] initWithDelegate:self];
        blocks = [NSMutableArray array];
    }
    return self;
}

- (void)addBlock:(SocketBlock)block withTag:(NSInteger)tag {
    BlockObject* blockObject = [[BlockObject alloc] init];
    blockObject.block = block;
    blockObject.blockTag = tag;
    [blocks addObject:blockObject];
}

- (void)removeBlockWithTag:(NSInteger)tag {
    for (int i=0; i<blocks.count; i++) {
        BlockObject* blockObject = [blocks objectAtIndex:i];
        if (blockObject.blockTag == tag) {
            [blocks removeObject:blockObject];
            break;
        }
    }
}


+ (instancetype)shareManager {
    static dispatch_once_t once;
    static ClientSocket* clientSocket = nil;
    dispatch_once(&once, ^{
        clientSocket = [[ClientSocket alloc] init];
    });
    return clientSocket;
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

- (BOOL)isConnect{
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

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    NSData* contentData = [data subdataWithRange:NSMakeRange(0, data.length - 2)];
    
    DataAnalysis* analysiser = [[DataAnalysis alloc] init];
    
    NSError* error =  nil;
    
    [analysiser analysisData:contentData error:&error];
    
    BOOL isSuccess = (error ? NO : YES);
    
    id result = nil;
    
    if (isSuccess) {
        NSString* decoderClassName = [decoders objectForKey:[NSString stringWithFormat:@"%hhu", analysiser.frameFormat.type]];
        
        BodyEncode *bodyEncode = (BodyEncode *)[[NSClassFromString(decoderClassName) alloc] init];
        
        [bodyEncode analysisFrameFormat:analysiser.frameFormat];
        
        result = bodyEncode;
    } else {
        result = error;
    }
    
    for (int i=0; i<blocks.count; i++) {
        BlockObject* blockObject = blocks[i];
        blockObject.block(error?NO:YES, result);
    }
    
    [sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    NSLog(@"断开连接");
    
    self.isConnected = NO;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    
    [sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
    
    self.isConnected = YES;
    
    NSLog(@"连接成功");
}

@end
