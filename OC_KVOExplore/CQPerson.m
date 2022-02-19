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
        _name = @"-";
        _nickName = @"-";
        _testArr = [NSMutableArray array];
    }
    return self;
}


- (void)setName:(NSString * _Nonnull)name {
    [self willChangeValueForKey:@"name"];
    _name = name;
    [self didChangeValueForKey:@"name"];
}

- (void)reloadName:(NSString *)name {
    self.name = name;
    // 通过公开函数间接修改私有变量，不会触发KVO
    _nickName = @"1";
}

//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//    return NO;
//}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
//    if ([key isEqualToString:@"mergeName"]) {
//        NSArray *affectingKeys = @[@"name", @"nickName"];
//        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
//    }
    return keyPaths;
}

@end
