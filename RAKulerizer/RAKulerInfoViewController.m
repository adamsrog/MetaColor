//
//  RAKulerInfoViewController.m
//  RAKulerizer
//
//  Created by Roger Adams on 4/7/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import "RAKulerInfoViewController.h"

@interface RAKulerInfoViewController ()

@end

#pragma mark - View Methods

@implementation RAKulerInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_DARK;
    
    [self configureToolbar];
    [self configureGestures];
    [self configureSliders];
    [self configureFonts];
    
    // set up navigation bar
    [self.navigationItem setTitle:self.kuler.themeTitle];
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBarButtonPressed:)];
    NSDictionary *barButtonAppearance = @{UITextAttributeFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0],
                                          UITextAttributeTextColor:[UIColor blackColor],
                                          UITextAttributeTextShadowColor:[UIColor whiteColor]};
    [saveBarButton setTitleTextAttributes:barButtonAppearance forState:UIControlStateNormal];
    saveBarButton.tintColor = METACOLOR_GREEN;
    self.navigationItem.rightBarButtonItem = saveBarButton;
    
    // set up color wheel based on screen size
    self.colorWheel = [[ISColorWheel alloc] init];
    self.themeData = [[UILabel alloc] init];
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        self.colorWheel.frame = CGRectMake(0, 0, 220, 220);
        self.colorWheel.center = CGPointMake(self.view.frame.size.width/2, 330);
        self.themeData.frame = CGRectMake(20, 246, 280, 200);
    } else {
        self.colorWheel.frame = CGRectMake(0, 0, 160, 160);
        self.colorWheel.center = CGPointMake(self.view.frame.size.width - self.colorWheel.frame.size.width, 285);
        self.themeData.frame = CGRectMake(20, 216, 280, 173);
    }
    
    self.colorWheel.delegate = self;
    self.colorWheel.continuous = YES;
    [self.view addSubview:self.colorWheel];
    
    // set up themeData label
    self.themeData.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    self.themeData.textColor = [UIColor whiteColor];
    self.themeData.backgroundColor = [UIColor clearColor];
    self.themeData.numberOfLines = 6;
    NSString *data = [NSString stringWithFormat:@"%@\n%@ (%@)\nTags: %@\nRating: %i  Downloads: %i\nPublished: %@", self.kuler.themeTitle, self.kuler.themeAuthorLabel, self.kuler.themeAuthorID, self.kuler.themeTags, self.kuler.themeRating, self.kuler.themeDownloadCount, self.kuler.themePublishDate];
    self.themeData.text = data;
    self.themeData.alpha = 0.0;
    [self.view addSubview:self.themeData];
    
    // set tags (used when dragging swatches)
    self.swatch1.tag = 1;
    self.swatch2.tag = 2;
    self.swatch3.tag = 3;
    self.swatch4.tag = 4;
    self.swatch5.tag = 5;
    
    // set swatch colors
    self.swatch1.backgroundColor = self.kuler.themeSwatch1.colorRGBFromHex;
    self.swatch2.backgroundColor = self.kuler.themeSwatch2.colorRGBFromHex;
    self.swatch3.backgroundColor = self.kuler.themeSwatch3.colorRGBFromHex;
    self.swatch4.backgroundColor = self.kuler.themeSwatch4.colorRGBFromHex;
    self.swatch5.backgroundColor = self.kuler.themeSwatch5.colorRGBFromHex;
    
    // get/set RGB values for sliders & labels
    CGFloat red, green, blue;
    [self.swatch1.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
    self.labelRed.textColor   = [UIColor whiteColor];
    self.labelGreen.textColor = [UIColor whiteColor];
    self.labelBlue.textColor  = [UIColor whiteColor];
    self.labelRed.text        = [NSString stringWithFormat:@"R: %.0f", red * 255];
    self.labelGreen.text      = [NSString stringWithFormat:@"G: %.0f", green * 255];
    self.labelBlue.text       = [NSString stringWithFormat:@"B: %.0f", blue * 255];
    self.labelHex.text        = [NSString stringWithFormat:@"Hex: %@", [self hexFromRed:red Green:green Blue:blue]];
    self.labelRed.userInteractionEnabled = YES;
    self.labelGreen.userInteractionEnabled = YES;
    self.labelBlue.userInteractionEnabled = YES;
    self.labelHex.userInteractionEnabled = YES;
    self.sliderRed.value      = red;
    self.sliderGreen.value    = green;
    self.sliderBlue.value     = blue;
    self.sliderRed.tag        = 1;
    self.sliderGreen.tag      = 2;
    self.sliderBlue.tag       = 3;
    
    selectedSwatchIndex = 1;
    unselectedTransform = self.swatch1.transform;
    
    [[self currentSwatch:selectedSwatchIndex].superview bringSubviewToFront:[self currentSwatch:selectedSwatchIndex]];
    [UIView animateWithDuration:0.2 animations:^{
        self.swatch1.transform = CGAffineTransformScale(self.swatch1.transform, 1.2, 1.2);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Convenience Methods

- (NSString *)hexFromRed:(float)red Green:(float)green Blue:(float)blue {
    // parameters RGB should be (0.0-1.0) then returns "#XXXXXX"
    NSString *hex = [NSString stringWithFormat:@"#%02X%02X%02X",
                     [NSNumber numberWithFloat:red*255].unsignedIntValue,
                     [NSNumber numberWithFloat:green*255].unsignedIntValue,
                     [NSNumber numberWithFloat:blue*255].unsignedIntValue];
    return hex;
}

- (UIView *)currentSwatch:(int)index {
    // convenience method to get the swatch from an index
    UIView *view;
    switch (index) {
        case 1:
            view = self.swatch1;
            break;
        case 2:
            view = self.swatch2;
            break;
        case 3:
            view = self.swatch3;
            break;
        case 4:
            view = self.swatch4;
            break;
        case 5:
            view = self.swatch5;
            break;
        default:
            break;
    }
    return view;
}

- (void)changeControlEnableStateTo:(BOOL)state {
    // convenience method for enabling/disabling all controls
    self.sliderRed.enabled = state;
    self.sliderBlue.enabled = state;
    self.sliderGreen.enabled = state;
    self.labelRed.userInteractionEnabled = state;
    self.labelGreen.userInteractionEnabled = state;
    self.labelBlue.userInteractionEnabled = state;
    self.labelHex.userInteractionEnabled = state;
    self.swatch1.userInteractionEnabled = state;
    self.swatch2.userInteractionEnabled = state;
    self.swatch3.userInteractionEnabled = state;
    self.swatch4.userInteractionEnabled = state;
    self.swatch5.userInteractionEnabled = state;
}

- (void)saveSwatchChanges {
    // convenience method for saving the changed swatch
    RAKulerSwatch *swatchToSave = [[RAKulerSwatch alloc] initWithColor:[self currentSwatch:selectedSwatchIndex].backgroundColor forIndex:selectedSwatchIndex-1];
    [self.kuler setSwatch:swatchToSave atIndex:selectedSwatchIndex-1];
}

#pragma mark - UI/UX Methods

- (void)sliderChanged:(id)sender {
    UISlider *slider = sender;
    
    switch (slider.tag) {
        case 1:
            self.labelRed.text   = [NSString stringWithFormat:@"R: %.0f", slider.value * 255];
            break;
        case 2:
            self.labelGreen.text = [NSString stringWithFormat:@"G: %.0f", slider.value * 255];
            break;
        case 3:
            self.labelBlue.text  = [NSString stringWithFormat:@"B: %.0f", slider.value * 255];
            break;
        default:
            break;
    }
    
    [self currentSwatch:selectedSwatchIndex].backgroundColor = [UIColor colorWithRed:self.sliderRed.value green:self.sliderGreen.value blue:self.sliderBlue.value alpha:1.0];
    self.labelHex.text = [NSString stringWithFormat:@"Hex: %@", [self hexFromRed:self.sliderRed.value Green:self.sliderGreen.value Blue:self.sliderBlue.value]];
}

- (void)swatchPressedWithIndex:(int)index {
    UIView *view = [self currentSwatch:index];

    [self saveSwatchChanges];
    
    CGFloat red, green, blue;
    [view.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
    
    self.labelHex.text   = [NSString stringWithFormat:@"Hex: %@", [self hexFromRed:red Green:green Blue:blue]];
    self.labelRed.text   = [NSString stringWithFormat:@"R: %.0f", red * 255];
    self.labelGreen.text = [NSString stringWithFormat:@"G: %.0f", green * 255];
    self.labelBlue.text  = [NSString stringWithFormat:@"B: %.0f", blue * 255];
    
    [self.sliderRed   setValue:red animated:YES];
    [self.sliderGreen setValue:green animated:YES];
    [self.sliderBlue  setValue:blue animated:YES];
    
    // shrink animation to return to unselected state
    [UIView animateWithDuration:0.2 animations:^{
        [self currentSwatch:selectedSwatchIndex].transform = unselectedTransform;
    }];
    
    unselectedTransform = view.transform;
    selectedSwatchIndex = view.tag;
    
    // grow animation for selected swatch
    [[self currentSwatch:selectedSwatchIndex].superview bringSubviewToFront:[self currentSwatch:selectedSwatchIndex]];
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformScale(view.transform, 1.2, 1.2);
    }];
}

- (void)swatchPanned:(UIPanGestureRecognizer *)sender {
    static CGPoint originalCenter;
    int alternateSwatchIndex = 0;
    int originalSwatchIndex = 0;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        originalCenter = sender.view.center;
        sender.view.alpha = 0.8;
        [sender.view.superview bringSubviewToFront:sender.view];
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [sender translationInView:self.view];
        sender.view.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y);
        
    } else if (sender.state == UIGestureRecognizerStateEnded ||
             sender.state == UIGestureRecognizerStateCancelled ||
             sender.state == UIGestureRecognizerStateFailed) {
        
        // remember where the swatch began
        if (originalCenter.x < SWATCH1_BOUND_X)
            originalSwatchIndex = 1;
        else if (originalCenter.x > SWATCH1_BOUND_X && originalCenter.x < SWATCH2_BOUND_X)
            originalSwatchIndex = 2;
        else if (originalCenter.x > SWATCH2_BOUND_X && originalCenter.x < SWATCH3_BOUND_X)
            originalSwatchIndex = 3;
        else if (originalCenter.x > SWATCH3_BOUND_X && originalCenter.x < SWATCH4_BOUND_X)
            originalSwatchIndex = 4;
        else if (originalCenter.x > SWATCH4_BOUND_X)
            originalSwatchIndex = 5;
        
        // calculate correct section of snap to
        CGPoint center = sender.view.center;
        if (center.x < SWATCH1_BOUND_X)
            center.x = SWATCH1_CENTER_X;
        else if (center.x > SWATCH1_BOUND_X && center.x < SWATCH2_BOUND_X)
            center.x = SWATCH2_CENTER_X;
        else if (center.x > SWATCH2_BOUND_X && center.x < SWATCH3_BOUND_X)
            center.x = SWATCH3_CENTER_X;
        else if (center.x > SWATCH3_BOUND_X && center.x < SWATCH4_BOUND_X)
            center.x = SWATCH4_CENTER_X;
        else if (center.x > SWATCH4_BOUND_X)
            center.x = SWATCH5_CENTER_X;
        
        center.y = SWATCH_CENTER_Y;
        
        if (center.x < SWATCH1_BOUND_X)
            alternateSwatchIndex = 1;
        else if (center.x > SWATCH1_BOUND_X && center.x < SWATCH2_BOUND_X)
            alternateSwatchIndex = 2;
        else if (center.x > SWATCH2_BOUND_X && center.x < SWATCH3_BOUND_X)
            alternateSwatchIndex = 3;
        else if (center.x > SWATCH3_BOUND_X && center.x < SWATCH4_BOUND_X)
            alternateSwatchIndex = 4;
        else if (center.x > SWATCH4_BOUND_X)
            alternateSwatchIndex = 5;
        
        [UIView animateWithDuration:0.2 animations:^{
            // snap to new center
            sender.view.center = center;
            sender.view.alpha  = 1.0;
            
            // move other swatch to old center
            [self currentSwatch:alternateSwatchIndex].center = originalCenter;
        } completion:^(BOOL finished) {
            
            // swap swatches data and move back to original spots without animation
            [self.kuler swapSwatchAtIndex:originalSwatchIndex-1 withIndex:alternateSwatchIndex-1];
            CGPoint tempCenter = [self currentSwatch:originalSwatchIndex].center;
            [self currentSwatch:originalSwatchIndex].center = [self currentSwatch:alternateSwatchIndex].center;
            [self currentSwatch:alternateSwatchIndex].center = tempCenter;
            
            [self currentSwatch:originalSwatchIndex].backgroundColor = [self.kuler getSwatchAtIndex:originalSwatchIndex-1].colorRGBFromHex;
            [self currentSwatch:alternateSwatchIndex].backgroundColor = [self.kuler getSwatchAtIndex:alternateSwatchIndex-1].colorRGBFromHex;
            
            [self swatchPressedWithIndex:alternateSwatchIndex];
        }];
        // give focus to moved kuler swatch
        //[self swatchPressedWithIndex:selectedSwatchIndex];
        //[self swatchPressedWithIndex:alternateSwatchIndex];
    }
}

#pragma mark - UITapGestureRecognizer Selectors

- (void)swatchPressed:(UITapGestureRecognizer *)tap {
    // check to see if swatch is already selected
    if (tap.view == [self currentSwatch:selectedSwatchIndex]) return;
    
    [self saveSwatchChanges];
    
    // get/set RGB values for labels & sliders
    CGFloat red, green, blue;
    [tap.view.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
    self.labelHex.text   = [NSString stringWithFormat:@"Hex: %@", [self hexFromRed:red Green:green Blue:blue]];
    self.labelRed.text   = [NSString stringWithFormat:@"R: %.0f", red * 255];
    self.labelGreen.text = [NSString stringWithFormat:@"G: %.0f", green * 255];
    self.labelBlue.text  = [NSString stringWithFormat:@"B: %.0f", blue * 255];
    [self.sliderRed   setValue:red animated:YES];
    [self.sliderGreen setValue:green animated:YES];
    [self.sliderBlue  setValue:blue animated:YES];
    
    // shrink animation to return to unselected state
    [UIView animateWithDuration:0.2 animations:^{
        [self currentSwatch:selectedSwatchIndex].transform = unselectedTransform;
    }];
    
    unselectedTransform = tap.view.transform;
    selectedSwatchIndex = tap.view.tag;
    
    // grow animation for selected swatch
    [[self currentSwatch:selectedSwatchIndex].superview bringSubviewToFront:[self currentSwatch:selectedSwatchIndex]];
    [UIView animateWithDuration:0.2 animations:^{
        tap.view.transform = CGAffineTransformScale(tap.view.transform, 1.2, 1.2);
    }];
}

- (void)tapRedLabel:(UITapGestureRecognizer *)gestureRecognizer {
    
    UIAlertView *changeRed = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"RED", @"Red") message:[NSString stringWithFormat:@"%@ %@ %@:", NSLocalizedString(@"CHANGE_COLOR", @"Enter value"), NSLocalizedString(@"RED", @"Red"), NSLocalizedString(@"VALUE_RANGE", @"(0-255)")] delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", "OK"), nil];
    changeRed.tag = 2;
    changeRed.alertViewStyle = UIAlertViewStylePlainTextInput;
    [changeRed textFieldAtIndex:0].delegate = self;
    [changeRed textFieldAtIndex:0].tag = 1;
    [changeRed textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [changeRed textFieldAtIndex:0].text = [NSString stringWithFormat:@"%.0f", self.sliderRed.value * 255];
    [changeRed show];
}

- (void)tapGreenLabel:(UITapGestureRecognizer *)gestureRecognizer {
    UIAlertView *changeGreen = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GREEN", @"Green") message:[NSString stringWithFormat:@"%@ %@ %@:", NSLocalizedString(@"CHANGE_COLOR", @"Enter value"), NSLocalizedString(@"GREEN", @"Green"), NSLocalizedString(@"VALUE_RANGE", @"(0-255)")] delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", "OK"), nil];
    changeGreen.tag = 3;
    changeGreen.alertViewStyle = UIAlertViewStylePlainTextInput;
    [changeGreen textFieldAtIndex:0].delegate = self;
    [changeGreen textFieldAtIndex:0].tag = 1;
    [changeGreen textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [changeGreen textFieldAtIndex:0].text = [NSString stringWithFormat:@"%.0f", self.sliderGreen.value * 255];
    [changeGreen show];
}

- (void)tapBlueLabel:(UITapGestureRecognizer *)gestureRecognizer {
    UIAlertView *changeBlue = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"BLUE", @"Blue") message:[NSString stringWithFormat:@"%@ %@ %@:", NSLocalizedString(@"CHANGE_COLOR", @"Enter value"), NSLocalizedString(@"BLUE", @"Blue"), NSLocalizedString(@"VALUE_RANGE", @"(0-255)")] delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", "OK"), nil];
    changeBlue.tag = 4;
    changeBlue.alertViewStyle = UIAlertViewStylePlainTextInput;
    [changeBlue textFieldAtIndex:0].delegate = self;
    [changeBlue textFieldAtIndex:0].tag = 1;
    [changeBlue textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [changeBlue textFieldAtIndex:0].text = [NSString stringWithFormat:@"%.0f", self.sliderBlue.value * 255];
    [changeBlue show];
}

- (void)tapHexLabel:(UITapGestureRecognizer *)gestureRecognizer {
    UIAlertView *changeHex = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"HEX", @"Hex") message:NSLocalizedString(@"CHANGE_HEX", @"Enter value") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", "OK"), nil];
    changeHex.tag = 5;
    changeHex.alertViewStyle = UIAlertViewStylePlainTextInput;
    [changeHex textFieldAtIndex:0].delegate = self;
    [changeHex textFieldAtIndex:0].tag = 2;
    [changeHex textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [changeHex textFieldAtIndex:0].text = [self.labelHex.text substringWithRange:NSMakeRange(6, 6)];
    hexEntryTextField = [changeHex textFieldAtIndex:0];
    
    UIToolbar *alphaPad = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    alphaPad.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *alphaA = [[UIBarButtonItem alloc] initWithTitle:@"  A  " style:UIBarButtonItemStyleBordered target:self action:@selector(alphaAPressed)];
    UIBarButtonItem *alphaB = [[UIBarButtonItem alloc] initWithTitle:@"  B  " style:UIBarButtonItemStyleBordered target:self action:@selector(alphaBPressed)];
    UIBarButtonItem *alphaC = [[UIBarButtonItem alloc] initWithTitle:@"  C  " style:UIBarButtonItemStyleBordered target:self action:@selector(alphaCPressed)];
    UIBarButtonItem *alphaD = [[UIBarButtonItem alloc] initWithTitle:@"  D  " style:UIBarButtonItemStyleBordered target:self action:@selector(alphaDPressed)];
    UIBarButtonItem *alphaE = [[UIBarButtonItem alloc] initWithTitle:@"  E  " style:UIBarButtonItemStyleBordered target:self action:@selector(alphaEPressed)];
    UIBarButtonItem *alphaF = [[UIBarButtonItem alloc] initWithTitle:@"  F  " style:UIBarButtonItemStyleBordered target:self action:@selector(alphaFPressed)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    alphaPad.items = @[flexibleSpace, alphaA, alphaB, alphaC, alphaD, alphaE, alphaF, flexibleSpace];
    [changeHex textFieldAtIndex:0].inputAccessoryView = alphaPad;
    [changeHex show];
}

- (void)alphaAPressed {
    if (hexEntryTextField.text.length < 6)
        hexEntryTextField.text = [NSString stringWithFormat:@"%@A", hexEntryTextField.text];
}
- (void)alphaBPressed {
    if (hexEntryTextField.text.length < 6)
        hexEntryTextField.text = [NSString stringWithFormat:@"%@B", hexEntryTextField.text];
}
- (void)alphaCPressed {
    if (hexEntryTextField.text.length < 6)
        hexEntryTextField.text = [NSString stringWithFormat:@"%@C", hexEntryTextField.text];
}
- (void)alphaDPressed {
    if (hexEntryTextField.text.length < 6)
        hexEntryTextField.text = [NSString stringWithFormat:@"%@D", hexEntryTextField.text];
}
- (void)alphaEPressed {
    if (hexEntryTextField.text.length < 6)
        hexEntryTextField.text = [NSString stringWithFormat:@"%@E", hexEntryTextField.text];
}
- (void)alphaFPressed {
    if (hexEntryTextField.text.length < 6)
        hexEntryTextField.text = [NSString stringWithFormat:@"%@F", hexEntryTextField.text];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    switch (textField.tag) {
        case 1:  // number entry for RGB values (max 3)
            return (range.location < 3);
            break;
        
        case 2:  // string entry for Hex value (max 6)
            return (range.location < 6);
            break;
            
        default:
            break;
    }
    return NO;
}

#pragma mark - UIToolbar Button Actions

- (void)infoButtonPressed:(id)sender {
    UIBarButtonItem *infoButton = sender;
    if (infoButton.tag == 2) return;  // animations in progress, ignore
    else if (infoButton.tag == 0) {
        infoButton.tag = 2; // set to 2 to ignore pressed while animating
        // disable controls and stretch swatch frames
        [self changeControlEnableStateTo:NO];
        infoButton.tintColor = METACOLOR_GREEN;
        [UIView animateWithDuration:1.0 animations:^{
            self.swatch1.frame = CGRectMake(20, 20, 56, 56*4);
            self.swatch2.frame = CGRectMake(20+56, 20, 56, 56*4);
            self.swatch3.frame = CGRectMake(20+(56*2), 20, 56, 56*4);
            self.swatch4.frame = CGRectMake(20+(56*3), 20, 56, 56*4);
            self.swatch5.frame = CGRectMake(20+(56*4), 20, 56, 56*4);
            self.themeData.alpha = 1.0;
            self.colorWheel.alpha = 0.0;
        } completion:^(BOOL finished) {
            infoButton.tag = 1;
        }];
        
    } else if (infoButton.tag == 1) {
        infoButton.tag = 2;
        // enable controls and shrink swatches frames
        [self changeControlEnableStateTo:YES];
        infoButton.tintColor = [UIColor whiteColor];
        [UIView animateWithDuration:1.0 animations:^{
            self.swatch1.frame = CGRectMake(20, 20, 56, 56);
            self.swatch2.frame = CGRectMake(20+56, 20, 56, 56);
            self.swatch3.frame = CGRectMake(20+(56*2), 20, 56, 56);
            self.swatch4.frame = CGRectMake(20+(56*3), 20, 56, 56);
            self.swatch5.frame = CGRectMake(20+(56*4), 20, 56, 56);
            self.themeData.alpha = 0.0;
            self.colorWheel.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            infoButton.tag = 0;
            [UIView animateWithDuration:0.2 animations:^{
                UIView *view = [self currentSwatch:selectedSwatchIndex];
                unselectedTransform = view.transform;
                view.transform = CGAffineTransformScale(view.transform, 1.2, 1.2);
            }];
        }];
    }
}

- (void)shareButtonPressed:(id)sender {
    NSLog(@"share button pressed");
}

#pragma mark - Save Kuler Methods

- (void)saveBarButtonPressed:(id)sender {
    // display alertView prompting user to name the kuler
    UIAlertView *nameKuler = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NAMEKULER", @"Kuler Name") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"SAVE", @"Save"), nil];
    nameKuler.tag = 1;
    nameKuler.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *kulerNameTextField = [nameKuler textFieldAtIndex:0];
    kulerNameTextField.text = self.kuler.themeTitle;
    
    [nameKuler show];
}

- (void)saveKulerWithName:(NSString *)name {
    CGFloat red, green, blue;
    
    // get all swatches current values
    [self.swatch1.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
    RAKulerSwatch *swatch1 = [[RAKulerSwatch alloc] initRGBAWithIndex:1 channel1:red channel2:green channel3:blue channel4:1.0];
    [self.swatch2.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
    RAKulerSwatch *swatch2 = [[RAKulerSwatch alloc] initRGBAWithIndex:2 channel1:red channel2:green channel3:blue channel4:1.0];
    [self.swatch3.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
    RAKulerSwatch *swatch3 = [[RAKulerSwatch alloc] initRGBAWithIndex:3 channel1:red channel2:green channel3:blue channel4:1.0];
    [self.swatch4.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
    RAKulerSwatch *swatch4 = [[RAKulerSwatch alloc] initRGBAWithIndex:4 channel1:red channel2:green channel3:blue channel4:1.0];
    [self.swatch5.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
    RAKulerSwatch *swatch5 = [[RAKulerSwatch alloc] initRGBAWithIndex:5 channel1:red channel2:green channel3:blue channel4:1.0];
    
    // init new object to save
    RAKulerObject *newKuler = [[RAKulerObject alloc] initWithID:self.kuler.themeID
                                                          title:name
                                                          image:self.kuler.themeImageURL
                                                       authorID:self.kuler.themeAuthorID
                                                    authorLabel:self.kuler.themeAuthorLabel
                                                           tags:self.kuler.themeTags
                                                         rating:self.kuler.themeRating
                                                  downloadCount:self.kuler.themeDownloadCount
                                                      createdAt:self.kuler.themeCreatedAt
                                                       editedAt:self.kuler.themeEditedAt
                                                        swatch1:swatch1
                                                        swatch2:swatch2
                                                        swatch3:swatch3
                                                        swatch4:swatch4
                                                        swatch5:swatch5
                                                    publishDate:self.kuler.themePublishDate];
    
    // get saved kulers array
    NSMutableArray *savedKulers = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"savedKulers"]) {
        NSData *kulerData = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedKulers"];
        savedKulers = [NSKeyedUnarchiver unarchiveObjectWithData:kulerData];
    }
    
    // check for previous kuler of same name, then overwrite
    int indexToReplace = -1;
    for (int i=0; i < savedKulers.count; i++) {
        RAKulerObject *temp = savedKulers[i];
        if ([temp.themeTitle isEqualToString:name]) {
            indexToReplace = i;
            NSLog(@"savedKuler[%i] = %@", indexToReplace, name);
            break;
        }
    }
    
    // if kuler exists, overwrite, else save new
    if (indexToReplace != -1) [savedKulers replaceObjectAtIndex:indexToReplace withObject:newKuler];
    else [savedKulers addObject:newKuler];
    
    // save kuler list
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:savedKulers] forKey:@"savedKulers"];

}

#pragma mark - Setup Methods

- (void)configureFonts {
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    
    self.labelRed.font = font;
    self.labelGreen.font = font;
    self.labelBlue.font = font;
    self.labelHex.font = font;
    self.labelHSB.font = font;
}

- (void)configureToolbar {
    // set up toolbar
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"infoIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(infoButtonPressed:)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonPressed:)];
    
    UIToolbar *kulerToolbar = [[UIToolbar alloc] init];
    kulerToolbar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 108, self.view.frame.size.width, 44);
    kulerToolbar.barStyle = UIBarStyleBlack;
    kulerToolbar.items = @[infoButton, flexibleSpace, shareButton];
    [self.view addSubview:kulerToolbar];
    
}

- (void)configureSliders {
    
    // set up sliders
    UIImage *minFillRed = [UIImage imageNamed:@"slider_fill_red"];
    UIImage *minFillGreen = [UIImage imageNamed:@"slider_fill_green"];
    UIImage *minFillBlue = [UIImage imageNamed:@"slider_fill_blue"];
    UIImage *handle = [UIImage imageNamed:@"slider_handle"];
    minFillRed = [minFillRed stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0];
    minFillGreen = [minFillGreen stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0];
    minFillBlue = [minFillBlue stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0];
    
    [self.sliderRed setMinimumTrackImage:minFillRed forState:UIControlStateNormal];
    [self.sliderRed setThumbImage:handle forState:UIControlStateNormal];
    [self.sliderGreen setMinimumTrackImage:minFillGreen forState:UIControlStateNormal];
    [self.sliderGreen setThumbImage:handle forState:UIControlStateNormal];
    [self.sliderBlue setMinimumTrackImage:minFillBlue forState:UIControlStateNormal];
    [self.sliderBlue setThumbImage:handle forState:UIControlStateNormal];
    
    [self.sliderRed addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderGreen addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderBlue addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)configureGestures {
    // swatch presses
    UITapGestureRecognizer *swatchPressed1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swatchPressed:)];
    UITapGestureRecognizer *swatchPressed2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swatchPressed:)];
    UITapGestureRecognizer *swatchPressed3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swatchPressed:)];
    UITapGestureRecognizer *swatchPressed4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swatchPressed:)];
    UITapGestureRecognizer *swatchPressed5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swatchPressed:)];
    
    // swatch panners
    UIPanGestureRecognizer *swatchPanned1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swatchPanned:)];
    UIPanGestureRecognizer *swatchPanned2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swatchPanned:)];
    UIPanGestureRecognizer *swatchPanned3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swatchPanned:)];
    UIPanGestureRecognizer *swatchPanned4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swatchPanned:)];
    UIPanGestureRecognizer *swatchPanned5 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swatchPanned:)];
    
    // double-tap RGB labels
    UITapGestureRecognizer *redTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRedLabel:)];
    UITapGestureRecognizer *blueTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlueLabel:)];
    UITapGestureRecognizer *greenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGreenLabel:)];
    UITapGestureRecognizer *hexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHexLabel:)];
    redTap.numberOfTapsRequired   = 1;
    blueTap.numberOfTapsRequired  = 1;
    greenTap.numberOfTapsRequired = 1;
    hexTap.numberOfTapsRequired   = 1;
    
    // add to their respective views
    [self.swatch1 addGestureRecognizer:swatchPressed1];
    [self.swatch2 addGestureRecognizer:swatchPressed2];
    [self.swatch3 addGestureRecognizer:swatchPressed3];
    [self.swatch4 addGestureRecognizer:swatchPressed4];
    [self.swatch5 addGestureRecognizer:swatchPressed5];
    [self.swatch1 addGestureRecognizer:swatchPanned1];
    [self.swatch2 addGestureRecognizer:swatchPanned2];
    [self.swatch3 addGestureRecognizer:swatchPanned3];
    [self.swatch4 addGestureRecognizer:swatchPanned4];
    [self.swatch5 addGestureRecognizer:swatchPanned5];
    [self.labelRed addGestureRecognizer:redTap];
    [self.labelBlue addGestureRecognizer:blueTap];
    [self.labelGreen addGestureRecognizer:greenTap];
    [self.labelHex addGestureRecognizer:hexTap];
}

#pragma mark - ISColorWheel Delegate Methods
- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel {
    // set swatch color and update sliders
    [self currentSwatch:selectedSwatchIndex].backgroundColor = self.colorWheel.currentColor;
    
    CGFloat red, green, blue;
    [[self currentSwatch:selectedSwatchIndex].backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
    [self.sliderRed   setValue:red animated:NO];
    [self.sliderGreen setValue:green animated:NO];
    [self.sliderBlue  setValue:blue animated:NO];
    self.labelRed.text   = [NSString stringWithFormat:@"R: %.0f", red * 255];
    self.labelGreen.text = [NSString stringWithFormat:@"G: %.0f", green * 255];
    self.labelBlue.text  = [NSString stringWithFormat:@"B: %.0f", blue * 255];
    self.labelHex.text   = [NSString stringWithFormat:@"Hex: %@", [self hexFromRed:red Green:green Blue:blue]];
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"alertView.tag: %i .. buttonIndex: %i", alertView.tag, buttonIndex);
    UITextField *textField = [alertView textFieldAtIndex:0];
    float sliderValue;
    switch (alertView.tag) {
        case 1:
            // kuler rename alertView
            switch (buttonIndex) {
                case 0:
                    // cancel
                    break;
                case 1:
                    // save kuler
                    if ([textField.text isEqualToString:@""]) {
                        UIAlertView *noKulerNameAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NAMEKULER", @"Kuler Name") message:NSLocalizedString(@"ERROR_NONAME", @"No name error") delegate:nil cancelButtonTitle:NSLocalizedString(@"DISMISS", @"Dismiss") otherButtonTitles:nil, nil];
                        [noKulerNameAlert show];
                    } else {
                        [self saveKulerWithName:textField.text];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    break;
                default:
                    break;
            }
            break;
        case 2:
            // red value entered
            switch (buttonIndex) {
                case 0:
                    // cancel
                    break;
                case 1:
                    // check for 0-255 range then set red value
                    if (textField.text.intValue > 255) sliderValue = 1.0;
                    else if (textField.text.intValue < 0) sliderValue = 0.0;
                    else sliderValue = textField.text.floatValue / 255;
                    
                    [self.sliderRed setValue:sliderValue animated:YES];
                    [self sliderChanged:self.sliderRed];
                    break;
                    
                default:
                    break;
            }
            break;
        case 3:
            // green value entered
            switch (buttonIndex) {
                case 0:
                    // cancel
                    break;
                case 1:
                    // check for 0-255 range then set green value
                    if (textField.text.intValue > 255) sliderValue = 1.0;
                    else if (textField.text.intValue < 0) sliderValue = 0.0;
                    else sliderValue = textField.text.floatValue / 255;
                    
                    [self.sliderGreen setValue:sliderValue animated:YES];
                    [self sliderChanged:self.sliderGreen];
                    break;
                    
                default:
                    break;
            }
            break;
        case 4:
            // blue value entered
            switch (buttonIndex) {
                case 0:
                    // cancel
                    break;
                case 1:
                    // check for 0-255 range then set blue value
                    if (textField.text.intValue > 255) sliderValue = 1.0;
                    else if (textField.text.intValue < 0) sliderValue = 0.0;
                    else sliderValue = textField.text.floatValue / 255;
                    
                    [self.sliderBlue setValue:sliderValue animated:YES];
                    [self sliderChanged:self.sliderBlue];
                    break;
                    
                default:
                    break;
            }
            break;
        case 5:
            // hex value changed
            switch (buttonIndex) {
                case 0:
                    // cancel
                    hexEntryTextField = nil;
                    break;
                case 1:
                    hexEntryTextField = nil;
                    NSUInteger red, green, blue;
                    // change hex value (ignore non 3 or 6 char hex values)
                    if (textField.text.length == 6) {
                        sscanf([textField.text UTF8String], "%02X%02X%02X", &red, &green, &blue);
                    } else if (textField.text.length == 3) {
                        // convert 3-char to 6-char hex code
                        NSString *hexCode = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                            [textField.text substringWithRange:NSMakeRange(0, 1)],
                            [textField.text substringWithRange:NSMakeRange(0, 1)],
                            [textField.text substringWithRange:NSMakeRange(1, 1)],
                            [textField.text substringWithRange:NSMakeRange(1, 1)],
                            [textField.text substringWithRange:NSMakeRange(2, 1)],
                            [textField.text substringWithRange:NSMakeRange(2, 1)]];
                        sscanf([hexCode UTF8String], "%02X%02X%02X", &red, &green, &blue);
                    } else return;
                    
                    // set the sliders value
                    [self.sliderRed setValue:red/255.0 animated:YES];
                    [self.sliderGreen setValue:green/255.0 animated:YES];
                    [self.sliderBlue setValue:blue/255.0 animated:YES];
                    [self sliderChanged:self.sliderRed];
                    [self sliderChanged:self.sliderGreen];
                    [self sliderChanged:self.sliderBlue];
                    break;
                default:
                    break;
            }
        default:
            break;
    }
}

@end
