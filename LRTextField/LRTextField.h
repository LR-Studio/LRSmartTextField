//
//  LRTextField.h
//  LRTextField
//
//  Created by Chao on 7/26/15.
//  Copyright (c) 2015 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VALIDATION_SHOW_YES @"YES"
#define VALIDATION_SHOW_NO  @"NO"

@class LRTextField;

typedef NSDictionary *(^ValidationBlock)(LRTextField *textField, NSString *text);

typedef NS_ENUM(NSInteger, LRTextFieldFormatType)
{
    LRTextFieldFormatTypeNone,
    LRTextFieldFormatTypeEmail,
    LRTextFieldFormatTypePhone,
};

typedef NS_ENUM(NSInteger, LRTextFieldEffectStyle)
{
    LRTextFieldEffectStyleUp,
    LRTextFieldEffectStyleRight,
};

IB_DESIGNABLE
@interface LRTextField : UITextField

@property (nonatomic) float *scale;

// String for format
@property (nonatomic,strong) IBInspectable NSString * mask;
@property (nonatomic) IBInspectable BOOL onlyNumber;
// String for raw content
@property (nonatomic,strong) IBInspectable NSString * format;
@property (nonatomic,strong) NSString * raw;
@property (nonatomic,strong) NSString * defaultCharMask;
@property (nonatomic,assign) BOOL disallowEditingBetweenCharacters;

@property (nonatomic, strong) NSString *placeholderText;
@property (nonatomic, strong) UIColor *placeholderTextColor;
@property (nonatomic, strong) NSString *hintText;
@property (nonatomic, strong) UIColor *hintTextColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;

- (instancetype) initWithFormatType:(LRTextFieldFormatType)type;
- (instancetype) initWithEffectStyle:(LRTextFieldEffectStyle)style;
- (instancetype) initWithFormatType:(LRTextFieldFormatType)type effectStyle:(LRTextFieldEffectStyle)style;

- (void) setValidationBlock:(ValidationBlock)block;
- (BOOL)shouldChangeCharactersInRange:(NSRange)range
                    replacementString:(NSString *)string;

@end
