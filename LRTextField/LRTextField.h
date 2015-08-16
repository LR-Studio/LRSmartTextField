//
//  LRTextField.h
//  LRTextField
//
//  Created by Chao on 7/26/15.
//  Copyright (c) 2015 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRTextField;

typedef BOOL (^ValidationBlock)(LRTextField *textField, NSString *text);

typedef NS_ENUM(NSInteger, LRTextFieldFormatType)
{
    LRTextFieldFormatTypeNone,
    LRTextFieldFormatTypeEmail,
    LRTextFieldFormatTypePhone,
};

typedef NS_ENUM(NSInteger, LRTextFieldEffectStyle)
{
    LRTextFieldEffectStyleNone,
    LRTextFieldEffectStyleUp,
    LRTextFieldEffectStyleRight,
};

IB_DESIGNABLE
@interface LRTextField : UITextField

// A label that show placeholder
@property (nonatomic) UILabel *placeholderLabel;
@property (nonatomic) UILabel *hintLabel;

@property (nonatomic) float *scale;

// Variables for format constrains

// String for format
@property (nonatomic,strong) IBInspectable NSString * mask;
@property (nonatomic) IBInspectable BOOL onlyNumber;
// String for raw content
@property (nonatomic,strong) IBInspectable NSString * format;
@property (nonatomic,strong) NSString * raw;
@property (nonatomic,strong) NSString * defaultCharMask;
@property (nonatomic,assign) BOOL disallowEditingBetweenCharacters;

@property (nonatomic) UIColor *placeholderColor;


// Whether the validate feature is turned on
@property (nonatomic) IBInspectable BOOL validate;
//proptery for validation event
- (void) setValidationBlock:(ValidationBlock)block;

- (instancetype) initWithFormatType:(LRTextFieldFormatType)type;
- (instancetype) initWithEffectStyle:(LRTextFieldEffectStyle)style;
- (instancetype) initWithFormatType:(LRTextFieldFormatType)type effectStyle:(LRTextFieldEffectStyle)style;



- (BOOL)shouldChangeCharactersInRange:(NSRange)range
                    replacementString:(NSString *)string;

@end
