//
//  Train3VC.m
//  beckV2
//
//  Created by yj on 15/6/14.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "Train3VC.h"
#import "SelectionPan.h"
#import "DXPopover.h"
//#import <AlipaySDK/AlipaySDK.h>
#import "AlipayObj.h"
#import "payRequsestHandler.h"
#import "WechatObj.h"
@interface Train3VC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,WXApiDelegate>
{
    NSMutableString *debugInfo;
}
@property(nonatomic,strong)NSArray *citys;//{"city": "武汉市","id": 172},
@property(nonatomic,strong)NSArray *list;
@property(nonatomic,strong)NSDictionary *currentDic;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,assign)NSInteger selectSection;
@property(nonatomic,strong)NSDictionary *selectDic,*selectCity;
@property(nonatomic,strong)NSMutableArray *sectionImgs;
@property(nonatomic,strong)UITextField *tf1,*tf2;
@property(nonatomic,strong)UIButton *cityb;
@property(nonatomic,strong)UILabel *cityLab;
@property(nonatomic,strong)DXPopover*popover;
@end

@implementation Train3VC
static NSString *partid=@"2088811668420352";
static NSString *seller=@"whbyxxjs@126.com";
static NSString *privatekey=@"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALgAvOnODGVfBT7rk7xcpLLnpJaMJjuxbVuuplFdje8c5MYbsyiic/6HCuXiPi185X6kLdNrhn4qTjkY6BagvzxzV+31oJyy+92OnkQEG7qqCJZZjvcHr2FYocQXK9N6U02PYw5/SGHRdMnVqEwDar8IMiv956W89oLO7rR84CcLAgMBAAECgYBj99KrXE0Tzjo1YxwS3GqG4J9lQ6OKDu2RQCQQVLnGTXZlw6rkys4mXQwotXB+mjq9QUm8cdDSPv3cu5Fsqcz7iNtMwwrsqxVwWBJeLJ1QVY5iRdHff0epQJaJRFnUf2e18Teg2Cupp9v/uyss+ovvLS4zFT6VrbGSy1EylsycoQJBAODrm1OmSBQ1RBoO1LShQ3nd55pcKWIMl4nrrWX1QSFqfKR9SMnwCm23c/QSXTdgp7bt4MBhF5x6cdupItY85vkCQQDRbbS6VtJ8GxVs5A6WEk6ssFtJRTMhQ2tCgv+8a97o574HzbqqkjTEWB7T48hrfPxvGDREBw8cIgvh262iNusjAkEAq2G7lEyipYtE3hoo543tjWGRxWOuQMDZg0UqdgMf4qdyXB/+o6idOabM2tBXaQfkI5Y0aEJTLG98bGT/X4E+eQJANTJfsOFy79FVXOaFCfu2fkkBtxfbx/w/F5L88NiZs6GB9Kt+WetvedxEYGBAvYTu/i0wwYLlhKjlScaqUUUP7wJAJBI74DxPsJDl+A1E6xE1+c8kVP+Y62P20fIiDfETIVD3HT3rkYW2tl9MM1N3V8LJviTqafGP2rVRJFcbCeBueQ==";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"报名";
    self.sectionImgs=[[NSMutableArray alloc] init];
    __block UIScrollView *scroll=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    scroll.userInteractionEnabled=YES;
    [self.view addSubview:scroll];
    UIImageView *im=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scroll.frame.size.width, 218)];
    im.image=[UIImage imageNamed:@"trainhead"];
    im.userInteractionEnabled=YES;
    [scroll addSubview:im];
    [WXApi registerApp:kWXAPP_ID];
   float w= self.view.frame.size.width;
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake((w-254)/2, 220, 100, 20)];
    lab.text=@"在线报名";
    lab.textColor=BeckRed;
    lab.font=[UIFont boldSystemFontOfSize:18];
    [scroll addSubview:lab];
    
    self.tf1=[[UITextField alloc] initWithFrame:CGRectMake((w-254)/2, 250, 254, 30)];
    self.tf1.placeholder=@"姓名";
    self.tf1.delegate=self;
    self.tf1.tintColor=[UIColor blackColor];
    self.tf1.returnKeyType=UIReturnKeyDone;
    self.tf1.background=[UIImage imageNamed:@"traintf"];
    [scroll addSubview:self.tf1];
    
    self.tf2=[[UITextField alloc] initWithFrame:CGRectMake((w-254)/2, 290, 254, 30)];
    self.tf2.tintColor=[UIColor blackColor];
    self.tf2.placeholder=@"电话";
    self.tf2.delegate=self;
    self.tf2.returnKeyType=UIReturnKeyDone;
    self.tf2.background=[UIImage imageNamed:@"traintf"];
    [scroll addSubview:self.tf2];


    self.cityb=[UIButton buttonWithType:UIButtonTypeCustom];
    self.cityb.frame=CGRectMake((w-254)/2, 330, 254, 30);
    [self.cityb setTitle:@"校区:" forState:UIControlStateNormal];
    self.cityb.titleLabel.textAlignment=NSTextAlignmentLeft;
    [self.cityb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cityb addTarget:self action:@selector(cityClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cityb setBackgroundImage:[UIImage imageNamed:@"traincity"] forState:UIControlStateNormal];
    self.cityb.backgroundColor=[UIColor yellowColor];
    [scroll addSubview:self.cityb];
    
    
    UILabel *lab2=[[UILabel alloc] initWithFrame:CGRectMake((w-254)/2, 370, 100, 20)];
    lab2.text=@"选择科目";
    lab2.textColor=BeckRed;
    lab2.font=[UIFont boldSystemFontOfSize:18];
    [scroll addSubview:lab2];
    scroll.contentSize=CGSizeMake(self.view.frame.size.width, 1000);

   __block SelectionPan *pan=[[SelectionPan alloc] initWithFrame:CGRectMake(20, 400, w-40, 50)];
    [scroll addSubview:pan];
    
    self.table=[[UITableView alloc] initWithFrame:CGRectMake(0, 460, w, 1000-460) style:UITableViewStylePlain];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.scrollEnabled=NO;
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [scroll addSubview:self.table];
    
    UIView *foot=[[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 50)];
    
    UIButton *cancle=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancle setBackgroundImage:[UIImage imageNamed:@"traincancel"] forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    cancle.frame=CGRectMake(w/4-60, 8, 120, 33);
    [foot addSubview:cancle];
    
    UIButton *ok=[UIButton buttonWithType:UIButtonTypeCustom];
    [ok setBackgroundImage:[UIImage imageNamed:@"trainok"] forState:UIControlStateNormal];
    ok.frame=CGRectMake(w*3/4-60, 8, 120, 33);
    [ok addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];

    [foot addSubview:ok];

    self.table.tableFooterView=foot;
    [self showLoading];
    WEAK_SELF;
    [self getValueWithBeckUrl:@"/front/trainingCourseAct.htm" params:@{@"token":@"list"} CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        if (anError==nil) {
            if ([aResponseObject[@"errorcode"] integerValue]==0) {
                self.citys=aResponseObject[@"city"];
                self.list=aResponseObject[@"list"];
                NSMutableArray *ar=[NSMutableArray array];
                [ar addObject:[self.list[0] valueForKey:@"course"]];
                [ar addObject:[self.list[1] valueForKey:@"course"]];
                    [pan updatePanWithTitles:ar selectBlock:^(NSInteger buttonIndex) {
                        [self.sectionImgs removeAllObjects];
                        self.selectSection=0;
                        self.selectDic=nil;
                        self.currentDic=self.list[buttonIndex];
                        [self.table reloadData];
                    }];
                self.currentDic=self.list[0];
                [self.table reloadData];

            }
        }
    }];
}

-(void)cityClick:(UIButton*)b{
   NSInteger count= self.citys.count;
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, count*30)];
    for (int i=0; i<count; i++) {
        UIButton *bu=[UIButton buttonWithType:UIButtonTypeCustom];
        bu.frame=CGRectMake(0, i*30, 100, 30);
        [bu addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
        NSDictionary*d=self.citys[i];
        bu.tag=i;
        [bu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bu setTitle:d[@"city"] forState:UIControlStateNormal];
        [v addSubview:bu];
    }
    self.popover=[DXPopover popover];
    [self.popover showAtView:b withContentView:v];
}

-(void)selectCity:(UIButton*)b{

    self.selectCity=self.citys[b.tag];
    [self.cityb setTitle:self.selectCity[@"city"] forState:UIControlStateNormal];

    [self.popover dismiss];
}



-(void)payWithAlipay{
    [self showLoading];
    NSNumber *courseid=self.selectDic[@"id"];
    [self getValueWithBeckUrl:@"/front/orderTrainingAct.htm" params:@{@"token":@"add",@"loginName":[Global sharedSingle].loginName,@"trainingCourseId":courseid,@"userName":self.tf1.text,@"userPhone":self.tf2.text,@"cityId":self.selectCity[@"id"]} CompleteBlock:^(id aResponseObject, NSError *anError) {
        [self hideLoading];
        if (anError==nil) {
            NSString *code=aResponseObject[@"orderSn"];//orderSn值传给支付宝 out_trade_no这个字段  支付宝异步url：/front/notifyUrlAct.htm
          [[AlipayObj sharedSingle] sendPayProduct:self.selectDic[@"course"] price:[NSString stringWithFormat:@"%@",self.selectDic[@"money"]] orderNum:code Block:^(NSDictionary *aResponseDic) {
                    NSNumber *paystatus=aResponseDic[@"resultStatus"];
                    if (paystatus.integerValue==9000) {
                        [[OTSAlertView alertWithMessage:@"支付成功" andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
                            [self back];
                        }] show];
                    }else if (paystatus.integerValue==6001){
    
                    }else{
                        [[OTSAlertView alertWithMessage:aResponseDic[@"memo"] andCompleteBlock:nil] show];
                    }

            }];
        
        
        }
    }];
}
-(void)payWx{
    NSNumber *courseid=self.selectDic[@"id"];
    [self getValueWithBeckUrl:@"/front/orderTrainingAct.htm" params:@{@"token":@"add",@"loginName":[Global sharedSingle].loginName,@"trainingCourseId":courseid,@"userName":self.tf1.text,@"userPhone":self.tf2.text,@"cityId":self.selectCity[@"id"]} CompleteBlock:^(id aResponseObject, NSError *anError) {
        if (anError==nil&&[aResponseObject[@"errorcode"] integerValue]==0) {
            NSString *price=[NSString stringWithFormat:@"%zd",[self.selectDic[@"money"] integerValue]*100];
            [[WechatObj sharedSingle] sendPayProduct:self.selectDic[@"course"] price:price orderNum:aResponseObject[@"orderSn"] Block:^(BaseResp* aResponseObject) {
                if ([aResponseObject isKindOfClass:[PayResp class]]) {
                    PayResp *re=(PayResp*)aResponseObject;
                    if (re.errCode==0) {
                        [[OTSAlertView alertWithMessage:@"支付成功" andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }] show];
                    }
                }
            }];
        }
    }];

}


- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self payWithAlipay];
    }else{
        [self payWx];
    }
}
-(void)click{
    if (self.selectCity==nil) {
        [[OTSAlertView alertWithMessage:@"请选择校区" andCompleteBlock:nil] show];
        return;
    }
    if (self.selectDic==nil) {
        [[OTSAlertView alertWithMessage:@"请选择" andCompleteBlock:nil] show];
        
    }else{
        if (self.tf1.text.length==0||self.tf2.text.length==0) {
            [[OTSAlertView alertWithMessage:@"请输入姓名及电话" andCompleteBlock:nil] show];
            return;
        }
        if ([[Global sharedSingle] loginName]==nil) {
            [self showlogin];
            return;
        }
        UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝支付",@"微信支付", nil];
        [sheet showInView:self.view];
    }
    
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *ar=self.currentDic[@"list"];
    return ar.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic=self.currentDic[@"list"][section];
    NSArray *ar=dic[@"list"];
    return ar.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dic=self.currentDic[@"list"][section];
    
    UITableViewCell*cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self.selectSection-10==section) {
        cell.imageView.image=[UIImage imageNamed:@"check_sel"];
    }else{
        cell.imageView.image=[UIImage imageNamed:@"check"];

    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=[NSString stringWithFormat:@"%@(全选)¥%@",dic[@"course"],dic[@"money"]];
    UIButton*b=[UIButton buttonWithType:UIButtonTypeCustom];
    b.frame=cell.bounds;
    b.tag=100+section;
    [b addTarget:self action:@selector(selectRow:) forControlEvents:UIControlEventTouchUpInside];
    b.backgroundColor=[UIColor clearColor];
    [cell addSubview:b];
    cell.imageView.tag=section;
    [self.sectionImgs addObject:cell.imageView];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSDictionary *dic=self.currentDic[@"list"][indexPath.section];
    NSArray *ar=dic[@"list"];
    NSDictionary *subdic=ar[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@ %@ ¥%@",subdic[@"course"],subdic[@"describe"],subdic[@"money"]];
    cell.textLabel.numberOfLines=0;
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.textLabel.textColor=[UIColor lightGrayColor];
    
    if (self.selectSection==indexPath.section+10) {
        cell.imageView.image=[UIImage imageNamed:@"check_sel"];
    }else{
        cell.imageView.image=[UIImage imageNamed:@"check"];

    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
//    UIButton*b=[UIButton buttonWithType:UIButtonTypeCustom];
//    b.frame=cell.bounds;
//    [b addTarget:self action:@selector(selectRow:) forControlEvents:UIControlEventTouchUpInside];
//    b.tag=10+indexPath.section;
//    b.backgroundColor=[UIColor yellowColor];
//    [cell addSubview:b];
    return cell;
    
}

-(void)selectRow:(UIButton*)b{
    self.selectSection=b.tag-100+10;
    self.selectDic=self.currentDic[@"list"][self.selectSection-10];


    for (UIImageView * img in self.sectionImgs) {
        if (img.tag==b.tag-100) {
            img.image=[UIImage imageNamed:@"check_sel"];
        }else{
            img.image=[UIImage imageNamed:@"check"];
        }
    }
    [self.table reloadData];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectSection=0;
    NSDictionary *dic=self.currentDic[@"list"][indexPath.section];
    NSArray *ar=dic[@"list"];
    self.selectDic=ar[indexPath.row];
    [tableView reloadData];
   UITableViewCell* cell= [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image=[UIImage imageNamed:@"check_sel"];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
