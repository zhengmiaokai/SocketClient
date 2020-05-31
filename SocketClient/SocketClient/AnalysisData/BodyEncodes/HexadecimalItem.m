//
//  HexadecimalItem.m
//  CommonFramework
//
//  Created by zhengmiaokai on 15/8/4.
//  Copyright (c) 2015年 zhengMK. All rights reserved.
//

#import "HexadecimalItem.h"

@implementation HexadecimalItem

- (void)analysisFrameFormat:(FrameFormat *)frameFormat {
    
     [super analysisFrameFormat:frameFormat];
    
    Byte* bytes = (Byte*)[frameFormat.bodyData bytes];
    
    NSMutableString* mString = [NSMutableString string];
    
    for (int i=0; i<frameFormat.bodyData.length; i++)
    {
        if (i < 3) {
            [mString appendFormat:@"%i%@",bytes[i],i!=2?@":":@""];
        }
        else{
            switch (i) {
                case 3:
                    [mString appendFormat:@" 20%d年",bytes[i]];
                    break;
                case 4:
                    [mString appendFormat:@"%02d月",bytes[i]];
                    break;
                case 5:
                    [mString appendFormat:@"%02d日",bytes[i]];
                    break;
                    
                default:
                    break;
            }
        }
        
    }
    NSLog(@"time:====%@",mString);
    self.data = mString;
}

@end
