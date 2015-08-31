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
    
    LRTextField *textField = [[LRTextField alloc] initWithFrame:CGRectMake(50, 50, 200, 50) labelHeight:15 style:LRTextFieldStyleEmail];
//    textField.placeholder = @"plAceholDeR";
//    textField.hintText = @"hiNt";
//    textField.format = @"(###)-##)-";
    [textField setValidationBlock:^NSDictionary *(LRTextField *textField, NSString *text) {
//        [NSThread sleepForTimeInterval:1.0];
        return @{ VALIDATION_INDICATOR_YES : @"good" };
    }];
//    textField.enableAnimation = NO;
    [self.view addSubview:textField];
    
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
