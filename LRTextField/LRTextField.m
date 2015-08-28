//
//  LRTextField.m
//  LRTextField
//
//  Created by LR Studio on 7/26/15.
//  Copyright (c) 2015 LR Studio. All rights reserved.
//

#import "LRTextField.h"

#define fontScale 0.7f
#define fontOffset 1

@interface LRTextField ()

@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic) UILabel *placeholderLabel;
@property (nonatomic) UILabel *hintLabel;

@property (nonatomic, assign) CGFloat placeholderXInset;
@property (nonatomic, assign) CGFloat placeholderYInset;
@property (nonatomic, strong) ValidationBlock validationBlock;
@property (nonatomic, strong) NSString *temporaryString;

@property (nonatomic, strong) UIColor *validationGreen;
@property (nonatomic, strong) UIColor *validationRed;

@end

@implementation LRTextField

#pragma mark - Init Method

- (instancetype) init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype) initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if ( !self )
    {
        return nil;
    }
    
    _style = LRTextFieldStyleNone;
    _floatingLabelHeight = self.font.pointSize * fontScale + fontOffset;
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
    _floatingLabelHeight = self.font.pointSize * fontScale + fontOffset;
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

- (void) setFont:(UIFont *)font
{
    [super setFont:font];
    self.floatingLabelHeight = font.pointSize * fontScale + fontOffset;
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

//- (void) setPlaceholderText:(NSString *)placeholderText
//{
//    _placeholderText = placeholderText;
//    [self updatePlaceholder];
//}

- (void) setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:nil];
    _placeholderText = placeholder;
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
    if ( self.isEditing || self.text.length > 0 || !self.enableAnimation )
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
    self.placeholder = self.placeholder;
    _placeholderTextColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    _hintText = nil;
    _hintTextColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    _temporaryString = [NSString string];
    _validationBlock = nil;
    self.clipsToBounds = NO;
    self.borderStyle = UITextBorderStyleRoundedRect;
    
    _validationGreen = [UIColor colorWithRed:35.0/255.0 green:199.0/255.0 blue:90.0/255.0 alpha:1.0];
    _validationRed = [UIColor colorWithRed:225.0/255.0 green:51.0/255.0 blue:40.0/255.0 alpha:1.0];
    [self initLayer];
}

- (void) updatePlaceholder
{
    self.placeholderLabel.frame = [self placeholderRectForBounds:self.bounds];
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.text = self.placeholderText;
    if ( self.isEditing || self.text.length > 0 || !self.enableAnimation )
    {
        self.placeholderLabel.font = [UIFont fontWithDescriptor:[self.font fontDescriptor] size:self.floatingLabelHeight - fontOffset];
        self.placeholderLabel.transform = CGAffineTransformMakeScale(0.7, 0.7);
    }else
    {
        self.placeholderLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
    
    if (self.isEditing)
    {
        self.placeholderLabel.textColor = self.placeholderTextColor;
    }
    else
    {
        self.placeholderLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    }
}

- (void) updateHint
{
    self.hintLabel.frame = [self placeholderRectForBounds:self.bounds];
    self.hintLabel.font = [UIFont systemFontOfSize:self.floatingLabelHeight - fontOffset];
    self.hintLabel.text = self.hintText;
    self.hintLabel.textColor = self.hintTextColor;
    self.hintLabel.textAlignment = NSTextAlignmentRight;
    self.hintLabel.alpha = 0.0f;
    if ( self.isEditing || self.text.length > 0 || !self.enableAnimation )
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
    [self showBorderWithColor:[UIColor clearColor]];
    
    if ( self.text.length > 0 )
    {
        void (^showBlock)() = ^{
            self.placeholderLabel.textColor = self.placeholderTextColor;
            [self updateHint];
        };
        [UIView transitionWithView:self.placeholderLabel
                          duration:0.3f
                           options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve
                        animations:showBlock
                        completion:nil];
    }
    else
    {
        void (^showBlock)() = ^{
            [self updatePlaceholder];
            [self updateHint];
        };
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:showBlock
                         completion:nil];
    }
    
}

- (void) runDidEndAnimation
{
    if ( self.text.length > 0 )
    {
        void (^hideBlock)() = ^{
            self.placeholderLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
        };
        [UIView transitionWithView:self.placeholderLabel
                          duration:0.3f
                           options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve
                        animations:hideBlock
                        completion:nil];
        
        if ( self.validationBlock )
        {
            [self validateText];
        }
    }
    else
    {
        void (^hideBlock)() = ^{
            [self updatePlaceholder];
            self.hintLabel.alpha = 0.0f;
        };
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:hideBlock
                         completion:nil];
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
    if ( [validationInfo objectForKey:VALIDATION_INDICATOR_YES] )
    {
        [self showBorderWithColor:_validationGreen];
    }else if ( [validationInfo objectForKey:VALIDATION_INDICATOR_NO] )
    {
        [self showBorderWithColor:_validationRed];
    }
}

- (void) layoutValidationView:(NSDictionary *)validationInfo
{

    if ( [validationInfo objectForKey:VALIDATION_INDICATOR_YES] )
    {
        self.hintLabel.text = [[validationInfo objectForKey:VALIDATION_INDICATOR_YES] isKindOfClass:[NSString class]] ? [validationInfo objectForKey:VALIDATION_INDICATOR_YES] : @"";
        self.hintLabel.textColor = _validationGreen;
        self.hintLabel.alpha = 1.0f;
    }
    else if ( [validationInfo objectForKey:VALIDATION_INDICATOR_NO] )
    {
        self.hintLabel.text = [[validationInfo objectForKey:VALIDATION_INDICATOR_NO] isKindOfClass:[NSString class]] ? [validationInfo objectForKey:VALIDATION_INDICATOR_NO] : @"";
        self.hintLabel.textColor = _validationRed;
        self.hintLabel.alpha = 1.0f;
    }
}

- (void) initLayer
{
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 6.0f;
    self.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void) showBorderWithColor:(UIColor*)color
{
    CABasicAnimation *showColorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    showColorAnimation.fromValue = (__bridge id)(self.layer.borderColor);
    showColorAnimation.toValue = (__bridge id)(color.CGColor);
    showColorAnimation.duration = 0.3;
    [self.layer addAnimation:showColorAnimation forKey:@"borderColor"];
    self.layer.borderColor = color.CGColor;
}

@end
