//
//  CQPerson.h
//  OC_KVOExplore
//
//  Created by 刘超群 on 2021/9/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQPerson : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *nickName;
@property (nonatomic, copy, readonly) NSString *mergeName;
@property (nonatomic, strong, readonly) NSMutableArray *testArr;


- (void)reloadName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
