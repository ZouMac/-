//
//  ViewController.m
//  KVO底层实现
//
//  Created by Zou Tan on 2020/7/8.
//  Copyright © 2020 Zou Tan. All rights reserved.
//

#import "ViewController.h"
#import "TZPerson.h"
#import <objc/runtime.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    TZPerson *person1 = [[TZPerson alloc] init];
    person1.name = @"小明";
    TZPerson *person2 = [[TZPerson alloc] init];
    person2.name = @"小明";
    
    NSLog(@"KVO之前 person1的isa：%p  person2的isa：%p", object_getClass(person1), object_getClass(person2));
    NSLog(@"setName: %p  %p", [person1 methodForSelector:@selector(setName:)], [person2 methodForSelector:@selector(setName:)]);
    
    [person1 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    person1.name = @"小李";
    person2.name = @"小李";
    
    NSLog(@"KVO之后 person1的isa：%p  person2的isa：%p", object_getClass(person1), object_getClass(person2));
//setName:方法
    NSLog(@"setName: %p  %p", [person1 methodForSelector:@selector(setName:)], [person2 methodForSelector:@selector(setName:)]);
    
    NSLog(@"KVO之后 person1的isa：%p  NSKVONotifying_TZPerson的isa：%p", object_getClass(person1), object_getClass(object_getClass(person1)));
    Class NSKVONotifying_TZPerson = object_getClass(person1);
    Class metaPerson1Class = object_getClass(object_getClass(person1));
    Class metaPerson2Class = object_getClass(object_getClass(person2));
    
//    class_getSuperclass(NSKVONotifying_TZPerson);
    NSLog(@"");
    
    
}


/**
 # KVO监听前后对象
 ## isa指针变化
 KVO之前 person1：0x100003c48  person2：0x100003c48
 KVO之后 person1：0x600003008bd0  person2：0x100003c48
 - person1 监听前的地址和person2 监听前后的地址一样：person2的isa指向TZPerson
 - person1 监听后的地址发生改变: person1的isa指向NSKVONotifying_TZPerson
 
 1. 可见KVO监听之后，对象的isa指针发生改变，指向了NSKVONotifying_TZPerson对象。
 2. 同时
 
 ## superClass指针变化
 
 
 
 ## set方法发生变化：
 (lldb) p (IMP)0x7fff344dbd62
 (IMP) $0 = 0x00007fff344dbd62 (Foundation`_NSSetObjectValueAndNotify)
 
 (lldb) p (IMP)0x100001150
 (IMP) $1 = 0x0000000100001150 (KVO底层实现`-[TZPerson setName:] at TZPerson.h:15)
 
 KVO监听的对象调用setName时，执行的是Foundation框架下的 NSSetObjectValueAndNotify方法


*/


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id old = change[NSKeyValueChangeOldKey];
    id new = change[NSKeyValueChangeNewKey];
    
//    NSLog(@"change:%@", change);
}

- (void)touchesBeganWithEvent:(NSEvent *)event {
    NSLog(@"");
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
