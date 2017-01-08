
/*
 
 Copyright (c) 2013-2014 RedBearLab
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "RBLDetailViewController.h"
#import "RBLMainViewController.h"
#import "RBLControlViewController.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"

@implementation RBLDetailViewController

@synthesize BLEDevicesRssi;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.BLEDevicesRssi = [NSMutableArray arrayWithArray:ble.peripheralsRssi];
}

-(void) connectionTimer:(NSTimer *)timer
{
    [self.BLEDevices removeAllObjects];
    [self.BLEDevicesRssi removeAllObjects];
    [self.BLEDevicesName removeAllObjects];
    
    if (ble.peripherals.count > 0)
    {
        for (int i = 0; i < ble.peripherals.count; i++)
        {
            CBPeripheral *p = [ble.peripherals objectAtIndex:i];
            NSNumber *n = [ble.peripheralsRssi objectAtIndex:i];
            NSString *name = [[ble.peripherals objectAtIndex:i] name];
            
            if (p.UUID != NULL)
            {
                [self.BLEDevices insertObject:[self getUUIDString:p.UUID] atIndex:i];
                [self.BLEDevicesRssi insertObject:n atIndex:i];
                
                if (name != nil)
                {
                    [self.BLEDevicesName insertObject:name atIndex:i];
                }
                else
                {
                    [self.BLEDevicesName insertObject:@"RedBear Device" atIndex:i];
                }
            }
            else
            {
                [self.BLEDevices insertObject:@"NULL" atIndex:i];
                [self.BLEDevicesRssi insertObject:0 atIndex:i];
                [self.BLEDevicesName insertObject:@"RedBear Device" atIndex:i];
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No BLE Device(s) found."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@synthesize ble;

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.BLEDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"cell_uuid";
    //CellUuid *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier forIndexPath:indexPath];
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
    }
    
    cell.lblDispositivo.text = [NSString stringWithFormat:@"Dispositivo %i", indexPath.row +1];
    cell.lblUID.text = [self.BLEDevices objectAtIndex:indexPath.row];
    
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"ico-check.png" ] backgroundColor:[UIColor colorWithRed:0.0f green:213/255.f blue:140/255.f alpha:1.0f] callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"exito");
        [ble connectPeripheral:[ble.peripherals objectAtIndex:indexPath.row]];
        return YES;
    }];
    button.buttonWidth = 80;
    
    cell.rightButtons = @[button];

    
    NSMutableString *rssiString = [NSMutableString stringWithFormat:@"RSSI : %@", [self.BLEDevicesRssi objectAtIndex:indexPath.row]];
    
    return cell;
    
    /*
    cell.lblDispositivo.text = [NSString stringWithFormat:@"Dispositivo %li", indexPath.row +1];
    cell.lblUID.text = [self.BLEDevices objectAtIndex:indexPath.row];
    
    cell.lblUuid.text = [self.BLEDevices objectAtIndex:indexPath.row];
    
    NSMutableString *rssiString = [NSMutableString stringWithFormat:@"RSSI : %@", [self.BLEDevicesRssi objectAtIndex:indexPath.row]];
    cell.lblRssi.text = rssiString;

    cell.lblName.text = [self.BLEDevicesName objectAtIndex:indexPath.row];
    
    return cell;
     */
    
    
    
    /*
    // Configure the cell...
    UIFont *newFont = [UIFont fontWithName:@"Arial" size:13.5];

    cell.lblUuid.font = newFont;
    cell.lblUuid.text = [self.BLEDevices objectAtIndex:indexPath.row];
    
    newFont = [UIFont fontWithName:@"Arial" size:11.0];
    cell.lblRssi.font = newFont;
    NSMutableString *rssiString = [NSMutableString stringWithFormat:@"RSSI : %@", [self.BLEDevicesRssi objectAtIndex:indexPath.row]];
    cell.lblRssi.text = rssiString;
 
    newFont = [UIFont fontWithName:@"Arial" size:13.0];
    cell.lblName.font = newFont;
    cell.lblName.text = [self.BLEDevicesName objectAtIndex:indexPath.row];
    
    return cell;
     
     */
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDevice"])
    {
        RBLControlViewController *vc = [segue destinationViewController];
    }
    
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Button1" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // maybe show an action sheet with more options
        //[self.tableView setEditing:NO];
        
        [ble connectPeripheral:[ble.peripherals objectAtIndex:indexPath.row]];
        
        [self performSegueWithIdentifier:@"showDevice" sender:self];
        
        
    }];
    moreAction.backgroundColor = [UIColor blueColor];
    
    return @[moreAction];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[ble connectPeripheral:[ble.peripherals objectAtIndex:indexPath.row]];
}

-(NSString *)getUUIDString:(CFUUIDRef)ref
{
    NSString *str = [NSString stringWithFormat:@"%@", ref];
    return [[NSString stringWithFormat:@"%@", str] substringWithRange:NSMakeRange(str.length - 36, 36)];
}

@end
