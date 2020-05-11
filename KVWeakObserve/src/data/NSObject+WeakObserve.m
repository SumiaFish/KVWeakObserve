//
//  NSObject+WeakObserve.m
//  KVWeakObserve
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "NSObject+WeakObserve.h"

@interface WeakObserve : NSObject

@property (weak, nonatomic) id beObserver;
@property (weak, nonatomic) id observer;
@property (copy, nonatomic) NSString *keyPath;
@property (assign, nonatomic) BOOL isCallBackInMain;

@end

@implementation WeakObserve

@end

@interface WeakObserveManager : NSObject

@end

@implementation WeakObserveManager
{
    NSMapTable<id, NSPointerArray *> * _map;
}

static WeakObserveManager *instance = nil;
static BOOL WeakObserveManagerAllowInitFlags = false;

+ (instancetype)share {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        WeakObserveManagerAllowInitFlags =  true;
        instance = [[WeakObserveManager alloc] init];
        WeakObserveManagerAllowInitFlags =  false;
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (instancetype)init {
    if (WeakObserveManagerAllowInitFlags) {
        if (self = [super init]) {
            _map = [[NSMapTable alloc] initWithKeyOptions:(NSPointerFunctionsWeakMemory|NSMapTableObjectPointerPersonality) valueOptions:(NSPointerFunctionsStrongMemory|NSMapTableObjectPointerPersonality) capacity:0];
        }
    }
    
    return instance;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSPointerArray *observers = [_map objectForKey:object];
    if (observers) {
        [observers.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:WeakObserve.class]) {
                WeakObserve *wo = obj;
                if (wo.beObserver == object
                    && [wo.keyPath isEqualToString:keyPath]) {
                    if (wo.isCallBackInMain) {
                        if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
                            [wo.observer kv_receiveWeakObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [wo.observer kv_receiveWeakObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
                            });
                        }
                    } else {
                        [wo.observer kv_receiveWeakObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
                    }
                }
            }
        }];
    }
    
}

- (void)kvimp_addWeakObject:(NSObject *)object observe:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context isCallBackInMain:(BOOL)isCallBackInMain {
    NSPointerArray *observers = [_map objectForKey:object];
    if (!observers) {
        observers = [[NSPointerArray alloc] initWithOptions:(NSPointerFunctionsStrongMemory|NSMapTableObjectPointerPersonality)];
        [_map setObject:observers forKey:object];
    }
    
    __block BOOL isExist = NO;
    [observers.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:WeakObserve.class]) {
            WeakObserve *wo = obj;
            if (wo.beObserver == object &&
                wo.observer == observer &&
                [wo.keyPath isEqualToString:keyPath] &&
                wo.isCallBackInMain == isCallBackInMain) {
                isExist = YES;
                *stop = YES;
            }
        }
    }];
    
    if (isExist) {
        return;
    }
    
    WeakObserve *wo = [[WeakObserve alloc] init];
    wo.beObserver = object;
    wo.observer = observer;
    wo.keyPath = keyPath;
    wo.isCallBackInMain = isCallBackInMain;
    [observers addPointer:(__bridge void * _Nullable)wo];
    
    [wo.beObserver addObserver:self forKeyPath:keyPath options:options context:context];
}

@end

@implementation NSObject (WeakObserve)

- (void)kv_addWeakObserve:(NSObject *)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    
    [self kv_addWeakObserve:object keyPath:keyPath options:options context:context isCallBackInMain:NO];
    
}

- (void)kv_addWeakObserve:(NSObject *)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context isCallBackInMain:(BOOL)isCallBackInMain {
    [[WeakObserveManager share] kvimp_addWeakObject:self observe:object forKeyPath:keyPath options:options context:context isCallBackInMain:isCallBackInMain];
}

- (void)kv_receiveWeakObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
        
}

@end
