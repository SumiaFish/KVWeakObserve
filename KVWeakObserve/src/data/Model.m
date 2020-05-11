//
//  Model.m
//  KVWeakObserve
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "Model.h"

@implementation BaseModel

- (void)dealloc {
    NSLog(@"%@ dealloc~", NSStringFromClass(self.class));
}

@end

@implementation ModelA

@end

@implementation ModelB

@end
