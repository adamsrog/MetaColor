//
//  RAKulerSelectTableViewController.h
//  RAKulerizer
//
//  Created by Roger Adams on 4/7/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAKulerObject.h"

@interface RAKulerSelectTableViewController : UITableViewController <NSXMLParserDelegate, UIAlertViewDelegate> {
    
    UITableView              *_tableView;
    UIActivityIndicatorView  *_activityIndicatorView;
    UIRefreshControl         *_refreshControl;
    NSMutableArray           *_kulers;
    RAKulerObject            *_kulerObject;
    RAKulerSwatch            *_kulerSwatch;
    NSIndexPath              *_rowToDelete;
    int                       _kulerSource;
    int                       _parseItemCount;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, retain) NSMutableArray *kulers;
@property (nonatomic, retain) RAKulerObject *kulerObject;
@property (nonatomic, retain) RAKulerSwatch *kulerSwatch;
@property (nonatomic, retain) NSString *currentProperty;
@property (nonatomic) int kulerSource;

@end
