//
//  ViewController.m
//  LRTextField
//
//  Created by Chao on 7/26/15.
//  Copyright (c) 2015 Chao. All rights reserved.
//

#import "ViewController.h"
#import "LRTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LRTextField *textField = [[LRTextField alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
    textField.placeholderText = @"123456";
    textField.format = @"(###)-##)-";
    [textField setValidationBlock:^NSDictionary *(LRTextField *textField, NSString *text) {
        return @{ VALIDATION_INDICATOR_YES : @"good" };
    }];
//    textField.text = @"ab";
//    textField.style = LRTextFieldStylePhone;
    [self.view addSubview:textField];
    
    LRTextField *textField2 = [[LRTextField alloc] initWithFrame:CGRectMake(50, 100, 100, 50) style:LRTextFieldStylePassword];
    [self.view addSubview:textField2];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
