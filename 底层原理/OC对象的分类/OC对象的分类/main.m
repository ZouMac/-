//
//  main.m
//  OC对象的分类
//
//  Created by Zou Tan on 2020/6/29.
//  Copyright © 2020 Zou Tan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TZPerson.h"
#import "TZStudent.h"
#import "NSObject+addition.h"



//struct NSObject_IMPL {
//    Class isa;
//};
//
//struct TZPerson_IMPL {
//    struct NSObject_IMPL NSObject_IVARS;
//
//    int age;
//};
//
//struct TZStuden_IMPL {
//    struct TZPerson_IMPL TZPERSON_IVARS;
//    int height;
//};


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        实例对象
        NSObject *object1 = [[NSObject alloc] init];
        NSObject *object2 = [[NSObject alloc] init];
        NSLog(@"instance object %p, %p",
        object1,object2);
//        类对象
        Class objectClass1 = [object1 class];
        Class objectClass2 = [object2 class];
        Class objectClass3 = [NSObject class];
        Class objectClass4 = object_getClass(object1);
        Class objectClass5 = object_getClass(object2);
        
        NSLog(@"class object %p, %p, %p, %p, %p ismetalClass:%hhd",
              objectClass1,objectClass2,objectClass3,objectClass4,objectClass5, class_isMetaClass(objectClass1));
        
//        元类对象
        Class objectMetaClass = object_getClass(objectClass1);
        NSLog(@"meta-class object %p ismetalClass:%hhd",
        objectMetaClass, class_isMetaClass(objectMetaClass));
        
        /*
        
        struct TZStuden_IMPL student;
        student.height = 10;
        
        struct TZPerson_IMPL person;
        person.age = 100;
        */
        
        
        TZStudent *student = [[TZStudent alloc] init];
        [student study];
        
        // 调用类方法时，回到元类中查找类方法，没有找到查找元类的父类，直到元类的基类，此时元类的基类的superclass指针指向的是NSObject的类对象，类对象中的对象方法此时也会被查找，这个正好有这个同名的对象方法，因此会调用该对象方法
        [TZStudent performSelector:@selector(methodFromNSObject)];
         
         
        /*
        ((void (*)(id, SEL))(void *)objc_msgSend)((id)student, sel_registerName("study"));
        ((void (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("TZStudent"), sel_registerName("die"));
        */
    }
    return 0;
}

/*  isa指针
 
 
 
 
 */


/*
 
 # instance
 1. instance 对象在内存存储的信息
 - isa：isa指针继承自NSObject，排在结构体第一位 指向对象的地址
 - 其他成员变量
 
 # class 类对象
 1. -[objc class]  + [NSObject class] object_getClass(),三个方法均是获取objc的实例对象
 
 2. 上述方法获取到的对象是同一个对象，每个类在内存中有且只有一个class类对象
 
 3. class类对象在内存中储存的信息主要包括
 - isa指针，指向元类
 - superClass指针
 - 类的属性信息(@property)、类的对象方法(instance method)
 - 类的协议信息(@protocol)、类的成员变量信息(ivar)(这里指的不是成员变量的值，值是储存在实例对象中，这里是成员变量的类型，名称)
 
 ```
 struct objc_class {
     Class _Nonnull isa  OBJC_ISA_AVAILABILITY;

     Class _Nullable super_class                              OBJC2_UNAVAILABLE;
     const char * _Nonnull name                               OBJC2_UNAVAILABLE;
     long version                                             OBJC2_UNAVAILABLE;
     long info                                                OBJC2_UNAVAILABLE;
     long instance_size                                       OBJC2_UNAVAILABLE;
     struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
     struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
     struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
     struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;

 } OBJC2_UNAVAILABLE;
 ```
 
 # meta class 元类对象
 1. 通过object_getClass()方法获取类对象的isa指针，得到元类对象。
 2. 类对象的isa指针 指向的是元类对象（实例对象的isa指针指向的是类对象）
 3. 每个类再内存中有且只有一个meta-class对象
 4. meta-class和类对象都是Class，他们的结构是一样的，只是用途不一样，在结构体中不需要的成员置为null
 5. 元类对象在内存中储存的主要信息包括：
 - isa指针 指向NSObject的元类对象
 - superClass指针
 - 类的类方法信息
 
 # 三种对象之间的关系
 
 instance                 class                     metaClass
   isa                     isa                         isa
 其他成员变量              superClass                 superClass
                         其他成员变量                 其他成员变量
                          对象方法                     类方法
 
 
 */
