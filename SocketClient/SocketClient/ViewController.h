//
//  ViewController.h
//  SocketClient
//
//  Created by zhengmiaokai on 2018/9/21.
//  Copyright © 2018年 xiaoniu66. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *longTextField;
@property (weak, nonatomic) IBOutlet UITextField* shortTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendShortBtn;

- (IBAction)connect:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)shortRequest:(id)sender;

@end

