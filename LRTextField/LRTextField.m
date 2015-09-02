//
//  LRTextField.m
//  LRTextField
//
//  Created by LR Studio on 7/26/15.
//  Copyright (c) 2015 LR Studio. All rights reserved.
//

#import "LRTextField.h"

@interface LRTextField ()

@property (nonatomic) UILabel *placeholderLabel;
@property (nonatomic) UILabel *hintLabel;

@property (nonatomic, assign) CGFloat placeholderXInset;
@property (nonatomic, assign) CGFloat placeholderYInset;
@property (nonatomic, strong) ValidationBlock validationBlock;
@property (nonatomic, strong) NSString *temporaryString;
@property (nonatomic, copy) NSString *placeholderText;

@property (nonatomic, strong) UIColor *validationYesColor;
@property (nonatomic, strong) UIColor *validationNoColor;

@end

@implementation LRTextField

#pragma mark - Init Method

- (instancetype) init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame labelHeight:frame.size.height / 2];
}

- (instancetype) initWithFrame:(CGRect)frame labelHeight:(CGFloat)labelHeight
{
    return [self initWithFrame:frame labelHeight:labelHeight style:LRTextFieldStyleNone];
}

- (instancetype) initWithFrame:(CGRect)frame labelHeight:(CGFloat)labelHeight style:(LRTextFieldStyle)style
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        _style = style;
        _floatingLabelHeight = labelHeight;
        self.borderStyle = UITextBorderStyleRoundedRect;
        [self updateUI];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if ( self )
    {
        _style = LRTextFieldStyleNone;
        _floatingLabelHeight = self.frame.size.height / 2;
        [self updateUI];
        self.placeholder = self.placeholder;
    }
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
    [self autoFillFormat];
}

- (void) setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
    self.hintLabel.font = font;
    [self updatePlaceholder];
    [self updateHint];
}

- (void) setStyle:(LRTextFieldStyle)style
{
    _style = style;
    [self updateStyle];
}

- (void) setBorderStyle:(UITextBorderStyle)borderStyle
{
    [super setBorderStyle:borderStyle];
    [self initLayer];
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
        [self autoFillFormat];
    }
}

- (void) setEnableAnimation:(BOOL)enableAnimation
{
    _enableAnimation = enableAnimation;
    [self updatePlaceholder];
    [self updateHint];
}

- (void) setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:nil];
    _placeholderText = placeholder;
    [self updatePlaceholder];
}

- (void) setPlaceholderActiveColor:(UIColor *)placeholderActiveColor
{
    _placeholderActiveColor = placeholderActiveColor;
    [self updatePlaceholder];
}

- (void) setPlaceholderInactiveColor:(UIColor *)placeholderInactiveColor
{
    _placeholderInactiveColor = placeholderInactiveColor;
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

- (void) setValidationBlock:(ValidationBlock)block
{
    _validationBlock = block;
    [self initLayer];
}

#pragma mark - Update Method

- (void) updateUI
{
    [self propertyInit];
    
    self.placeholderLabel = [UILabel new];
    self.placeholderLabel.font = self.font;
    
    self.hintLabel = [UILabel new];
    self.hintLabel.font = self.font;
    
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
    //set up default values for view
    _placeholderXInset = 0;
    _placeholderYInset = 1;
    
    _enableAnimation = YES;
    _placeholderInactiveColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    _placeholderActiveColor = self.tintColor;
    _hintText = nil;
    _hintTextColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    _temporaryString = [NSString string];
    _validationBlock = nil;
    self.clipsToBounds = NO;
    
    //set color for validation text
    _validationYesColor = [UIColor colorWithRed:35.0/255.0 green:199.0/255.0 blue:90.0/255.0 alpha:1.0];
    _validationNoColor = [UIColor colorWithRed:225.0/255.0 green:51.0/255.0 blue:40.0/255.0 alpha:1.0];
    
    //init layer.borderColor for validation
    [self initLayer];
}

- (void) updatePlaceholder
{
    self.placeholderLabel.text = self.placeholderText;
    //Label shown over the textfield
    if ( self.isEditing || self.text.length > 0 || !self.enableAnimation )
    {
        CGFloat scale = _floatingLabelHeight / self.font.lineHeight;
        self.placeholderLabel.transform = CGAffineTransformMakeScale(scale, scale);
        self.placeholderLabel.frame = [self floatingLabelUpperFrame];
    }else
    {
        //Label shown the same as placeholder
        self.placeholderLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.placeholderLabel.frame = [super textRectForBounds:self.bounds];
    }
    
    if ( self.isEditing )
    {
        self.placeholderLabel.textColor = self.placeholderActiveColor;
    }
    else
    {
        self.placeholderLabel.textColor = self.placeholderInactiveColor;
    }
}

- (void) updateHint
{
    self.hintLabel.text = self.hintText;
    self.hintLabel.textColor = self.hintTextColor;
    CGFloat scale = _floatingLabelHeight / self.font.lineHeight;
    self.hintLabel.transform = CGAffineTransformMakeScale(scale, scale);
    self.hintLabel.frame = [self floatingLabelUpperFrame];
    self.hintLabel.textAlignment = NSTextAlignmentRight;
    if ( self.isEditing || self.text.length > 0 || !self.enableAnimation )
    {
        self.hintLabel.alpha = 1.0f;
    }
    else
    {
        self.hintLabel.alpha = 0.0f;
    }
}

- (void) updateStyle
{
    switch ( self.style )
    {
        case LRTextFieldStyleEmail:
            self.placeholder = @"Email";
            self.format = nil;
            self.validationBlock = ^NSDictionary *(LRTextField *textField, NSString *text) {
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
            self.placeholder = @"Phone";
            self.keyboardType = UIKeyboardTypePhonePad;
            self.format = @"(###)###-####";
            break;
        case LRTextFieldStylePassword:
            self.placeholder = @"Password";
            self.secureTextEntry = YES;
            break;
        default:
            break;
    }
}

#pragma mark - Target Method

- (IBAction) textFieldEdittingDidBeginInternal:(UITextField *)sender
{
    [self showBorderWithColor:[UIColor clearColor]];
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
    if ( self.text.length > 0 || !_enableAnimation)
    {
        void (^showPlaceholderBlock)() = ^{
            self.placeholderLabel.textColor = self.placeholderActiveColor;
        };
        
        void (^showHintBlock)() = ^{
            self.hintLabel.text = self.hintText;
            self.hintLabel.textColor = self.hintTextColor;
            self.hintLabel.alpha = 1.0f;
        };
        
        [UIView transitionWithView:self.placeholderLabel
                          duration:0.3f
                           options:UIViewAnimationOptionBeginFromCurrentState
                                 | UIViewAnimationOptionTransitionCrossDissolve
                        animations:showPlaceholderBlock
                        completion:nil];
        
        [UIView transitionWithView:self.hintLabel
                          duration:0.3f
                           options:UIViewAnimationOptionBeginFromCurrentState
         | UIViewAnimationOptionTransitionCrossDissolve
                        animations:showHintBlock
                        completion:nil];
    }
    else
    {
        
        void (^showBlock)() = ^{
            [self updatePlaceholder];
            self.hintLabel.text = self.hintText;
            self.hintLabel.alpha = 1.0f;
        };
        [UIView animateWithDuration:0.3f animations:showBlock];
    }
}

- (void) runDidEndAnimation
{
    if ( self.text.length > 0 || !_enableAnimation)
    {
        if ( self.validationBlock )
        {
            [self validateText];
        }
        
        void (^hideBlock)() = ^{
            self.placeholderLabel.textColor = self.placeholderInactiveColor;
        };
        [UIView transitionWithView:self.placeholderLabel
                          duration:0.3f
                           options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve
                        animations:hideBlock
                        completion:nil];
    }
    else
    {
        void (^hideBlock)() = ^{
            [self updatePlaceholder];
            [self updateHint];
        };
        [UIView animateWithDuration:0.3 animations:hideBlock];
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
    [UIView transitionWithView:self.hintLabel duration:0.3f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self layoutValidationView:validationInfo];
    } completion:nil];
    
    if ( [validationInfo objectForKey:VALIDATION_INDICATOR_YES] )
    {
        [self showBorderWithColor:_validationYesColor];
    }else if ( [validationInfo objectForKey:VALIDATION_INDICATOR_NO] )
    {
        [self showBorderWithColor:_validationNoColor];
    }
}

- (void) layoutValidationView:(NSDictionary *)validationInfo
{

    if ( [validationInfo objectForKey:VALIDATION_INDICATOR_YES] )
    {
        self.hintLabel.text = [[validationInfo objectForKey:VALIDATION_INDICATOR_YES] isKindOfClass:[NSString class]] ? [validationInfo objectForKey:VALIDATION_INDICATOR_YES] : @"";
        self.hintLabel.textColor = _validationYesColor;
        self.hintLabel.alpha = 1.0f;
    }
    else if ( [validationInfo objectForKey:VALIDATION_INDICATOR_NO] )
    {
        self.hintLabel.text = [[validationInfo objectForKey:VALIDATION_INDICATOR_NO] isKindOfClass:[NSString class]] ? [validationInfo objectForKey:VALIDATION_INDICATOR_NO] : @"";
        self.hintLabel.textColor = _validationNoColor;
        self.hintLabel.alpha = 1.0f;
    }
}

- (void) initLayer
{
    switch ( self.borderStyle )
    {
        case UITextBorderStyleRoundedRect:
            self.layer.borderWidth = 1.0f;
            self.layer.cornerRadius = 6.0f;
            self.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        case UITextBorderStyleLine:
            self.layer.borderWidth = 1.0f;
            self.layer.cornerRadius = 0.0f;
            self.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        case UITextBorderStyleBezel:
            self.layer.borderWidth = 2.0f;
            self.layer.cornerRadius = 0.0f;
            self.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        case UITextBorderStyleNone:
            self.layer.borderWidth = 0.0f;
            break;
        default:
            break;
    }
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

- (CGRect) floatingLabelUpperFrame
{
    return CGRectMake(self.placeholderXInset, - self.placeholderYInset - self.floatingLabelHeight, self.bounds.size.width - 2 * self.placeholderXInset, self.floatingLabelHeight);
}

@end
