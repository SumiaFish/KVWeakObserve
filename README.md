# KVWeakObserve


当我们 addObserver 的时候都要 removeObserver；忘记了有可能还会报异常。那我能不能只管 addObserver，我释放了 你就不通知我就行了，我懒得手动 removeObserver。。。
所以今天做了这么一个东西所以自己写了一个不需要 手动解除 观察的 类别 NSObject+WeakObserve.h。

简书地址：
https://www.jianshu.com/p/e7e288cd31c5
