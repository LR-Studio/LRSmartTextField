//
//  LRTextField.h
//  LRTextField
//
//  Created by LR Studio on 7/26/15.
//  Copyright (c) 2015 LR Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VALIDATION_SHOW_YES @"YES"
#define VALIDATION_SHOW_NO  @"NO"

@class LRTextField;

typedef NSDictionary *(^ValidationBlock)(LRTextField *textField, NSString *text);

IB_DESIGNABLE
@interface LRTextField : UITextField

@property (nonatomic, copy) IBInspectable NSString *text;
@property (nonatomic, strong) IBInspectable NSString *format;
@property (nonatomic, copy, readonly) NSString *rawString;

@property (nonatomic, assign) IBInspectable BOOL enableAnimation;
@property (nonatomic, strong) IBInspectable NSString *placeholderText;
@property (nonatomic, strong) IBInspectable UIColor *placeholderTextColor;

@property (nonatomic, strong) IBInspectable NSString *hintText;
@property (nonatomic, strong) IBInspectable UIColor *hintTextColor;

@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

- (void) setValidationBlock:(ValidationBlock)block;

@end
