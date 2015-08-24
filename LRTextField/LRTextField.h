//
//  LRTextField.h
//  LRTextField
//
//  Created by LR Studio on 7/26/15.
//  Copyright (c) 2015 LR Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VALIDATION_INDICATOR_YES @"YES"
#define VALIDATION_INDICATOR_NO  @"NO"

@class LRTextField;

typedef NS_ENUM(NSInteger, LRTextFieldStyle)
{
    LRTextFieldStyleEmail,          //Default placeholder: 'Email';   Default validation: email validation regular expression
    LRTextFieldStylePhone,          //Default placeholder: 'Phone';   Default format: '###-###-####'
    LRTextFieldStylePassword,       //Default placeholder: 'Password; Default: secure text entry
    LRTextFieldStyleNone,           //Default style
};

typedef NSDictionary *(^ValidationBlock)(LRTextField *textField, NSString *text);

IB_DESIGNABLE
@interface LRTextField : UITextField

/**
 * Style of text: email, phone, password
 * Default is nil.
 */
@property (nonatomic, assign) LRTextFieldStyle style;

/**
 * Text to be displayed in the text field and masked if format is set.
 * Default is nil.
 */
@property (nonatomic, copy) IBInspectable NSString *text;

/**
 * Mask of input text.
 * Default is nil.
 */
@property (nonatomic, copy) IBInspectable NSString *format;

/**
 * Text without mask.
 * Default is nil.
 */
@property (nonatomic, copy, readonly) NSString *rawText;

/**
 * Indicate whether the floating label animation is enabled.
 * Default is YES.
 */
@property (nonatomic) IBInspectable BOOL enableAnimation;

/**
 * Text to be displayed in the floating placeholder label.
 * Default is the same as placeholder.
 */
@property (nonatomic, copy) IBInspectable NSString *placeholderText;

/**
 * Text color to be applied to floating placeholder text.
 * Default is [UIColor grayColor].
 */
@property (nonatomic, strong) IBInspectable UIColor *placeholderTextColor;

/**
 * Text to be displayed in the floating hint label.
 * Default is nil.
 */
@property (nonatomic, copy) IBInspectable NSString *hintText;

/**
 * Text color to be applied to the floating hint text.
 * Default is [UIColor grayColor].
 */
@property (nonatomic, strong) IBInspectable UIColor *hintTextColor;

/**
 * Border color to be applied to the border of editting area.
 * Default is [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

/**
 * Border width to be applied to the border of editting area.
 * Default is 1.0.
 */
@property (nonatomic) IBInspectable CGFloat borderWidth;

/**
 * Border corner radius to be applied to the border of editting area.
 * Default is 5.0.
 */
@property (nonatomic) IBInspectable CGFloat cornerRadius;

/**
 * Init with style.
 *
 * @param frame The frame of text field
 * @param style The style of text field
 */
- (instancetype) initWithFrame:(CGRect)frame style:(LRTextFieldStyle)style;

/**
 * Set validation block.
 *
 * @param block The block to be applied to validate input text and return valid and invalid output.
 */
- (void) setValidationBlock:(ValidationBlock)block;

@end
