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
    
    LRTextField *textFieldEmail = [[LRTextField alloc] initWithFrame:CGRectMake(20, 70, 260, 30) labelHeight:15 style:LRTextFieldStyleEmail]; // init with pre-defined style
    [self.view addSubview:textFieldEmail];
    
    LRTextField *textFieldPhone = [[LRTextField alloc] initWithFrame:CGRectMake(20, 150, 260, 30) labelHeight:15];
    textFieldPhone.placeholder = @"Phone";
    textFieldPhone.hintText = @"(Optional)";
    textFieldPhone.format = @"(###)###-####"; // set format for segment input string
    textFieldPhone.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:textFieldPhone];

    LRTextField *textFieldValidation = [[LRTextField alloc] initWithFrame:CGRectMake(20, 240, 260, 30) labelHeight:15];
    textFieldValidation.placeholder = @"Validation Demo";
    textFieldValidation.hintText = @"Enter \"abc\"";
    [textFieldValidation setValidationBlock:^NSDictionary *(LRTextField *textField, NSString *text) {
        [NSThread sleepForTimeInterval:1.0];
        if ([text isEqualToString:@"abc"]) {
            return @{ VALIDATION_INDICATOR_YES : @"Correct" };
        }
        return @{ VALIDATION_INDICATOR_NO : @"Error" };
    }];
    [self.view addSubview:textFieldValidation];
    
    LRTextField *textFieldCustom = [[LRTextField alloc] initWithFrame:CGRectMake(20, 320, 260, 30) labelHeight:15];
    textFieldCustom.placeholder = @"Placeholder";
    textFieldCustom.placeholderActiveColor = [UIColor redColor];
    textFieldCustom.placeholderInactiveColor = [UIColor blackColor];
    textFieldCustom.hintText = @"Purple hint";
    textFieldCustom.hintTextColor = [UIColor purpleColor];
    textFieldCustom.enableAnimation = NO;
    [self.view addSubview:textFieldCustom];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)hideKeyboardPressed:(id)sender
{
    [self.view endEditing:YES];
}

@end
