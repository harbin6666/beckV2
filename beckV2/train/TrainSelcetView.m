//
//  TrainSelcetView.m
//  beckV2
//
//  Created by yj on 15/6/14.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "TrainSelcetView.h"
/*
 
 {
 "course": "基础培训班",
 "describe": " ",
 "hour": 200,
 "id": 1,
 "list": [
 {
 "course": "药师",
 "describe": " ",
 "hour": 100,
 "id": 2,
 "list": [
 {
 "course": "专业知识（一）",
 "describe": "包含药理学、药剂学、药物化学、药物分析",
 "hour": 50,
 "id": 3,
 "list": [
 ],
 "money": 1000,
 "training_course_id": 2
 },
 {
 "course": "专业知识（二）",
 "describe": "包含临床药理学和常用药物治疗学",
 "hour": 50,
 "id": 4,
 "list": [
 ],
 "money": 1000,
 "training_course_id": 2
 }
 ],
 "money": 1800,
 "training_course_id": 1
 },
 {
 "course": "中药师",
 "describe": " ",
 "hour": 100,
 "id": 5,
 "list": [
 {
 "course": "中药学专业知识（一）",
 "describe": "包含中药学、中药化学、中药药剂学、中药炮制学、中药药理学、中药鉴定学",
 "hour": 50,
 "id": 6,
 "list": [
 ],
 "money": 1000,
 "training_course_id": 5
 },
 {
 "course": "中药学专业知识（二）",
 "describe": "包含临床中药学、中成药学、方剂学",
 "hour": 50,
 "id": 7,
 "list": [
 ],
 "money": 1000,
 "training_course_id": 5
 }
 ],
 "money": 1800,
 "training_course_id": 1
 }
 ],
 "money": 3600,
 "training_course_id": 0
 },
 */
@implementation TrainSelcetView
-(void)updateWithDic:(NSDictionary*)dic{
    float w=self.frame.size.width;
    float y=0;
    NSArray* list=dic[@"list"];
    for (int i=0; i<list.count; i++) {
        NSDictionary *subdic=list[i];//药师
        NSString *ti=[NSString stringWithFormat:@"%@(全选)¥%@",dic[@"course"],dic[@"money"]];
        UIButton *bu=[UIButton buttonWithType:UIButtonTypeCustom];
        bu.frame=CGRectMake(20, y, 20, 20);
        [bu setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [self addSubview:bu];
        
        UILabel *tit=[[UILabel alloc] initWithFrame:CGRectMake(40, y, w-40-40, 30)];
        tit.text=ti;
        [self addSubview:tit];
        y+=30;
        
        NSArray *subar=subdic[@"list"];
        for (int i=0; i<subar.count; i++) {
            NSDictionary *d=subar[i];
            NSString *ti=[NSString stringWithFormat:@"%@(全选)¥%@",d[@"course"],d[@"money"]];
            UIButton *bu=[UIButton buttonWithType:UIButtonTypeCustom];
            [bu setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
            [self addSubview:bu];
            
            UILabel *tit=[[UILabel alloc] initWithFrame:CGRectMake(20, 430, w-40, 30)];
            tit.text=ti;
            [self addSubview:tit];

        }

    }
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
