//
//  LRTextField.h
//  LRTextField
//
//  Created by Chao on 7/26/15.
//  Copyright (c) 2015 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

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


- (BOOL)shouldChangeCharactersInRange:(NSRange)range
                    replacementString:(NSString *)string;

@end
