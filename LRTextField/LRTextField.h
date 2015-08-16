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

typedef NS_ENUM(NSInteger, LRTextFieldValidationType)
{
    LRTextFieldValidationTypeNone,
    LRTextFieldValidationTypeLeft,
    LRTextFieldValidationTypeRight,
    LRTextFieldValidationTypeColor,
};

IB_DESIGNABLE
@interface LRTextField : UITextField


// A label that show placeholder
@property (nonatomic) UILabel * placeholderLabel;

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
@property (nonatomic) BOOL withAnimation;
@property (nonatomic) UIColor *placeholderColor;

/*
 *proptery for validation event
 */

// Validation block, default return YES. User needs to set his own validation logic
typedef BOOL (^ValidationBlock)(NSString *text);
// Whether the validate feature is turned on
@property (nonatomic) IBInspectable BOOL validate;
// To set whether the validation block is running in sync mode or async mode
@property (nonatomic) BOOL sync;
// To set whether the validation block showed on the left or right
@property (nonatomic) BOOL leftvalidation;
//proptery for validation event
- (void)setTextValidationBlock:(validationBlock)block
                        isSync:(BOOL)sync;


@property (nonatomic, assign) IBInspectable BOOL enableValidation;

- (instancetype) initWithFormatType:(LRTextFieldFormatType)type;
- (instancetype) initWithEffectStyle:(LRTextFieldEffectStyle)style;
- (instancetype) initWithValidationType:(LRTextFieldValidationType)validationType;
- (instancetype) initWithFormatType:(LRTextFieldFormatType)type effectStyle:(LRTextFieldEffectStyle)style validationType:(LRTextFieldValidationType)validationType;



- (BOOL)shouldChangeCharactersInRange:(NSRange)range
                    replacementString:(NSString *)string;

@end
