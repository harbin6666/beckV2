//
//  ChoiceItem.m
//  beckV2
//
//  Created by yj on 15/6/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "ChoiceItem.h"

@implementation ChoiceItem
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject: _nid forKey:@"nid"];
    [aCoder encodeObject: _choice_id forKey:@"choice_id"];

    [aCoder encodeObject: _item_number forKey:@"item_number"];

    [aCoder encodeObject: _item_content forKey:@"item_content"];

    [aCoder encodeObject: _is_img forKey:@"is_img"];

    [aCoder encodeObject: _is_answer forKey:@"is_answer"];

    [aCoder encodeObject: _memo forKey:@"memo"];

    [aCoder encodeObject: _img_content forKey:@"img_content"];

    
    

}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _nid=[aDecoder decodeObjectForKey:@"nid"];
        _choice_id=[aDecoder decodeObjectForKey:@"choice_id"];
        _item_number=[aDecoder decodeObjectForKey:@"item_number"];
        _item_content=[aDecoder decodeObjectForKey:@"item_content"];
        _is_img=[aDecoder decodeObjectForKey:@"is_img"];
        _is_answer=[aDecoder decodeObjectForKey:@"is_answer"];
        _memo=[aDecoder decodeObjectForKey:@"memo"];
        _img_content=[aDecoder decodeObjectForKey:@"img_content"];

    }
    return self;
}
@end
