//
//  SEBCollectionsController.m
//  商E宝
//
//  Created by 薛银亮 on 15/10/19.
//  Copyright © 2015年 www.30pay.seb. All rights reserved.
//

#import "SEBCollectionsController.h"
#import "SEBInputPasswordView.h"

@interface SEBCollectionsController ()<SEBInputPasswordViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)SEBInputPasswordView *passwordView;
@property (nonatomic,copy)NSString *str;
@end

@implementation SEBCollectionsController

- (void)viewDidLoad {
    [super viewDidLoad];
        _str = @"111111";
}

- (IBAction)didi:(id)sender {
    [self text];
}

-(void)text
{
    __block SEBCollectionsController *blockSelf = self;
    self.passwordView = [SEBInputPasswordView passwordView];
    [self.passwordView showInView:self.view.window];
    self.passwordView.delegate = self;
    self.passwordView.finish = ^(NSString *passWord){
        NSLog(@"  passWord %@ ",passWord);
        [blockSelf.passwordView hidenKeyboard];
        if ([passWord isEqualToString:blockSelf.str]) {
            NSLog(@"密码成功");
            return ;
        }else{
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"支付密码错误" message:nil delegate:blockSelf cancelButtonTitle:@"重试" otherButtonTitles:@"忘记密码", nil];
            [al show];
            NSLog(@"密码错误");
        }
    };
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self text];
        
        NSLog(@" buttonIndex 重试");
    }else if (buttonIndex == 1)
    {
        //        [self.zctView hidenKeyboard];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController *vc = [[UIViewController alloc]init];
            vc.view.backgroundColor = [UIColor redColor];
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@" buttonIndex 忘了密码");
        });
    }
}

-(void)inputPasswordView:(SEBInputPasswordView *)inputPasswordView cancleBtnClick:(UIButton *)cancleBtnClick
{
    NSLog(@"取消");
}



@end