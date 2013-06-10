//
//  RAKulerizerViewController.h
//  RAKulerizer
//
//  Created by Roger Adams on 4/7/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAKulerSelectTableViewController.h"
#import "RAKulerInfoViewController.h"
#import "SettingsTableViewController.h"
#include "RAGlobalDefinitions.h"

@interface RAKulerizerViewController : UIViewController {
    
    UIImageView *_imageView;
    NSTimer *_regenTimer;
    
    UIButton *_buttonBrowseKuler;
    UIButton *_buttonSavedKuler;
    UIButton *_buttonNewKuler;
    UIButton *_buttonConfigure;
    UIButton *_buttonPopular;
    UIButton *_buttonRandom;
    UIButton *_buttonNewest;
    UIButton *_buttonHighestRated;
    
    UILabel *_buttonLabel1x1;
    UILabel *_buttonLabel2x1;
    UILabel *_buttonLabel1x2;
    UILabel *_buttonLabel2x2;
}

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) NSTimer *regenTimer;

@property (nonatomic) IBOutlet UIButton *buttonBrowseKuler;
@property (nonatomic) IBOutlet UIButton *buttonSavedKuler;
@property (nonatomic) IBOutlet UIButton *buttonNewKuler;
@property (nonatomic) IBOutlet UIButton *buttonConfigure;
@property (nonatomic) IBOutlet UIButton *buttonPopular;
@property (nonatomic) IBOutlet UIButton *buttonRandom;
@property (nonatomic) IBOutlet UIButton *buttonNewest;
@property (nonatomic) IBOutlet UIButton *buttonHighestRated;

@property (nonatomic) UILabel *buttonLabel1x1;
@property (nonatomic) UILabel *buttonLabel2x1;
@property (nonatomic) UILabel *buttonLabel1x2;
@property (nonatomic) UILabel *buttonLabel2x2;

@end
