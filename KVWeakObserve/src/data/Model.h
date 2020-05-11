//
//  Model.h
//  KVWeakObserve
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject

@end

@interface ModelA : BaseModel

@property (copy, nonatomic) NSString *name;

@end

@interface ModelB : BaseModel

@property (copy, nonatomic) NSString *name;

@end

NS_ASSUME_NONNULL_END
