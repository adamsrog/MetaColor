//
//  RAKulerInfoViewController.h
//  RAKulerizer
//
//  Created by Roger Adams on 4/7/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "RAKulerObject.h"
#import "ISColorWheel.h"

#include "RAGlobalDefinitions.h"

@interface RAKulerInfoViewController : UIViewController <ISColorWheelDelegate, UIAlertViewDelegate, UITextFieldDelegate> {

    int selectedSwatchIndex;
    CGFloat dx;
    CGAffineTransform unselectedTransform;
    UITextField *hexEntryTextField;
    
}

@property (nonatomic) ISColorWheel *colorWheel;
@property (nonatomic) RAKulerObject *kuler;

@property (nonatomic) IBOutlet UIView  *swatch1;
@property (nonatomic) IBOutlet UIView  *swatch2;
@property (nonatomic) IBOutlet UIView  *swatch3;
@property (nonatomic) IBOutlet UIView  *swatch4;
@property (nonatomic) IBOutlet UIView  *swatch5;

@property (nonatomic) IBOutlet UISlider *sliderRed;
@property (nonatomic) IBOutlet UISlider *sliderGreen;
@property (nonatomic) IBOutlet UISlider *sliderBlue;

@property (nonatomic) UILabel *themeData;
@property (nonatomic) IBOutlet UILabel *labelHex;
@property (nonatomic) IBOutlet UILabel *labelHSB;
@property (nonatomic) IBOutlet UILabel *labelRed;
@property (nonatomic) IBOutlet UILabel *labelGreen;
@property (nonatomic) IBOutlet UILabel *labelBlue;

@end
