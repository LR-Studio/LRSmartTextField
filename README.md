LRTextField
===========
A subclass of UITextField that supports float label, validation, inputmask, and `IB_DESIGNABLE` (Xcode 6).

### How to install
```
pod 'LRTextField'
```


### USAGE
__Init with code__

![Email](http://i.imgur.com/GDDVduN.gif)
``` objc
    // init with pre-defined style
    LRTextField *textFieldEmail = [[LRTextField alloc] initWithFrame:CGRectMake(20, 70, 260, 30) labelHeight:15 style:LRTextFieldStyleEmail]; 
    [self.view addSubview:textFieldEmail];
```


![Phone](http://i.imgur.com/w20VsY1.gif)
``` objc
    LRTextField *textFieldPhone = [[LRTextField alloc] initWithFrame:CGRectMake(20, 150, 260, 30) labelHeight:15];
    textFieldPhone.placeholder = @"Phone";
    textFieldPhone.hintText = @"(Optional)";
    textFieldPhone.format = @"(###)###-####"; // set format for segment input string
    textFieldPhone.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:textFieldPhone];
```


![Validation](http://i.imgur.com/IiryMXj.gif)
``` objc
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
```


__Init in Storyboard / Xib__

![SB-result](http://i.imgur.com/wCq56nz.gif)

![SB-how](http://i.imgur.com/xz3PuX5.gif)


### CUSTOMIZE
__Color__

![color](http://i.imgur.com/lp2vSfV.gif)

``` objc
    LRTextField *textFieldCustom = [[LRTextField alloc] initWithFrame:CGRectMake(20, 320, 260, 30) labelHeight:15];
    textFieldCustom.placeholder = @"Placeholder";
    textFieldCustom.placeholderActiveColor = [UIColor redColor];
    textFieldCustom.placeholderInactiveColor = [UIColor blackColor];
    textFieldCustom.hintText = @"Purple hint";
    textFieldCustom.hintTextColor = [UIColor purpleColor];
    [self.view addSubview:textFieldCustom];
```

__Disable Animation__

![noanimation](http://i.imgur.com/aBJu8Ol.gif)

``` objc
    textFieldCustom.enableAnimation = NO;
```
### TROUBLESHOOTING
