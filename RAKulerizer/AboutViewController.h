//
//  AboutViewController.h
//  myFram
//
//  Created by Roger Adams on 2/2/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#include "RAGlobalDefinitions.h"
#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController {
    NSInteger companyIndex;
    UIButton *companyWebsiteButton;
    UIButton *companyOtherButton;
}

@property (nonatomic) NSInteger companyIndex;

@property (nonatomic, strong) IBOutlet UIImageView *companyLogoImageView;
@property (nonatomic, strong) IBOutlet UILabel *companyInfoLabel;
@property (nonatomic, strong) IBOutlet UIButton *companyWebsiteButton;
@property (nonatomic, strong) IBOutlet UIButton *companyOtherButton;

@end
