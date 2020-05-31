//
//  DataResolve.h
//  CommonFramework
//
//  Created by zhengMK on 15/5/8.
//  Copyright (c) 2015年 zhengMK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BodyEncodeType) {
    BodyEncodeTypeNone = 0,
    BodyEncodeTypeUTF8,
    BodyEncodeTypeJson,
    BodyEncodeTypeHex,
    BodyEncodeTypeURL,
};

/*
 x011  utf-8 NSString
 x022 Json NSString
 x033 16进制数据
 x044 url-encode NSString
 */

@interface FrameFormat : NSObject

@property (nonatomic) Byte startPromp;//起始符
@property (nonatomic) Byte type;     //类型
@property (nonatomic, strong) NSData *bodyData;//数据域
@property (nonatomic) Byte sum;// 校验域
@property (nonatomic) Byte end;//结束符

@end

@interface DataAnalysis : NSObject

@property (nonatomic, strong, readonly) FrameFormat* frameFormat;

@property (nonatomic, strong, readonly) NSData* frameData;

- (void)analysisData:(NSData*)data error:(NSError **)error;

+(NSData *)createBody:(NSData *)body type:(BodyEncodeType)type;

@end


