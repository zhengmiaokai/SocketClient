//
//  JsonDataItem.m
//  SocketClient
//
//  Created by zhengmiaokai on 2018/9/21.
//  Copyright © 2018年 zhengMK. All rights reserved.
//

#import "JsonDataItem.h"

@implementation JsonDataItem

- (void)analysisFrameFormat:(FrameFormat *)frameFormat {
    
     [super analysisFrameFormat:frameFormat];
    
    NSData* data =  frameFormat.bodyData;
    
    NSError* error = nil;
    
   NSDictionary* jsonDic =  [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableLeaves
                                      error:&error];
    
    NSString* msg = [NSString stringWithFormat:@"%@\n%@",[jsonDic.allKeys componentsJoinedByString:@","],
                     [jsonDic.allValues componentsJoinedByString:@","]];
    
    self.data = msg;
}

@end
