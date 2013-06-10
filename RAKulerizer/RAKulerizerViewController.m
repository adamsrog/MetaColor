//
//  RAKulerizerViewController.m
//  RAKulerizer
//
//  Created by Roger Adams on 4/7/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import "RAKulerizerViewController.h"
#import "RAKulerizerViewController+PatternGenerators.h"
#import <QuartzCore/QuartzCore.h>

@interface RAKulerizerViewController ()
@end

@implementation RAKulerizerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_DARK;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBarMetaColor"]];;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    // set labels for initial buttons
    self.buttonLabel1x1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 130, 20)];
    self.buttonLabel2x1 = [[UILabel alloc] initWithFrame:CGRectMake(170, 150, 130, 20)];
    self.buttonLabel1x2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 310, 130, 20)];
    self.buttonLabel2x2 = [[UILabel alloc] initWithFrame:CGRectMake(170, 310, 130, 20)];
    self.buttonLabel1x1.text = NSLocalizedString(@"BUTTON_SEARCH", @"Search");
    self.buttonLabel2x1.text = NSLocalizedString(@"BUTTON_SAVED", @"Saved");
    self.buttonLabel1x2.text = NSLocalizedString(@"BUTTON_CREATE", @"Create");
    self.buttonLabel2x2.text = NSLocalizedString(@"BUTTON_SETTINGS", @"Settings");
    [self styleLabel:self.buttonLabel1x1];
    [self styleLabel:self.buttonLabel2x1];
    [self styleLabel:self.buttonLabel1x2];
    [self styleLabel:self.buttonLabel2x2];
    [self.view addSubview:self.buttonLabel1x1];
    [self.view addSubview:self.buttonLabel2x1];
    [self.view addSubview:self.buttonLabel1x2];
    [self.view addSubview:self.buttonLabel2x2];
    
    // draw kuler logo required by Adobe
    UIImageView *kulerLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ku_36pxWtext_bw@2x"]];
    float x = (self.view.bounds.size.width * 0.5);
    float y = (self.view.bounds.size.height - kulerLogo.image.size.height * 2);
    kulerLogo.center = CGPointMake(x, y);
    [self.view addSubview:kulerLogo];
    
    // create kuler bar based on screen size
    float barHeight = 64.0;
    float kulerBarCenterPointY = ((kulerLogo.frame.origin.y - 340)/2) + 340;
    CGPoint kulerBarCenterPoint = CGPointMake(self.view.frame.size.width/2, kulerBarCenterPointY);
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        barHeight = 24.0;
        kulerBarCenterPoint = CGPointMake(kulerBarCenterPoint.x, kulerBarCenterPoint.y - 4);
    }
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 340, self.view.frame.size.width, barHeight)];
    self.imageView.center = kulerBarCenterPoint;
    [self.view addSubview:self.imageView];
    
    // draw randomized kuler bar based on saved kulers
    RAKulerObject *randomKuler = [self randomSavedKuler];
    if (randomKuler) {
        CGSize actualSize = self.imageView.frame.size;
        UIImage *targetImage = [self generateGridPatternFromKuler:randomKuler withSize:actualSize cellSize:GENERATOR_CELL_SIZE];
        self.imageView.image = targetImage;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    // create kulerBar regen timer
    if ((![self.regenTimer isValid]) && (self.imageView.image != nil))
        self.regenTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(regenerateEffect:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    // disable kulerBar regen timer
    if ([self.regenTimer isValid])
        [self.regenTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSTimer Selector

- (void)regenerateEffect:(id)sender {
    // selector for NSTimer to regenerate kulerBar imageView
    RAKulerObject *randomKuler = [self randomSavedKuler];
    if (randomKuler) {
        // generate new image
        CGSize actualSize = self.imageView.frame.size;
        UIImage *targetImage = [self generateGridPatternFromKuler:randomKuler withSize:actualSize cellSize:GENERATOR_CELL_SIZE];
        
        // fade from old image to newly generated image
        CABasicAnimation *crossfade = [CABasicAnimation animationWithKeyPath:@"contents"];
        crossfade.duration = 0.5;
        crossfade.fromValue = self.imageView.image;
        crossfade.toValue = targetImage;
        
        [self.imageView.layer addAnimation:crossfade forKey:@"animateContents"];
        self.imageView.image = targetImage;
    }
}

#pragma mark - UIButton Selectors

- (IBAction)newKulerPress:(id)sender {
    RAKulerInfoViewController *kulerInfo = [[RAKulerInfoViewController alloc] initWithNibName:@"RAKulerInfoViewController" bundle:nil];
    RAKulerObject *defaultKuler = [[RAKulerObject alloc] initWithID:@"No ID"
                                                              title:@"New"
                                                              image:nil
                                                           authorID:@"0000"
                                                        authorLabel:@"MetaColor User"
                                                               tags:@"User created"
                                                             rating:0
                                                      downloadCount:0
                                                          createdAt:[NSDate date]
                                                           editedAt:[NSDate date]
                                                            swatch1:[[RAKulerSwatch alloc] initWithWhiteColor:[UIColor blackColor] forIndex:1]
                                                            swatch2:[[RAKulerSwatch alloc] initWithWhiteColor:[UIColor darkGrayColor] forIndex:2]
                                                            swatch3:[[RAKulerSwatch alloc] initWithWhiteColor:[UIColor grayColor] forIndex:3]
                                                            swatch4:[[RAKulerSwatch alloc] initWithWhiteColor:[UIColor lightGrayColor] forIndex:4]
                                                            swatch5:[[RAKulerSwatch alloc] initWithWhiteColor:[UIColor whiteColor] forIndex:5]
                                                        publishDate:[NSDate date]];
    [kulerInfo setKuler:defaultKuler];
    [self.navigationController pushViewController:kulerInfo animated:YES];
}

- (IBAction)savedKulerPress:(id)sender {
    // display saved kulers
    RAKulerSelectTableViewController *kulerSelect = [[RAKulerSelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    kulerSelect.kulerSource = KULER_USER_SAVED;
    [self.navigationController pushViewController:kulerSelect animated:YES];
}

- (IBAction)browseKulerPress:(id)sender {
    [self animateButtons];
    
    // display cancel button to go back to initial menu
    UIBarButtonItem *cancelKulerCategories = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK", "Back") style:UIBarButtonItemStylePlain target:self action:@selector(cancelKulerCategoryBrowse)];
    [self.navigationItem setLeftBarButtonItem:cancelKulerCategories animated:YES];
}

- (IBAction)configurePress:(id)sender {
    // display settings menu
    SettingsTableViewController *settings = [[SettingsTableViewController alloc] initWithNibName:@"SettingsTableViewController" bundle:nil];
    settings.title = NSLocalizedString(@"CONFIG_TITLE", @"Settings");
    
    [self.navigationController pushViewController:settings animated:YES];
}

- (IBAction)highestRatedPress:(id)sender {
    [self launchKulerTableViewFromSource:KULER_RSS_HIGHEST_RATED];
}

- (IBAction)popularPress:(id)sender {
    [self launchKulerTableViewFromSource:KULER_RSS_POPULAR];
}

- (IBAction)newestPress:(id)sender {
    [self launchKulerTableViewFromSource:KULER_RSS_NEWEST];
}

- (IBAction)randomPress:(id)sender {
    [self launchKulerTableViewFromSource:KULER_RSS_RANDOM];
}

#pragma mark - Convenience Methods

- (void)styleLabel:(UILabel *)label {
    
    // method to style UILabel (since it doesn't conform to UIAppearance proxy)
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
}

- (void)animateButtons {
    
    self.buttonLabel1x1.alpha = 0.0;
    self.buttonLabel2x1.alpha = 0.0;
    self.buttonLabel1x2.alpha = 0.0;
    self.buttonLabel2x2.alpha = 0.0;
    self.buttonLabel1x1.text = NSLocalizedString(@"BUTTON_TOPRATED", @"Top Rated");
    self.buttonLabel2x1.text = NSLocalizedString(@"BUTTON_POPULAR", @"Popular");
    self.buttonLabel1x2.text = NSLocalizedString(@"BUTTON_NEWEST", @"Newest");
    self.buttonLabel2x2.text = NSLocalizedString(@"BUTTON_RANDOM", @"Random");
    
    self.buttonHighestRated.hidden = NO;
    self.buttonPopular.hidden      = NO;
    self.buttonNewest.hidden       = NO;
    self.buttonRandom.hidden       = NO;
    
    self.buttonHighestRated.center = self.buttonBrowseKuler.center;
    self.buttonPopular.center      = self.buttonBrowseKuler.center;
    self.buttonNewest.center       = self.buttonBrowseKuler.center;
    self.buttonRandom.center       = self.buttonBrowseKuler.center;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.buttonBrowseKuler.alpha  = 0.0;
        self.buttonSavedKuler.alpha   = 0.0;
        self.buttonNewKuler.alpha     = 0.0;
        self.buttonConfigure.alpha    = 0.0;
        self.buttonHighestRated.alpha = 1.0;
        self.buttonPopular.alpha      = 1.0;
        self.buttonNewest.alpha       = 1.0;
        self.buttonRandom.alpha       = 1.0;
        
        self.buttonLabel1x1.alpha = 1.0;
        self.buttonLabel2x1.alpha = 1.0;
        self.buttonLabel1x2.alpha = 1.0;
        self.buttonLabel2x2.alpha = 1.0;
        
        self.buttonPopular.center = self.buttonSavedKuler.center;
        self.buttonNewest.center  = self.buttonNewKuler.center;
        self.buttonRandom.center  = self.buttonConfigure.center;
    }];
}

- (void)cancelKulerCategoryBrowse {
    
    self.buttonLabel1x1.alpha = 0.0;
    self.buttonLabel2x1.alpha = 0.0;
    self.buttonLabel1x2.alpha = 0.0;
    self.buttonLabel2x2.alpha = 0.0;
    
    self.buttonLabel1x1.text = NSLocalizedString(@"BUTTON_SEARCH", @"Search");
    self.buttonLabel2x1.text = NSLocalizedString(@"BUTTON_SAVED", @"Saved");
    self.buttonLabel1x2.text = NSLocalizedString(@"BUTTON_CREATE", @"Create");
    self.buttonLabel2x2.text = NSLocalizedString(@"BUTTON_SETTINGS", @"Settings");
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.buttonBrowseKuler.alpha  = 1.0;
        self.buttonSavedKuler.alpha   = 1.0;
        self.buttonNewKuler.alpha     = 1.0;
        self.buttonConfigure.alpha    = 1.0;
        self.buttonHighestRated.alpha = 0.0;
        self.buttonPopular.alpha      = 0.0;
        self.buttonNewest.alpha       = 0.0;
        self.buttonRandom.alpha       = 0.0;
        
        self.buttonLabel1x1.alpha = 1.0;
        self.buttonLabel2x1.alpha = 1.0;
        self.buttonLabel1x2.alpha = 1.0;
        self.buttonLabel2x2.alpha = 1.0;
        
        self.buttonPopular.center = self.buttonHighestRated.center;
        self.buttonNewest.center  = self.buttonHighestRated.center;
        self.buttonRandom.center  = self.buttonHighestRated.center;
        
    } completion:^(BOOL finished) {
        self.buttonHighestRated.hidden = YES;
        self.buttonPopular.hidden      = YES;
        self.buttonNewest.hidden       = YES;
        self.buttonRandom.hidden       = YES;
    }];
    
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

- (RAKulerObject *)randomSavedKuler {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"savedKulers"]) {
        NSData *kulerData = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedKulers"];
        NSArray *savedKulers = [NSKeyedUnarchiver unarchiveObjectWithData:kulerData];
        
        // get random kuler from saved
        int r = arc4random_uniform(savedKulers.count);
        RAKulerObject *randomKuler = savedKulers[r];
        
        return randomKuler;
    }
    return nil;
}

- (void)launchKulerTableViewFromSource:(int)source {
    RAKulerSelectTableViewController *kulerSelect = [[RAKulerSelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    kulerSelect.kulerSource = source;
    [self.navigationController pushViewController:kulerSelect animated:YES];
    /*
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController pushViewController:kulerSelect animated:YES];
    } completion:^(BOOL finished) {
        self.buttonBrowseKuler.hidden  = NO;
        self.buttonSavedKuler.hidden   = NO;
        self.buttonNewKuler.hidden     = NO;
        self.buttonConfigure.hidden    = NO;
        self.buttonLabel1x1.text = NSLocalizedString(@"BUTTON_SEARCH", @"Search");
        self.buttonLabel2x1.text = NSLocalizedString(@"BUTTON_SAVED", @"Saved");
        self.buttonLabel1x2.text = NSLocalizedString(@"BUTTON_CREATE", @"Create");
        self.buttonLabel2x2.text = NSLocalizedString(@"BUTTON_SETTINGS", @"Settings");
        self.buttonBrowseKuler.alpha   = 1.0;
        self.buttonSavedKuler.alpha    = 1.0;
        self.buttonNewKuler.alpha      = 1.0;
        self.buttonConfigure.alpha     = 1.0;
        self.buttonHighestRated.hidden = YES;
        self.buttonPopular.hidden      = YES;
        self.buttonNewest.hidden       = YES;
        self.buttonRandom.hidden       = YES;
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    }];
     */
}

@end
