//
//  BodyEncode.h
//  SocketClient
//
//  Created by zhengmiaokai on 2018/9/21.
//  Copyright © 2018年 xiaoniu66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataAnalysis.h"

@protocol BodyEncode

- (void)analysisFrameFormat:(FrameFormat *)frameFormat;

@end

@interface BodyEncode : NSObject <BodyEncode>

@property (nonatomic, strong, readonly) FrameFormat* framFormat;

@property (nonatomic, strong) id data;

@end
