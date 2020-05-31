//
//  ViewController.m
//  SocketClient
//
//  Created by zhengmiaokai on 2018/9/21.
//  Copyright © 2018年 xiaoniu66. All rights reserved.
//

#import "ViewController.h"
#import "ClientSocket.h"
#import "ShortSocket.h"
#import "BodyEncode.h"

@interface ViewController ()

@property (nonatomic) NSInteger controlTag;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.controlTag = 123456789;
    
    [self setState:NO];
    
    [[ClientSocket shareManager] addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    [[ClientSocket shareManager] addBlock:^(BOOL isSuccess, id data) {
        
        if (isSuccess) {
            BodyEncode* bodyEncode = (BodyEncode *)data;
            
            [self showMessege:bodyEncode.data];
        }
    } withTag:self.controlTag];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)dealloc
{
    [[ClientSocket shareManager] removeBlockWithTag:self.controlTag];
    [[ClientSocket shareManager] removeObserver:self forKeyPath:@"isConnected"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"isConnected"]) {
        [self setState:[ClientSocket shareManager].isConnected];
    }
}

- (void)setState:(BOOL)isConnected{
    if (isConnected == NO) {
        _longTextField.hidden = YES;
        _sendBtn.hidden = YES;
        _ipTextField.hidden = NO;
        _connectBtn.hidden = NO;
    }
    else{
        _longTextField.hidden = NO;
        _sendBtn.hidden = NO;
        _ipTextField.hidden = YES;
        _connectBtn.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connect:(id)sender {
    if ([ClientSocket shareManager].isConnect == YES) {
        [self showMessege:@"已连接"];
    }
    else
        [[ClientSocket shareManager] connectIp:_ipTextField.text port:8888];
    
    [self hideKeyword];
}

- (IBAction)send:(id)sender {
    if ([[ClientSocket shareManager] isConnect])
    {
        [[ClientSocket shareManager] sendData:[_longTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        [[ClientSocket shareManager] connectIp:_ipTextField.text port:8888];
    }
    
    [self hideKeyword];
}

- (IBAction)shortRequest:(id)sender {
    ShortSocket *request = [[ShortSocket alloc] initWithConnectIp:_ipTextField.text port:8888];
    
    Byte bytes[2] = {0xaa,0x55};
    
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:2];
    
    [data appendData:[_shortTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.bodyData = data;
    
    __weak ViewController* weakSelf = self;
    
    [request setSuccess:^(NSData* data) {
        
        NSString* messegeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [weakSelf showMessege:messegeStr];
    }];
    
    [request setFailure:^(NSError *error) {
        
    }];
    
    [request startRequest];
}

- (void)hideKeyword{
    [_longTextField resignFirstResponder];
    [_ipTextField resignFirstResponder];
    [_shortTextField resignFirstResponder];
}

- (void)showMessege:(NSString*)msg {
    [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}


@end
