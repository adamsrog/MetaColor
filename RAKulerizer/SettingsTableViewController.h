//
//  SettingsTableViewController.h
//  myFram
//
//  Created by Roger Adams on 2/2/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutViewController.h"

@interface SettingsTableViewController : UITableViewController {
    
    NSDictionary *_tableContents;   // dictionary containing arrays for sections in tableView
    NSArray *_sortedKeys;           // used in populating tableView
}

@property (nonatomic, strong) NSDictionary *tableContents;
@property (nonatomic, strong) NSArray *sortedKeys;
@property (nonatomic) int userDevice;

@end