//
//  CQPerson.h
//  OC_KVOExplore
//
//  Created by 刘超群 on 2021/9/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQPerson : NSObject

@property (nonatomic, strong, readonly) NSString *name;  ///< name
@property (nonatomic, strong, readonly) NSString *kname;  ///< kname

- (void)reloadName;

@end

NS_ASSUME_NONNULL_END
