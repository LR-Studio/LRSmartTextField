//
//  LRTextField.h
//  LRTextField
//
//  Created by Chao on 7/26/15.
//  Copyright (c) 2015 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL (^validationBlock)(NSString *text);

typedef NS_ENUM(NSInteger, LRTextFieldFormatType)
{
    LRTextFieldFormatTypeDefault,
    LRTextFieldFormatTypeEmail,
    LRTextFieldFormatTypePhone,
};

typedef NS_ENUM(NSInteger, LRTextFieldEffectStyle)
{
    LRTextFieldEffectStyleDefault,
    LRTextFieldEffectStyleUp,
    LRTextFieldEffectStyleRight,
};

typedef NS_ENUM(NSInteger, LRTextFieldValidationType)
{
    LRTextFieldValidationTypeDefault,
    LRTextFieldValidationTypeLeft,
    LRTextFieldValidationTypeRight,
    LRTextFieldValidationTypeColor,
};

IB_DESIGNABLE
@interface LRTextField : UITextField <UITextFieldDelegate>


// A label that show placeholder
@property (nonatomic) UILabel * placeholderLabel;
@property (nonatomic) UIButton * validationLabel;

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

//Property for up placeholder events
@property (nonatomic) CGFloat Ypadding;
@property (nonatomic) CGFloat Xpadding;
@property (nonatomic) BOOL withAnimation;
@property (nonatomic) UIColor *placeholderColor;

@property (nonatomic, assign) IBInspectable BOOL enableValidation;

- (instancetype) initWithFormatType:(LRTextFieldFormatType)type;
- (instancetype) initWithEffectStyle:(LRTextFieldEffectStyle)style;
- (instancetype) initWithValidationType:(LRTextFieldValidationType)validationType;
- (instancetype) initWithFormatType:(LRTextFieldFormatType)type effectStyle:(LRTextFieldEffectStyle)style validationType:(LRTextFieldValidationType)validationType;

//proptery for validation event

- (void)setTextValidationBlock:(validationBlock)block
                        isSync:(BOOL)sync;

- (BOOL)shouldChangeCharactersInRange:(NSRange)range
                    replacementString:(NSString *)string;

@end
