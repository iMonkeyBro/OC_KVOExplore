//
//  ViewController.m
//  OC_KVOExplore
//
//  Created by 刘超群 on 2021/9/29.
//

#import "ViewController.h"
#import "CQPerson.h"
#import "objc/runtime.h"

#define BFStr(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]
@interface ViewController ()
@property (nonatomic, strong) CQPerson *person;
@property (nonatomic, assign) int touchNumber;  ///< 点击此处
@end

@implementation ViewController

static void *NameContext = &NameContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = CQPerson.new;
    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionPrior context:NameContext];
    [self.person addObserver:self forKeyPath:@"nickName" options:NSKeyValueObservingOptionNew context:NULL];
    [self.person addObserver:self forKeyPath:@"mergeName" options:NSKeyValueObservingOptionNew context:NULL];
    [self.person addObserver:self forKeyPath:@"testArr" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self printClass:self.person.class];
    
}

- (void)printClass:(Class)cls {
    // 注册类的总数
    int count = objc_getClassList(NULL, 0);
    NSMutableArray *mArray = [NSMutableArray array];
    // 获取所有已注册的类
    Class *classes = (Class *)malloc(sizeof(Class)*count);
    objc_getClassList(classes, count);
    for (int i = 0; i<count; i++) {
        if (cls == class_getSuperclass(classes[i])) {
            [mArray addObject:classes[i]];
            [self printClassAllMethod:cls];
        }
    }
    free(classes);
    NSLog(@"class = %@", mArray);
}

- (void)printClassAllMethod:(Class)cls{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        IMP imp = class_getMethodImplementation(cls, sel);
        NSLog(@"%@-%p",NSStringFromSelector(sel),imp);
    }
    free(methodList);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == NameContext) {
        for (NSString *key in change.allKeys) {
            NSLog(@"key-%@   value-%@ ", key,[change valueForKey:key]);
        }
    } else {
        NSLog(@"对象-%@,属性-%@",object, keyPath);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchNumber += 1;
//    [self.person.testArr addObject:@"1"];// 不会触发
//    [[self.person mutableArrayValueForKey:@"testArr"] addObject:@"1"]; // 可以触发

    
    // 通过公开函数间接调用私有set函数，可以监听到
    [self.person reloadName:[NSString stringWithFormat:@"第%d次点击", _touchNumber]];
    
    return;
    
    // 通过performSelector 调用私有set函数，可以监听到
    [self.person performSelector:@selector(setName:) withObject:@"1"];
    
    // 通过IMP 调用私有set函数，可以监听到
    SEL sel = NSSelectorFromString(@"setName:");
    IMP imp = [self.person methodForSelector:sel];
    void(*func)(id, SEL, NSString *) = (void *)imp;
    func(self.person, sel, @"1");
    // 简写
    ((void(*)(id, SEL, NSString *))[self.person methodForSelector:sel])(self.person, sel, @"1");
    
    // 通过kvc直接修改属性名，会触发KVO
    [self.person setValue:@"1" forKey:@"nickName"];
    // 通过kvc直接修改私有成员变量，不会触发KVO
    [self.person setValue:@"100" forKey:@"_nickName"];
    
    NSLog(@"%@-%@",self.person.name,self.person.nickName);
}

- (void)dealloc {
    [self.person removeObserver:self forKeyPath:@"name" context:NameContext];
    [self.person removeObserver:self forKeyPath:@"nickName" context:NULL];
    [self.person removeObserver:self forKeyPath:@"mergeName" context:NULL];
    [self.person removeObserver:self forKeyPath:@"testArr" context:NULL];
}

@end
