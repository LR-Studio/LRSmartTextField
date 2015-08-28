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
    
    LRTextField *textField = [[LRTextField alloc] initWithFrame:CGRectMake(50, 50, 200, 30) labelHeight:15 style:LRTextFieldStyleNone];
    textField.placeholder = @"plAceholDeR";
    textField.hintText = @"hiNt";
    textField.format = @"(###)-##)-";
    textField.placeholderTextColor = [UIColor blueColor];
    [textField setValidationBlock:^NSDictionary *(LRTextField *textField, NSString *text) {
        [NSThread sleepForTimeInterval:1.0];
        return @{ VALIDATION_INDICATOR_YES : @"good" };
    }];
//    textField.enableAnimation = NO;
//    textField.text = @"ab";
//    textField.style = LRTextFieldStylePhone;
//    textField.frame = CGRectMake(100, 100, 200, 200);
    [self.view addSubview:textField];
    
//    LRTextField *textField2 = [[LRTextField alloc] initWithFrame:CGRectMake(50, 100, 100, 50) style:LRTextFieldStylePassword];
//    [self.view addSubview:textField2];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)hideKeyboardPressed:(id)sender {
    [self.view endEditing:YES];
}

@end
