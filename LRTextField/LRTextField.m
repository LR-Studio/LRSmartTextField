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
@property (nonatomic, strong) ValidationBlock validationBlock;
@property (nonatomic, strong) NSString *temporaryString;

@end

@implementation LRTextField

#pragma mark - Init Method

- (instancetype) init
{
    return [self initWithFrame:CGRectMake(0, 0, 97, 30)];
}

- (instancetype) initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if ( !self )
    {
        return nil;
    }
    
    _style = LRTextFieldStyleNone;
    [self updateUI];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( !self )
    {
        return nil;
    }
    
    _style = LRTextFieldStyleNone;
    _floatingLabelHeight = self.font.pointSize * 0.7 + 1;
    [self updateUI];
    
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame labelHeight:(CGFloat)labelHeight
{
    return [self initWithFrame:frame labelHeight:labelHeight style:LRTextFieldStyleNone];
}

- (instancetype) initWithFrame:(CGRect)frame labelHeight:(CGFloat)labelHeight style:(LRTextFieldStyle)style
{
    self = [super initWithFrame:frame];
    if ( !self )
    {
        return nil;
    }
    
    
    _style = style;
    _floatingLabelHeight = labelHeight;
    [self updateUI];
    
    return self;
}

#pragma mark - Access Method

- (NSString *) rawText
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

- (void) setStyle:(LRTextFieldStyle)style
{
    _style = style;
    [self updateStyle];
}

- (void) setFloatingLabelHeight:(CGFloat)floatingLabelHeight
{
    _floatingLabelHeight = floatingLabelHeight;
    [self updatePlaceholder];
    [self updateHint];
}

- (void) setFormat:(NSString *)format
{
    NSString *tmpString = self.rawText;
    _format = format;
    if ( tmpString )
    {
        [self renderString:tmpString];
    }
}

- (void) setEnableAnimation:(BOOL)enableAnimation
{
    _enableAnimation = enableAnimation;
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

#pragma mark - Override Method

- (CGRect) placeholderRectForBounds:(CGRect)bounds
{
    if ( self.isFirstResponder || self.text.length > 0 || !self.enableAnimation )
    {
        return CGRectMake(self.placeholderXInset, - self.placeholderYInset - self.floatingLabelHeight, bounds.size.width - 2 * self.placeholderXInset, self.floatingLabelHeight);
    }
    return [super textRectForBounds:bounds];
}

#pragma mark - Update Method

- (void) updateUI
{
    [self propertyInit];
    
    self.placeholderLabel = [UILabel new];
    self.hintLabel = [UILabel new];
    
    [self updatePlaceholder];
    [self updateHint];
    
    [self addSubview:self.placeholderLabel];
    [self addSubview:self.hintLabel];
    
    [self addTarget:self action:@selector(textFieldEdittingDidBeginInternal:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textFieldEdittingDidChangeInternal:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textFieldEdittingDidEndInternal:) forControlEvents:UIControlEventEditingDidEnd];

    [self updateStyle];
}

- (void) propertyInit
{
    _placeholderXInset = 0;
    _placeholderYInset = 2;
    
    _enableAnimation = YES;
    _placeholderText = nil;
    _placeholderTextColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    _hintText = nil;
    _hintTextColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    _temporaryString = [NSString string];
    _validationBlock = nil;
    self.clipsToBounds = NO;
    self.borderStyle = UITextBorderStyleRoundedRect;
}

- (void) updatePlaceholder
{
    self.placeholderLabel.frame = [self placeholderRectForBounds:self.bounds];
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.text = self.placeholderText;
    self.placeholderLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    if ( self.isFirstResponder || self.text.length > 0 || !self.enableAnimation )
    {
        self.placeholderLabel.font = [UIFont fontWithDescriptor:[self.font fontDescriptor] size:self.floatingLabelHeight - 1];
        self.placeholderLabel.textColor = self.placeholderTextColor;
    }
}

- (void) updateHint
{
    self.hintLabel.frame = [self placeholderRectForBounds:self.bounds];
    self.hintLabel.font = [UIFont systemFontOfSize:self.floatingLabelHeight - 1];
    self.hintLabel.text = self.hintText;
    self.hintLabel.textColor = self.hintTextColor;
    self.hintLabel.textAlignment = NSTextAlignmentRight;
    self.hintLabel.alpha = 0.0f;
    if ( self.isFirstResponder || self.text.length > 0 || !self.enableAnimation )
    {
        self.hintLabel.alpha = 1.0f;
    }
}

- (void) updateStyle
{
    switch ( self.style )
    {
        case LRTextFieldStyleEmail:
            self.placeholderText = @"Email";
            self.format = nil;
            _validationBlock = ^NSDictionary *(LRTextField *textField, NSString *text) {
                NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
                NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
                if ( ![emailTest evaluateWithObject:text] )
                {
                    return @{ VALIDATION_INDICATOR_NO : @"Invalid Email" };
                }
                return @{};
            };
            break;
        case LRTextFieldStylePhone:
            self.placeholderText = @"Phone";
            self.keyboardType = UIKeyboardTypePhonePad;
            self.format = @"###-###-####";
            _validationBlock = nil;
            break;
        case LRTextFieldStylePassword:
            self.placeholderText = @"Password";
            self.secureTextEntry = YES;
            self.format = nil;
            _validationBlock = nil;
            break;
        default:
            break;
    }
}

#pragma mark - Target Method

- (IBAction) textFieldEdittingDidBeginInternal:(UITextField *)sender
{
    [self runDidBeginAnimation];
}

- (IBAction) textFieldEdittingDidEndInternal:(UITextField *)sender
{
    [self autoFillFormat];
    [self runDidEndAnimation];
}

- (IBAction) textFieldEdittingDidChangeInternal:(UITextField *)sender
{
    [self runDidChange];
}

#pragma mark - Private Method

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

- (void) autoFillFormat
{
    NSMutableString *result = [NSMutableString stringWithString:self.text];
    for ( NSInteger i = self.text.length; i < self.format.length; i++ )
    {
        unichar charAtMask = [self.format characterAtIndex:i];
        if ( charAtMask == '#' )
        {
            return;
        }
        [result appendFormat:@"%c", charAtMask];
    }
    [super setText:result];
    self.temporaryString = self.text;
}

- (void) runDidBeginAnimation
{
    void (^showBlock)() = ^{
        [self updatePlaceholder];
        [self updateHint];
    };
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                     animations:showBlock
                     completion:nil];
}

- (void) runDidEndAnimation
{
    void (^hideBlock)() = ^{
        [self updatePlaceholder];
        self.hintLabel.alpha = 0.0f;
    };
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                     animations:hideBlock
                     completion:nil];
    if ( self.validationBlock && self.text.length > 0 )
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

#pragma mark - Validation

- (void) validateText
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(self.frame.size.width - self.frame.size.height,
                                 0,
                                 self.frame.size.height,
                                 self.frame.size.height);
    [self.layer addSublayer:indicator.layer];
    [indicator startAnimating];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *validationInfo = weakSelf.validationBlock(weakSelf, weakSelf.rawText);
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            [weakSelf.rightView removeFromSuperview];
            weakSelf.rightView = nil;
            [self runValidationViewAnimation:validationInfo];
        });
    });
}

- (void) runValidationViewAnimation:(NSDictionary *)validationInfo
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutValidationView:validationInfo];
    } completion:nil];
}

- (void) layoutValidationView:(NSDictionary *)validationInfo
{
    if ( [validationInfo objectForKey:VALIDATION_INDICATOR_YES] )
    {
        self.hintLabel.text = [[validationInfo objectForKey:VALIDATION_INDICATOR_YES] isKindOfClass:[NSString class]] ? [validationInfo objectForKey:VALIDATION_INDICATOR_YES] : @"";
        self.hintLabel.textColor = [UIColor greenColor];
        self.hintLabel.alpha = 1.0f;
        if ( self.borderStyle != UITextBorderStyleNone )
        {
            self.layer.borderColor = [UIColor greenColor].CGColor;
        }
    }
    else if ( [validationInfo objectForKey:VALIDATION_INDICATOR_NO] )
    {
        self.hintLabel.text = [[validationInfo objectForKey:VALIDATION_INDICATOR_NO] isKindOfClass:[NSString class]] ? [validationInfo objectForKey:VALIDATION_INDICATOR_NO] : @"";
        self.hintLabel.textColor = [UIColor redColor];
        self.hintLabel.alpha = 1.0f;
        if ( self.borderStyle != UITextBorderStyleNone )
        {
            self.layer.borderColor = [UIColor redColor].CGColor;
        }
    }
}

@end
