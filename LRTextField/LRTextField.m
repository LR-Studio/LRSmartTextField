//
//  LRTextField.m
//  LRTextField
//
//  Created by LR Studio on 7/26/15.
//  Copyright (c) 2015 LR Studio. All rights reserved.
//

#import "LRTextField.h"

#define fontScale 0.7f

@interface LRTextField ()

@property (nonatomic) UILabel *placeholderLabel;
@property (nonatomic) UILabel *hintLabel;

@property (nonatomic, assign) CGFloat placeholderXInset;
@property (nonatomic, assign) CGFloat placeholderYInset;
@property (nonatomic, assign) UIFont *placeholderFont;
@property (nonatomic, strong) CALayer *textLayer;
@property (nonatomic, assign) CGFloat textXInset;
@property (nonatomic, assign) CGFloat textYInset;
@property (nonatomic, strong) ValidationBlock validationBlock;
@property (nonatomic, strong) NSString *temporaryString;

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

- (instancetype) initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if ( !self )
    {
        return nil;
    }
    
    [self commonInit];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( !self )
    {
        return nil;
    }
    
    [self commonInit];
    return self;
}

- (NSString *) rawString
{
    if ( !_format )
    {
        return self.text;
    }
    
    NSMutableString *mutableStr = [NSMutableString stringWithString:self.text];
    for ( NSInteger i = self.text.length - 1; i >= 0; i-- )
    {
        if ( [self.format characterAtIndex:i] != '#' )
        {
            [mutableStr deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    }
    
    return mutableStr;
}

- (void) setText:(NSString *)text
{
    if ( !_format )
    {
        [super setText:text];
        return;
    }
    
    [self renderString:text];
}

- (void) setFormat:(NSString *)format
{
    _format = format;
}

- (void) setEnableAnimation:(BOOL)enableAnimation
{
    _enableAnimation = enableAnimation;
    if ( _enableAnimation )
    {
        self.placeholderLabel.hidden = NO;
    }
    else
    {
        self.placeholderLabel.hidden = YES;
    }
}

- (void) setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    if ( !_placeholderText )
    {
        _placeholderText = placeholder;
    }
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

- (void) setValidationBlock:(ValidationBlock)block
{
    _validationBlock = block;
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
    _placeholderXInset = 0;
    _placeholderYInset = 0;
    _textXInset = 6;
    _textYInset = 0;
    
    _enableAnimation = YES;
    _placeholderTextColor = [UIColor grayColor];
    _hintText = @"hint";
    _hintTextColor = [UIColor grayColor];
    _borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    _borderWidth = 1.0;
    _cornerRadius = 5.0;
    _temporaryString = [[NSString alloc] init];
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
    [self addTarget:self action:@selector(textFieldEdittingDidChangeInternal:) forControlEvents:UIControlEventEditingChanged];
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

- (IBAction) textFieldEdittingDidChangeInternal:(UITextField *)sender
{
    [self runDidChange];
}

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

- (void) sanitizeStrings
{
    NSString * currentText = self.text;
    if ( currentText.length > self.format.length )
    {
        self.text = self.temporaryString;
        return;
    }
    
    [self renderString:currentText];
}

- (void) renderString:(NSString *)raw
{
    NSMutableString * result = [[NSMutableString alloc] init];
    int last = 0;
    for ( int i = 0; i < self.format.length; i++ )
    {
        if ( last >= raw.length )
            break;
        unichar charAtMask = [self.format characterAtIndex:i];
        unichar charAtCurrent = [raw characterAtIndex:last];
        if ( charAtMask == '#' )
        {
            [result appendString:[NSString stringWithFormat:@"%c",charAtCurrent]];
        }
        else
        {
            [result appendString:[NSString stringWithFormat:@"%c",charAtMask]];
            if (charAtCurrent != charAtMask)
                last--;
        }
        last++;
    }
    
    [super setText:result];
    self.temporaryString = self.text;
}

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

- (void) runDidChange
{
    if ( !_format )
    {
        return;
    }
    
    [self sanitizeStrings];
}

- (void) layoutPlaceholderLabel
{
    [self updateHint];
    [self updateLayer];
}

- (void) showPlaceholderLabel
{
    void (^showBlock)() = ^{
        self.placeholderLabel.alpha = 1.0f;
        if ( _enableAnimation )
        {
            self.hintLabel.alpha = 1.0f;
        }
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
    return [self textRectForBounds:bounds];
}

// Override the function to make the placeholder rect move to the bottom.
- (CGRect) placeholderRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
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

- (void) runValidationViewAnimation:(NSDictionary *)validationInfo
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutValidationView:validationInfo];
    } completion:nil];
}

- (CGFloat) getPlaceholderHeight
{
    return self.placeholderYInset + [self defaultFont].lineHeight;
}

@end
