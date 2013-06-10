//
//  SettingsTableViewController.m
//  RAKulerizer
//
//  Created by Roger Adams on 2/2/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()
@end

@implementation SettingsTableViewController

#pragma mark - View Methods

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = BACKGROUND_DARK;
    self.tableView.backgroundView.hidden = YES;
    
    NSArray *settingsContents = @[NSLocalizedString(@"FAQ", @"FAQ")];
    
    NSArray *companyContents = @[NSLocalizedString(@"SIMPLICITYSTUDIOS", @"Simplicity Studios")];
    
    self.tableContents = [[NSDictionary alloc] initWithObjectsAndKeys:
                          settingsContents, NSLocalizedString(@"SETTINGS", @"Settings"),
                          companyContents, NSLocalizedString(@"ABOUT", @"About"), nil];
    
    self.sortedKeys = self.tableContents.allKeys;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections
    return self.tableContents.allKeys.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.tableContents.allKeys[section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // create label with section header
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 4, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.text = sectionTitle;
    
    // create header view and add label as a subview then return it
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40.0)];
    [view addSubview:label];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *sectionFooter = [self tableView:tableView titleForFooterInSection:section];
    
    if (section == 1) sectionFooter = NSLocalizedString(@"FOOTER_TEXT", @"Footer");
    if (!sectionFooter) return nil;
    
    // create label with section footer
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, 300, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.text = sectionFooter;
    
    // create footer view and add the label as a subview then return it
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20.0)];
    [view addSubview:label];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray *listData = [self.tableContents objectForKey:[self.sortedKeys objectAtIndex:section]];
	return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    NSArray *listData = [self.tableContents objectForKey:[self.sortedKeys objectAtIndex:indexPath.section]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    // global cell settings
    cell.textLabel.text = [listData objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Ultra" size:22.0];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = BACKGROUND_LIGHT;
    
    // customize individual cells based on textLabel.text
    if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"FAQ", @"FAQ")]) {
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12.0];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = NSLocalizedString(@"FAQ_SUBTEXT", @"FAQ Subtext");
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"SIMPLICITYSTUDIOS", @"Simplicity Studios")]) {
        cell.imageView.image = [UIImage imageNamed:@"ssLogoIcon"];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"ADOBEKULER", @"Adobe Kuler")]) {
        //cell.imageView.image = [UIImage imageNamed:@"ideativeLogoIcon"];
    }
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // determine which row was pressed
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                // user selected FAQ
                break; 
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        
        NSArray *listData =[self.tableContents objectForKey:
                            [self.sortedKeys objectAtIndex:[indexPath section]]];
        NSString *rowValue = listData[indexPath.row];
        
        AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        aboutViewController.companyIndex = indexPath.row;
        aboutViewController.title = rowValue;
        [self.navigationController pushViewController:aboutViewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
