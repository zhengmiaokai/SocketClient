//
//  DataResolve.m
//  CommonFramework
//
//  Created by zhengMK on 15/5/8.
//  Copyright (c) 2015年 zhengMK. All rights reserved.
//

#import "DataAnalysis.h"

@implementation FrameFormat

@end

@interface DataAnalysis ()

@end

@implementation DataAnalysis

- (void)analysisData:(NSData*)data error:(NSError **)error
{
    if (![self checkParity:data]) {
        
        *error = [NSError errorWithDomain:NSLocalizedFailureReasonErrorKey code:101 userInfo:@{@"reason": @"校验失败"}];
        return;
    }
    else {
        *error = nil;
    }
    
    if (_frameFormat == nil) {
        _frameFormat = [[FrameFormat alloc] init];
    }
    
    Byte* bytes = (Byte*)[_frameData bytes];
    
    NSInteger length = _frameData.length;
    
    _frameFormat.startPromp = bytes[0];
    _frameFormat.type = bytes[1];
    _frameFormat.bodyData = [_frameData subdataWithRange:NSMakeRange(2, length - 4)];
    _frameFormat.sum = bytes[length-2];
    _frameFormat.end = bytes[length-1];
}

- (Byte*)recieveData:(NSData*)data
{
    _frameData = data;
    
    Byte *byte = (Byte*)[data bytes];
    
    /*
    for(int i=0;i<[data length];i++)
    {
        printf("十六进制 = %02x\n",testByte[i]);
        printf("ASCII = %c\n",testByte[i]);
        printf("整数 = %i\n",testByte[i]);
    }
    */
    
    return byte;
}
- (BOOL)checkParity:(NSData*)data
{
    Byte* dataByte = [self recieveData:data];
    
    Byte pack[1];
    
    int sum = 0;
    
    for (int i=0; i<data.length-2; i++) {
        sum ++;
    }
    
    pack[0] = sum;

    if (pack[0] == dataByte[data.length - 2]) {
        return YES;
    }
    
    return NO;
}

#pragma mark -生成字节流
+(NSData *)createBody:(NSData *)body type:(BodyEncodeType)type {
    
    Byte startByte[2] = {0x6c,type&0xff};
    
    NSMutableData* data =  [NSMutableData dataWithBytes:startByte length:1];
    
    [data appendData:body];
    
    int sum=0;
    for (int i=0; i<data.length; i++) {
        sum++;
    }
    
    Byte endByte[2] = {sum&0xff,0x16};
    
    [data appendBytes:endByte length:2];
    
    return data;
}

@end
