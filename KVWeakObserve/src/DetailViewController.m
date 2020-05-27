//
//  DetailViewController.m
//  KVWeakObserve
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "DetailViewController.h"

#import "NSObject+WeakObserve.h"

#import "Model.h"

@interface DetailViewController ()

@property (strong, nonatomic) ModelA *a;

@end

@implementation DetailViewController

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"detail";
    self.view.backgroundColor = UIColor.whiteColor;

    
    
    [self testMemberVars];
//    [self testUnMemberVars];
    
    
    /**
     总结：
     1.当 observe 一个成员变量的时候
     addObserver 和 kv_addWeakObserve 使用上没什么区别
     
     2.当 obseve 一个非成员变量对象的时候，
     使用 addObserver 观察者(self)被释放的话，会产生野指针？！message sent to deallocated instance
     使用 kv_addWeakObserve 观察者(self)被释放的话，就不会再发送 valueChange事件
     
     
     */
}

- (void)testMemberVars {
    
    _a = ModelA.new;
    _a.name = @"1";
    [_a kv_addWeakObserve:self keyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
//    [_a addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
//    __weak typeof(self) ws = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.a.name = [self.a.name stringByAppendingString:self.a.name];
    });
    
}

- (void)testUnMemberVars {
    
    ModelB *b = [ModelB new];
    b.name = @"1";
    /**
     快速退出没问题
    *** -ModelB dealloc~
    */
    [b kv_addWeakObserve:self keyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil isCallBackInMain:YES];
    /**
     快速退出会有问题
     DetailViewController dealloc
    *** -[DetailViewController retain]: message sent to deallocated instance 0x7fc70542a9e0
    */
//    [b addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        b.name = [b.name stringByAppendingString:b.name];
    });
}

- (void)kv_receiveWeakObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if (object == _a &&
        [keyPath isEqualToString:@"name"]) {
        NSLog(@"a.name = %@, %@", _a.name, NSThread.currentThread);
    }
    
    if ([object isKindOfClass:ModelB.class] &&
        [keyPath isEqualToString:@"name"]) {
        NSLog(@"b.name = %@, %@", ((ModelB *)object).name, NSThread.currentThread);
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == _a &&
        [keyPath isEqualToString:@"name"]) {
        NSLog(@"a.name = %@, %@", _a.name, NSThread.currentThread);
    }
    
    if ([object isKindOfClass:ModelB.class] &&
        [keyPath isEqualToString:@"name"]) {
        NSLog(@"b.name = %@, %@", ((ModelB *)object).name, NSThread.currentThread);
    }
}

- (IBAction)buttonAction:(id)sender {
    
    
    
}

@end
