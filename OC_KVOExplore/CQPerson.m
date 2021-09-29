//
//  CQPerson.m
//  OC_KVOExplore
//
//  Created by 刘超群 on 2021/9/29.
//

#import "CQPerson.h"

@implementation CQPerson

- (instancetype)init {
    if (self = [super init]) {
        _name = @"";
        _kname = @"";
    }
    return self;
}

- (void)setName:(NSString * _Nonnull)name {
    _name = name;
}

- (void)reloadName {
    self.name = @"1";
}

@end
