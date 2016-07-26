//
//  ViewController.m
//  KeyValueObserving
//
//  Created by JiangWang on 16/7/26.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "Salary.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

@property (nonatomic, strong) Salary *salary;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self instantiateSalaryAndObserve];
}


- (void)instantiateSalaryAndObserve {
    Salary *sa = [[Salary alloc] initWithNewValue:6000 oldValue:7000];
    
    self.salary = sa;
    
    [sa addObserver:self forKeyPath:@"theNewValueToBeObserved" options:NSKeyValueObservingOptionNew context:NULL];
    [sa addObserver:self forKeyPath:@"oldValueToBeObserved" options:NSKeyValueObservingOptionOld context:NULL];
    [sa addObserver:self forKeyPath:@"array" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark - key value observing methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"theNewValueToBeObserved"]) {
        
        self.displayLabel.text = [NSString stringWithFormat:@"Salary监听的新值是：%f", [change[@"new"] floatValue]];
    }else if ([keyPath isEqualToString:@"oldValueToBeObserved"]) {
        self.displayLabel.text = [NSString stringWithFormat:@"Salary监听的旧值是：%f", [change[@"old"] floatValue]];
    }else {
        // the array has been changed;
        
        NSLog(@"the new array after change: %@", change[@"new"]);
    }
}

- (IBAction)changeValue:(UIButton *)sender {
    
    if ([[sender currentTitle] isEqualToString:@"改变New Value"]) {
        
        self.salary.theNewValueToBeObserved += 500;
        
    }else {
        
        self.salary.oldValueToBeObserved += 500;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.salary.array = @[@"test"];
}

@end
