//
//  LRTextField.m
//  LRTextField
//
//  Created by Chao on 7/26/15.
//  Copyright (c) 2015 Chao. All rights reserved.
//

#import "LRTextField.h"

#define fontScale 0.7f

@interface LRTextField ()

@property (nonatomic) UILabel *placeholderLabel;
@property (nonatomic) UILabel *hintLabel;

@property (nonatomic, assign) LRTextFieldFormatType type;
@property (nonatomic, assign) LRTextFieldEffectStyle style;

@property (nonatomic, assign) CGFloat placeholderXInset;
@property (nonatomic, assign) CGFloat placeholderYInset;
@property (nonatomic, assign) UIFont *placeholderFont;
@property (nonatomic, strong) CALayer *textLayer;
@property (nonatomic, assign) CGFloat textXInset;
@property (nonatomic, assign) CGFloat textYInset;
@property (nonatomic, strong) ValidationBlock validationBlock;

@end

@implementation LRTextField

- (instancetype) init
{
    self = [self initWithFrame:CGRectZero];
    if ( !self )
    {
        return nil;
    }
    
    [self commonInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if ( !self )
    {
        return nil;
    }
    _style = LRTextFieldEffectStyleUp;
    [self commonInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( !self )
    {
        return nil;
    }
    
    _style = LRTextFieldEffectStyleUp;
    [self commonInit];
    return self;
}

- (instancetype) initWithFormatType:(LRTextFieldFormatType)type
{
    return [self initWithFormatType:type effectStyle:LRTextFieldEffectStyleUp];
}

- (instancetype) initWithEffectStyle:(LRTextFieldEffectStyle)style
{
    return [self initWithFormatType:LRTextFieldFormatTypeNone effectStyle:style];
}

- (instancetype) initWithFormatType:(LRTextFieldFormatType)type effectStyle:(LRTextFieldEffectStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if ( !self )
    {
        return nil;
    }
    
    _type = type;
    _style = style;
    [self commonInit];
    
    return self;
}

- (void) setValidationBlock:(ValidationBlock)block
{
    _validationBlock = block;
}

- (void) setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    [self updatePlaceholder];
}

- (void) setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText = placeholderText;
    [self updatePlaceholder];
}

- (void) setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    _placeholderTextColor = placeholderTextColor;
    [self updatePlaceholder];
}

- (void) setHintText:(NSString *)hintText
{
    _hintText = hintText;
    [self updateHint];
}

- (void) setHintTextColor:(UIColor *)hintTextColor
{
    _hintTextColor = hintTextColor;
    [self updateHint];
}

- (void) setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self updateLayer];
}

- (void) setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self updateLayer];
}

- (void) setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self updateLayer];
}

- (void) updatePlaceholder
{
    self.placeholderLabel.frame = CGRectMake(self.placeholderXInset, self.placeholderYInset, self.bounds.size.width, [self getPlaceholderHeight]);
    self.placeholderLabel.text = self.placeholderText;
    self.placeholderLabel.textColor = self.placeholderTextColor;
    self.placeholderLabel.font = [self defaultFont];
    self.placeholderLabel.alpha = 0.0f;
}

- (void) updateHint
{
    self.hintLabel.frame = CGRectMake(self.placeholderXInset, self.placeholderYInset, self.bounds.size.width, [self getPlaceholderHeight]);
    self.hintLabel.text = self.hintText;
    self.hintLabel.textColor = self.hintTextColor;
    self.hintLabel.font = [self defaultFont];
    self.hintLabel.textAlignment = NSTextAlignmentRight;
    self.hintLabel.alpha = 0.0f;
}

- (void) updateLayer
{
    self.textLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + [self getPlaceholderHeight], self.bounds.size.width, self.bounds.size.height - [self getPlaceholderHeight]);
    self.textLayer.borderColor = self.borderColor.CGColor;
    self.textLayer.borderWidth = self.borderWidth;
    self.textLayer.cornerRadius = self.cornerRadius;
}

- (void) commonInit
{
    self.placeholderXInset = 0;
    self.placeholderYInset = 0;
    self.textXInset = 6;
    self.textYInset = 0;
    
    self.placeholderText = self.placeholder;
    self.placeholderTextColor = [UIColor grayColor];
    self.hintText = @"hint";
    self.hintTextColor = [UIColor grayColor];
    self.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    self.borderWidth = 1.0;
    self.cornerRadius = 5.0;
    if ( self.bounds.size.height * 0.7 / 2 > 17 )
    {
        super.font = [UIFont systemFontOfSize:17.0f];
    }
    else
    {
        super.font = [UIFont systemFontOfSize:self.bounds.size.height * 0.7 / 2];
    }
    
    
    self.placeholderLabel = [UILabel new];
    self.hintLabel = [UILabel new];
    self.textLayer = [CALayer layer];
    
    [self updatePlaceholder];
    [self updateHint];
    [self updateLayer];
    
    [self addSubview:self.placeholderLabel];
    [self addSubview:self.hintLabel];
    [self.layer addSublayer:self.textLayer];
    
    [self addTarget:self action:@selector(textFieldEdittingDidEndInternal:) forControlEvents:UIControlEventEditingDidEnd];
    [self addTarget:self action:@selector(textFieldEdittingDidBeginInternal:) forControlEvents:UIControlEventEditingDidBegin];
    self.validationBlock = nil;
}

- (IBAction) textFieldEdittingDidBeginInternal:(UITextField *)sender
{
    [self runDidBeginAnimation];
}

- (IBAction) textFieldEdittingDidEndInternal:(UITextField *)sender
{
    [self runDidEndAnimation];
}

// Set default font size.
- (UIFont *) defaultFont
{
    UIFont *font = nil;
    
    if ( self.attributedPlaceholder && self.attributedPlaceholder.length > 0 )
    {
        font = [self.attributedPlaceholder attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    }
    else if ( self.attributedText && self.attributedText.length > 0 )
    {
        font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    }
    else
    {
        font = self.font;
    }
    
    return [UIFont fontWithName:font.fontName size:roundf(font.pointSize * fontScale)];
}


// Format checking
- (BOOL) shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * currentText = [self.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"%@", currentText);
    if (currentText.length > self.format.length)
        return NO;
    NSMutableString * result = [[NSMutableString alloc] init];
    int last = 0;
    for (int i = 0; i < self.format.length; i++){
        if (last >= currentText.length)
            break;
        unichar charAtMask = [_format characterAtIndex:i];
        unichar charAtCurrent = [currentText characterAtIndex:last];
        if (charAtMask == '#'){
            if (self.onlyNumber && !isnumber(charAtCurrent)){
                last++;
                continue;
            }
            [result appendString:[NSString stringWithFormat:@"%c",charAtCurrent]];
        }
        else{
            [result appendString:[NSString stringWithFormat:@"%c",charAtMask]];
            if (charAtCurrent != charAtMask)
                last--;
        }
        last++;
    }
    
    self.text = result;
    return NO;
}

// Set up label frame. The default settings is to make the uplabel align with the placeholder
// Potential alignment need to be paid attention to
- (void) runDidBeginAnimation
{
    [self layoutPlaceholderLabel];
    [self showPlaceholderLabel];
}

- (void) runDidEndAnimation
{
    [self hidePlaceholderLabel];
    if ( self.validationBlock )
    {
        [self validateText];
    }
}

- (void) layoutPlaceholderLabel
{
    if ( self.style == LRTextFieldEffectStyleUp )
    {
        [self updateHint];
        [self updateLayer];
    }
    else if ( self.style == LRTextFieldEffectStyleRight )
    {
        
    }
}

- (void) showPlaceholderLabel
{
    void (^showBlock)() = ^{
        self.placeholderLabel.alpha = 1.0f;
        self.hintLabel.alpha = 1.0f;
    };
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                     animations:showBlock
                     completion:nil];
}

- (void) hidePlaceholderLabel
{
    void (^hideBlock)() = ^{
        self.placeholderLabel.alpha = 0.0f;
        self.hintLabel.alpha = 0.0f;
    };
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                     animations:hideBlock
                     completion:nil];
}

// Override this function to make the editing rect move to the bottom.
- (CGRect) editingRectForBounds:(CGRect)bounds
{
    if ( self.style == LRTextFieldEffectStyleUp )
    {
        return [self textRectForBounds:bounds];
    }
    else if ( self.style == LRTextFieldEffectStyleRight )
    {
        
    }
    
    return CGRectZero;
}

// Override the function to make the placeholder rect move to the bottom.
- (CGRect) placeholderRectForBounds:(CGRect)bounds
{
    if ( self.style == LRTextFieldEffectStyleUp )
    {
        return [self textRectForBounds:bounds];
    }
    else if ( self.style == LRTextFieldEffectStyleRight )
    {
        
    }
    
    return CGRectZero;
}

- (CGRect) textRectForBounds:(CGRect)bounds
{
    return CGRectOffset(bounds, self.textXInset, self.textYInset + [self getPlaceholderHeight] / 2);
}

#pragma mark - Validation
// Run validation function and set textfield.leftview and rightview and show validation results.
- (void) validateText
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *validationInfo = weakSelf.validationBlock(weakSelf, weakSelf.text);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self runValidationViewAnimation:validationInfo];
        });
    });
}

- (void) layoutValidationView:(NSDictionary *)validationInfo
{
    if ( self.style == LRTextFieldEffectStyleUp )
    {
        if ( [validationInfo objectForKey:VALIDATION_SHOW_YES] )
        {
            self.hintLabel.text = [[validationInfo objectForKey:VALIDATION_SHOW_YES] isKindOfClass:[NSString class]] ? [validationInfo objectForKey:VALIDATION_SHOW_YES] : @"";
            self.hintLabel.textColor = [UIColor greenColor];
            self.textLayer.borderColor = [UIColor greenColor].CGColor;
            self.hintLabel.alpha = 1.0f;
        }
        else if ( [validationInfo objectForKey:VALIDATION_SHOW_NO] )
        {
            self.hintLabel.text = [[validationInfo objectForKey:VALIDATION_SHOW_NO] isKindOfClass:[NSString class]] ? [validationInfo objectForKey:VALIDATION_SHOW_NO] : @"";
            self.hintLabel.textColor = [UIColor redColor];
            self.textLayer.borderColor = [UIColor redColor].CGColor;
            self.hintLabel.alpha = 1.0f;
        }
    }
    else if ( self.style == LRTextFieldEffectStyleRight )
    {
        
    }
}

- (void) runValidationViewAnimation:(NSDictionary *)validationInfo
{
    if ( self.style == LRTextFieldEffectStyleUp )
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self layoutValidationView:validationInfo];
        } completion:nil];
    }
    else if ( self.style == LRTextFieldEffectStyleRight )
    {
        
    }
}

- (CGFloat) getPlaceholderHeight
{
    return self.placeholderYInset + [self defaultFont].lineHeight;
}

@end
