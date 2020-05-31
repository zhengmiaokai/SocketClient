//
//  SubDataItem.m
//  CommonFramework
//
//  Created by zhengmiaokai on 15/8/4.
//  Copyright (c) 2015年 zhengMK. All rights reserved.
//

#import "URLEncodeItem.h"

@implementation URLEncodeItem

- (void)analysisFrameFormat:(FrameFormat *)frameFormat {
    
    [super analysisFrameFormat:frameFormat];
    
    NSData* data =  frameFormat.bodyData;
    
    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    self.data = string;
}

@end
