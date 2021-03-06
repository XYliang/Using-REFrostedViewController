//
//  SEBMenuViewController.m
//  商E宝
//
//  Created by 薛银亮 on 16/1/27.
//  Copyright © 2016年 Neighbours. All rights reserved.
//

#import "SEBMenuViewController.h"
#import "LeftCell.h"
#import "LeftObject.h"

@interface SEBMenuViewController()
@property(weak, nonatomic)UIImageView        *headImageView;
/**二维码*/
@property(weak, nonatomic)UIImageView *QRCodeImageView;
@property(weak, nonatomic)UILabel                *nameLabel;
@property(weak, nonatomic)UILabel                *phoneNumberLabel;
@property(strong, nonatomic)NSMutableArray *dataArray;
@property(strong, nonatomic)NSArray              *cellTitles;
@property(strong, nonatomic)NSArray              *cellImages;
@property(strong, nonatomic)NSArray              *blockArray;
@end

@implementation SEBMenuViewController

 static NSString *identifier = @"leftCell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, heightRate(568.0))];
        CGFloat QRCodeImageViewWH = 25;
        CGFloat QRCodeImageViewX = self.tableView.width - QRCodeImageViewWH - weightRate(66.0) - 50.0f;
        CGFloat QRCodeImageViewY = 42;
        NSLog(@"%f,%f",QRCodeImageViewX,QRCodeImageViewY);
        //二维码
        UIImageView *QRCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(QRCodeImageViewX, QRCodeImageViewY, QRCodeImageViewWH, QRCodeImageViewWH)];
        QRCodeImageView.image = LOADResourceIMAGE(@"测试二维码");
        self.QRCodeImageView = QRCodeImageView;
        //头像
        CGFloat imageX = weightRate(80.0);
        CGFloat imageW = 70;
        CGFloat imageH = imageW;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 0, imageW, imageH)];
        imageView.centerY = view.centerY;
        imageView.image = [UIImage imageNamed:@"测试头像"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imageW / 2.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        self.headImageView = imageView;
        //姓名
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + weightRate(54.0), imageView.y + 10.0f, weightRate(50.0), 24)];
        name.text = @"Jim";
        name.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        name.backgroundColor = [UIColor clearColor];
        name.textColor = [UIColor whiteColor];
        [name sizeToFit];
        self.nameLabel = name;
        //电话号码
        UILabel *phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + weightRate(54.0), CGRectGetMaxY(name.frame) + 10.0f, 0, 24)];
        phoneNumber.text = @"13502469015";
        phoneNumber.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        phoneNumber.backgroundColor = [UIColor clearColor];
        phoneNumber.textColor = [UIColor whiteColor];
        [phoneNumber sizeToFit];
        self.phoneNumberLabel = phoneNumber;
        
        view.backgroundColor = [UIColor getColor:@"268ee7"];
        [view addSubview:self.QRCodeImageView];
        [view addSubview:self.headImageView];
        [view addSubview:self.nameLabel];
        [view addSubview:self.phoneNumberLabel];
        view;
    });
    
    self.cellTitles = @[@"实名登记", @"支付设置", @"密码管理", @"消息通知", @"帮助中心", @"关于我们"];
    self.cellImages = @[@"实名登记", @"支付设置", @"密码管理", @"消息通知", @"帮助中心", @"关于我们"];
    //封装左边按钮点击事件
    self.blockArray = @[
                        ^(){

                        },^(){

                        },^(){

                        },^(){

                        },^(){

                        },^(){
//                            [SEBNotificationCenter postNotificationName:@"showUserSettingVC" object:self userInfo:nil];
                        }
                         ];
    [self setupData];
}

-(void)setupData
{
    [self.tableView registerClass:[LeftCell class] forCellReuseIdentifier:identifier];
}


-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
        for (int i=0; i<self.cellImages.count; i++) {
            LeftObject *object = [LeftObject initWithIcon:self.cellImages[i] title:self.cellTitles[i]];
            [_dataArray addObject:object];
        }
    }
    return _dataArray;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LeftCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.leftObject.leftButtonSelectedDone();
    [self.frostedViewController hideMenuViewController];
}

#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.cellImages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftCell *cell = [LeftCell cellWithTableView:tableView];
    cell.leftObject = self.dataArray[indexPath.row];
    cell.leftObject.leftButtonSelectedDone = self.blockArray[indexPath.row];
    return cell;
    
}

@end
