//
//  ViewController.h
//  LRTextField
//
//  Created by Chao on 7/26/15.
//  Copyright (c) 2015 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRTextField.h"
@interface ViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet LRTextField *test;

@end

