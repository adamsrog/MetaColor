//
//  RAKulerSelectTableViewController.m
//  RAKulerizer
//
//  Created by Roger Adams on 4/7/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import "RAKulerizerViewController.h"
#import "RAKulerSelectTableViewController.h"
#import "RAKulerInfoViewController.h"
#import "RAKulerCell.h"
#import "AFNetworking.h"

@interface RAKulerSelectTableViewController ()

@end

@implementation RAKulerSelectTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = BACKGROUND_DARK;
    [self.tableView registerClass:[RAKulerCell class] forCellReuseIdentifier:@"KulerCell"];
    
    // activity indicator view
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    // initialize the data source
    self.kulers = [[NSMutableArray alloc] init];
    
    // determine where to retrieve kulers from
    if (self.kulerSource == KULER_USER_SAVED) {
        
        // add "+" button for creating new Kuler
        UIBarButtonItem *addNewKuler = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewKulerButtonPressed:)];
        self.navigationItem.rightBarButtonItem = addNewKuler;
        
        // add long-press gesture for deleting saved kuler
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(removeKulerFromSaved:)];
        longPress.minimumPressDuration = 2.0;
        [self.tableView addGestureRecognizer:longPress];
        
        [self retrieveKulersFromDefaults];
        
    } else {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(retrieveKulersFromRSS) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refreshControl];
        [self retrieveKulersFromRSS];
    }
}

- (void)retrieveKulersFromDefaults {

    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"savedKulers"])
        NSLog(@"No saved Kulers found.. aborting.");
    else {
        NSData *kulerData = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedKulers"];
        self.kulers = [NSKeyedUnarchiver unarchiveObjectWithData:kulerData];
    }
    [self.navigationItem setTitle:@"Kulers"];
    [self kulersFinishedLoading];
}

- (void)retrieveKulersFromRSS {
    
    [self.kulers removeAllObjects];
    [self.tableView reloadData];
    
    NSURL *feedURL;
    
    switch (self.kulerSource) {
        case KULER_RSS_NEWEST:
            feedURL = [[NSURL alloc] initWithString:KULER_RSS_NEWEST_URL];
            [self.navigationItem setTitle:NSLocalizedString(@"BUTTON_NEWEST", @"Newest")];
            break;
        case KULER_RSS_POPULAR:
            feedURL = [[NSURL alloc] initWithString:KULER_RSS_POPULAR_URL];
            [self.navigationItem setTitle:NSLocalizedString(@"BUTTON_POPULAR", @"Popular")];
            break;
        case KULER_RSS_HIGHEST_RATED:
            feedURL = [[NSURL alloc] initWithString:KULER_RSS_HIGHEST_RATED_URL];
            [self.navigationItem setTitle:NSLocalizedString(@"BUTTON_TOPRATED", @"Top Rated")];
            break;
        case KULER_RSS_RANDOM:
            feedURL = [[NSURL alloc] initWithString:KULER_RSS_RANDOM_URL];
            [self.navigationItem setTitle:NSLocalizedString(@"BUTTON_RANDOM", @"Random")];
            break;
            
        default:
            break;
    }
    
    NSURLRequest *feedRequest = [[NSURLRequest alloc] initWithURL:feedURL];
    AFXMLRequestOperation *feedOperation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:feedRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        NSLog(@"XMLRequest successful - starting parser..");
        [XMLParser setDelegate:self];
        [XMLParser parse];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
        NSLog(@"Request error: %@", error);
        UIAlertView *connectionError = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CONNECTIONERROR", @"Connection Error") message:error.localizedDescription delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"TRYAGAIN", @"Try Again"), nil];
        connectionError.tag = 1;
        [connectionError show];
    }];
    
    [feedOperation start];
}

- (void)kulersFinishedLoading {
    if (self.kulers.count == 0) {
        // no kulers found - prompt for retry
        UIAlertView *noKulers = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOKULERS_TITLE", @"Unable to retrieve") message:NSLocalizedString(@"NOKULERS_MSG", @"Unable to retrieve") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"TRYAGAIN", @"Try Again"), nil];
        noKulers.tag = 1;
        [noKulers show];
    } else {
        // kulers found
        [self.tableView reloadData];
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ (%i)", self.navigationItem.title, self.kulers.count]];
        [self.refreshControl endRefreshing];
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Warning: didReceiveMemoryWarning...");
}

#pragma mark -

- (void)deleteKulerAtIndexPath:(NSIndexPath *)indexPath {
    
    // remove the kuler from the tableView
    [self.tableView beginUpdates];
    [self.kulers removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
    [self.tableView endUpdates];
    
    // save the kulers
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.kulers] forKey:@"savedKulers"];
    
    // set navigation bar title to updated kuler count
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Kulers (%i)", self.kulers.count]];
}

- (void)removeKulerFromSaved:(UILongPressGestureRecognizer *)sender {
    
    // confirm the gesture press is beginning
    if (sender.state == UIGestureRecognizerStateBegan) {
        // get indexPath of selected row
        CGPoint touchPoint = [sender locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
        if (!indexPath) return;
        else {
            // prepare to delete
            _rowToDelete = indexPath;
            RAKulerObject *kulerToDelete = self.kulers[indexPath.row];
            NSString *deletionMessage = [NSString stringWithFormat:@"%@ \"%@\"", NSLocalizedString(@"DELETION_MSG", "Deletion message"), kulerToDelete.themeTitle];
            
            // present alertView to confirm deletion
            UIAlertView *deleteRowConfirm = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DELETE", @"Delete") message:deletionMessage delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"No") otherButtonTitles:NSLocalizedString(@"DELETE", @"Delete"), nil];
            deleteRowConfirm.tag = 2;
            [deleteRowConfirm show];
        }
    }
}

- (void)addNewKulerButtonPressed:(id)sender {
    RAKulerInfoViewController *kulerInfo = [[RAKulerInfoViewController alloc] initWithNibName:@"RAKulerInfoViewController" bundle:nil];
    RAKulerObject *defaultKuler = [[RAKulerObject alloc] initWithID:@"No ID"
                                                              title:@"New"
                                                              image:nil
                                                           authorID:@"0000"
                                                        authorLabel:@"RAKulerizer"
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // number of rows
    if (self.kulers && self.kulers.count) return self.kulers.count;
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"KulerCell";
    RAKulerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    RAKulerObject *kuler = [self.kulers objectAtIndex:indexPath.row];
        
    if (!cell) cell = [[RAKulerCell alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    
    // create accessoryView containing five swatches
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(200, 6, 100, 20)];
    UIView *swatch2View = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 20, 20)];
    UIView *swatch3View = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 20, 20)];
    UIView *swatch4View = [[UIView alloc] initWithFrame:CGRectMake(60, 0, 20, 20)];
    UIView *swatch5View = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 20, 20)];
    accessoryView.backgroundColor = kuler.themeSwatch1.colorRGBFromHex;
    swatch2View.backgroundColor   = kuler.themeSwatch2.colorRGBFromHex;
    swatch3View.backgroundColor   = kuler.themeSwatch3.colorRGBFromHex;
    swatch4View.backgroundColor   = kuler.themeSwatch4.colorRGBFromHex;
    swatch5View.backgroundColor   = kuler.themeSwatch5.colorRGBFromHex;
    [accessoryView addSubview:swatch2View];
    [accessoryView addSubview:swatch3View];
    [accessoryView addSubview:swatch4View];
    [accessoryView addSubview:swatch5View];
    
    // customize tableView cell
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    cell.textLabel.text = kuler.themeTitle;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.numberOfLines = 2;
    cell.accessoryView = accessoryView;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.opaque = NO;

    return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    RAKulerInfoViewController *kulerInfo = [[RAKulerInfoViewController alloc] initWithNibName:@"RAKulerInfoViewController" bundle:nil];
    [kulerInfo setKuler:[self.kulers objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:kulerInfo animated:YES];
}

#pragma mark - NSXMLParser Delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"kuler:themeItem"]) {
        self.kulerObject = [[RAKulerObject alloc] init];
    }
    
    if ([elementName isEqualToString:@"kuler:swatch"]) {
        self.kulerSwatch = [[RAKulerSwatch alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentProperty = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if (!self.currentProperty) return;
    
    // <kuler:themeItem>
    if ([elementName isEqualToString:@"kuler:themeID"])
        self.kulerObject.themeID = self.currentProperty;
    else if ([elementName isEqualToString:@"kuler:themeTitle"])
        self.kulerObject.themeTitle = self.currentProperty;
    else if ([elementName isEqualToString:@"kuler:themeImage"])
        self.kulerObject.themeImageURL = [NSURL URLWithString:self.currentProperty];
    
    // <kuler:themeAuthor>
    else if ([elementName isEqualToString:@"kuler:authorID"])
        self.kulerObject.themeAuthorID = self.currentProperty;
    else if ([elementName isEqualToString:@"kuler:authorLabel"])
        self.kulerObject.themeAuthorLabel = self.currentProperty;
    // </kuler:themeAuthor>
    
    else if ([elementName isEqualToString:@"kuler:themeTags"])
        self.kulerObject.themeTags = self.currentProperty;
    else if ([elementName isEqualToString:@"kuler:themeRating"])
        self.kulerObject.themeRating = [self.currentProperty intValue];
    else if ([elementName isEqualToString:@"kuler:themeDownloadCount"])
        self.kulerObject.themeDownloadCount = [self.currentProperty intValue];
    else if ([elementName isEqualToString:@"kuler:themeCreatedAt"])
        self.kulerObject.themeCreatedAt = self.currentProperty;
    else if ([elementName isEqualToString:@"kuler:themeEditedAt"])
        self.kulerObject.themeEditedAt = self.currentProperty;
    
    // <kuler:themeSwatches> <kuler:swatch>
    else if ([elementName isEqualToString:@"kuler:swatchHexColor"])
        self.kulerSwatch.swatchHexColor = self.currentProperty;
    else if ([elementName isEqualToString:@"kuler:swatchColorMode"])
        self.kulerSwatch.swatchColorMode = self.currentProperty;
    else if ([elementName isEqualToString:@"kuler:swatchChannel1"])
        self.kulerSwatch.swatchChannel1 = [self.currentProperty floatValue];
    else if ([elementName isEqualToString:@"kuler:swatchChannel2"])
        self.kulerSwatch.swatchChannel2 = [self.currentProperty floatValue];
    else if ([elementName isEqualToString:@"kuler:swatchChannel3"])
        self.kulerSwatch.swatchChannel3 = [self.currentProperty floatValue];
    else if ([elementName isEqualToString:@"kuler:swatchChannel4"])
        self.kulerSwatch.swatchChannel4 = [self.currentProperty floatValue];
    else if ([elementName isEqualToString:@"kuler:swatchIndex"])
        self.kulerSwatch.swatchIndex = [self.currentProperty intValue];
    
    // </kuler:swatch>
    else if ([elementName isEqualToString:@"kuler:swatch"])
        [self.kulerObject setSwatch:self.kulerSwatch atIndex:self.kulerSwatch.swatchIndex];
    
    // </kuler:themeSwatches> </kuler:themeItem>
    else if ([elementName isEqualToString:@"pubDate"])
        self.kulerObject.themePublishDate = self.currentProperty;
    else if ([elementName isEqualToString:@"item"]) {
        //NSLog(@"%@", self.kulerObject.description);
        [self.kulers addObject:self.kulerObject];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {

    NSLog(@"Parsing Completed - Total Kulers: %i", self.kulers.count);
    [self kulersFinishedLoading];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"UIAlertViewDelegate tag: %i .. buttonIndex: %i", alertView.tag, buttonIndex);
    switch (alertView.tag) {
        case 1:
            // connection retry dialog
            switch (buttonIndex) {
                case 0:
                    // cancel
                    [self.navigationController popViewControllerAnimated:YES];
                    break;
                case 1:
                    // try again
                    [self retrieveKulersFromRSS];
                    break;
                default:
                    break;
            }
            break;
            
        case 2:
            // confirm row deletion
            switch (buttonIndex) {
                case 0:
                    // cancel
                    break;
                case 1:
                    // delete row
                    [self deleteKulerAtIndexPath:_rowToDelete];
                default:
                    break;
            }
            
        default:
            break;
    }
}

@end
