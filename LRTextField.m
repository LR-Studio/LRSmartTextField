//
//  LRTextField.m
//  LRTextField
//
//  Created by Chao on 7/26/15.
//  Copyright (c) 2015 Chao. All rights reserved.
//

#import "LRTextField.h"

@interface LRTextField ()
@property (nonatomic) UIFont *placeholderFont;

@end

@implementation LRTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    [self commonInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self commonInit];
    return self;
}

- (void) commonInit{
    self.Xpadding = 0;
    self.Ypadding = 0;
    self.withAnimation = YES;
    self.placeholderLabel = [UILabel new];
    self.placeholderLabel.alpha = 0.0f;
    [self addSubview:self.placeholderLabel];
    self.placeholderColor = [UIColor grayColor];
    // some basic default fonts/colors
    self.placeholderLabel.textColor = self.placeholderColor;
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.font = [self defaultFont];
}

- (UIFont *)defaultFont
{
    UIFont *font = nil;
    
    if (self.attributedPlaceholder && self.attributedPlaceholder.length > 0)
        font = [self.attributedPlaceholder attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    else if (self.attributedText && self.attributedText.length > 0)
        font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    else
        font = self.font;
    
    return [UIFont fontWithName:font.fontName size:roundf(font.pointSize * 0.7f)];
}


// Format checking
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
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

// Override this function to add precise subviews.
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setLabelUpAnimation];
}

// Set up label frame. The default settings is to make the uplabel align with the placeholder
// Potential alignment need to be paid attention to
- (void) setLabelUpAnimation{
    CGRect rect = [self textRectForBounds:self.bounds];
    CGFloat originX = rect.origin.x;
    if (self.textAlignment == NSTextAlignmentCenter){
        originX = originX + (rect.size.width / 2) - (self.placeholderLabel.frame.size.width / 2);
    }
    else if ( self.textAlignment == NSTextAlignmentRight){
        originX = originX + rect.size.width - self.placeholderLabel.frame.size.width;
    }
    
    CGSize uplableSize = [self.placeholderLabel sizeThatFits:self.placeholderLabel.superview.bounds.size];
    self.placeholderLabel.frame = CGRectMake(self.Xpadding + originX,
                                             self.Ypadding + self.placeholderLabel.frame.origin.y,
                                             uplableSize.width,
                                             uplableSize.height);
    
    if (self.isFirstResponder)
        [self showLabel];
    else
        [self hideLabel];
    
    
}

// Show label.
- (void) showLabel{
    void (^showBlock)() = ^{
        self.placeholderLabel.alpha = 1.0f;
    };
    if (self.withAnimation){
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:showBlock
                         completion:nil];
    }
    else
        showBlock();
}

// Hide lable.
- (void) hideLabel{
    void (^hideBlock)() = ^{
        self.placeholderLabel.alpha = 0.0f;
    };
    if (self.withAnimation){
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:hideBlock
                         completion:nil];
    }
    else
        hideBlock();
}

// Override this function to make the editing rect move to the bottom.
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    CGFloat top = self.bounds.size.height - rect.size.height;
    return CGRectIntegral(CGRectMake(rect.origin.x, rect.origin.y + top, rect.size.width, rect.size.height));
}

// Override the function to make the placeholder rect move to the bottom.
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect rect = [super editingRectForBounds:bounds];
    CGFloat top = self.bounds.size.height - rect.size.height;
    return CGRectIntegral(CGRectMake(rect.origin.x, rect.origin.y + top, rect.size.width, rect.size.height));
    
}

@end
