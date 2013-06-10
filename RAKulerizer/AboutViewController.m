//
//  AboutViewController.m
//  myFram
//
//  Created by Roger Adams on 2/2/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import "AboutViewController.h"
#import "QuartzCore/CALayer.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize companyIndex; // integer representing the users selection from previous (tableView row)
@synthesize companyWebsiteButton, companyOtherButton;  // buttons in the view

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)websiteButtonPressed:(id)sender {
    NSArray *companyWebsite = @[@"http://www.simplicity-studios.com", @"http://kuler.adobe.com"];
    NSString *url = companyWebsite[companyIndex];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}

- (IBAction)otherButtonPressed:(id)sender {
    NSString *url = @"http://kuler.adobe.com";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_LIGHT;
    NSArray *companyLogo = @[[UIImage imageNamed:@"ssLogo"]]; //, [UIImage imageNamed:@"adobeKulerLogo"]];
    NSArray *companyText = @[NSLocalizedString(@"SIMPLICITYSTUDIOS_ABOUT", @"Simplicity Studios bio")];
    
    self.companyLogoImageView.image = companyLogo[companyIndex];
    self.companyInfoLabel.text = companyText[companyIndex];
    
    [companyWebsiteButton setTitle:NSLocalizedString(@"VISIT_WEBSITE_BUTTON", @"Visit Website") forState:UIControlStateNormal];
    [companyOtherButton setTitle:NSLocalizedString(@"KULER_WEBSITE_BUTTON", @"Kuler Website") forState:UIControlStateNormal];
    [self styleButton:companyWebsiteButton];
    [self styleButton:companyOtherButton];
    
}

- (void)styleButton:(UIButton *)button {
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:16.0];
    button.backgroundColor = BACKGROUND_DARK;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
