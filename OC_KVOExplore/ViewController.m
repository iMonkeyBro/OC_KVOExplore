//
//  ViewController.m
//  OC_KVOExplore
//
//  Created by 刘超群 on 2021/9/29.
//

#import "ViewController.h"
#import "CQPerson.h"

@interface ViewController ()
@property (nonatomic, strong) CQPerson *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = CQPerson.new;
    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    [self.person addObserver:self forKeyPath:@"kname" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@", keyPath);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 通过公开函数间接调用私有set函数，可以监听到
    [self.person reloadName];
    
    // 通过performSelector 调用私有set函数，可以监听到
    [self.person performSelector:@selector(setName:) withObject:@"1"];
    
    // 通过IMP 调用私有set函数，可以监听到
    SEL sel = NSSelectorFromString(@"setName:");
    IMP imp = [self.person methodForSelector:sel];
    void(*func)(id, SEL, NSString *) = (void *)imp;
    func(self.person, sel, @"1");
    // 简写
    ((void(*)(id, SEL, NSString *))[self.person methodForSelector:sel])(self.person, sel, @"1");
    
    // 通过kvo可以修改私有成员变量，但不会触发KVO
    [self.person setValue:@"1" forKey:@"_kname"];
    
    NSLog(@"%@-%@",self.person.name,self.person.kname);
}

@end
