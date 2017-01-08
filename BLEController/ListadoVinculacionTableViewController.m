//
//  ListadoVinculacionTableViewController.m
//  BLEController
//
//  Created by Avances on 27/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "ListadoVinculacionTableViewController.h"
#import "ItemVInculacionTableViewCell.h"
#import "SignosVitalesViewController.h"
#import "MainViewController.h"

NSString * const  UUIDPrefKey3 = @"UUIDPrefKey";

static UIColor *green;
static UIColor *gray;

SignosVitalesViewController *cv;

@interface ListadoVinculacionTableViewController ()

@property int numberOfDevices;
@property (nonatomic,strong)UIImage *activeDevice;
@property (nonatomic,strong)UIImage *inactiveDevice;
@property (nonatomic,strong)NSTimer *timerTemp;

@end

@implementation ListadoVinculacionTableViewController

@synthesize numberOfDevices;
@synthesize activeDevice;
@synthesize inactiveDevice;

@synthesize ble;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    green = [UIColor colorWithRed:36/255.f green:162/255.f blue:43/255.f alpha:1.0];
    gray = [UIColor colorWithRed:174/255.f green:174/255.f blue:174/255.f alpha:1.0];

    ble = [BLE sharedInstance];
    [ble controlSetup];
    ble.delegate = self;
    
    numberOfDevices = 2;
    activeDevice = [UIImage imageNamed:@"scan-select-on.png"];
    inactiveDevice = [UIImage imageNamed:@"scan-select-off.png"];
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:
                                       [[UIImage imageNamed:@"scan-background.png"] stretchableImageWithLeftCapWidth:0.0
                                                                                                   topCapHeight:5.0]];
    
    self.mDevices = [[NSMutableArray alloc] init];
    self.mDevicesName = [[NSMutableArray alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:UUIDPrefKey3];
    }
    
    //Retrieve saved UUID from system
    self.lastUUID = [[NSUserDefaults standardUserDefaults] objectForKey:UUIDPrefKey3];
    
    self.BLEDevicesRssi = [NSMutableArray arrayWithArray:ble.peripheralsRssi];
            
}

- (void)viewDidAppear:(BOOL)animated {

    ble.delegate = self;
    
    self.timerTemp = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(loadDevices) userInfo:nil repeats:NO];
}

- (void)loadDevices{
    
    NSLog(@"loadDevices");
    
    if (ble.activePeripheral)
        if(ble.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
            return;
        }
    
    if (ble.peripherals)
        ble.peripherals = nil;
    
    [ble findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimerMain:) userInfo:nil repeats:NO];
    
}

- (IBAction)lastClick:(id)sender {
    
    if (ble.peripherals) {
        ble.peripherals = nil;
    }
    
    [ble findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimerMain:) userInfo:nil repeats:NO];
    
    isFindingLast = true;
    
    [self.timerTemp invalidate];
}


-(void) connectionTimerMain:(NSTimer *)timer
{
    
    NSLog(@"connectionTimerMain, %i, %@", ble.peripherals.count, isFindingLast ? @"YES" : @"NO");
    
    showAlert = YES;
    
    self.lastUUID = [[NSUserDefaults standardUserDefaults] objectForKey:UUIDPrefKey3];
    
    if (ble.peripherals.count > 0)
    {
        if(isFindingLast)
        {
            int i;
            for (i = 0; i < ble.peripherals.count; i++)
            {
                CBPeripheral *p = [ble.peripherals objectAtIndex:i];
                
                if (p.UUID != NULL)
                {
                    //Comparing UUIDs and call connectPeripheral is matched
                    if([self.lastUUID isEqualToString:[self getUUIDString:p.UUID]])
                    {
                        showAlert = NO;
                        [ble connectPeripheral:p];
                    }
                }
            }
        }
        else
        {
            [self.mDevices removeAllObjects];
            [self.mDevicesName removeAllObjects];
            
            int i;
            for (i = 0; i < ble.peripherals.count; i++)
            {
                CBPeripheral *p = [ble.peripherals objectAtIndex:i];
                
                if (p.UUID != NULL)
                {
                    [self.mDevices insertObject:[self getUUIDString:p.UUID] atIndex:i];
                    if (p.name != nil) {
                        [self.mDevicesName insertObject:p.name atIndex:i];
                    } else {
                        [self.mDevicesName insertObject:@"RedBear Device" atIndex:i];
                    }
                }
                else
                {
                    [self.mDevices insertObject:@"NULL" atIndex:i];
                    [self.mDevicesName insertObject:@"RedBear Device" atIndex:i];
                }
            }
            showAlert = NO;
            //[self performSegueWithIdentifier:@"showDevice" sender:self];
            
        }
    }
    
    if (showAlert == YES) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
         message:@"No BLE Device(s) found."
         delegate:self
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         [alert show];
    }
    self.BLEDevices = self.mDevices;
    self.BLEDevicesName = self.mDevicesName;
    [self.tableView reloadData];
    
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
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    self.BLEDevices = self.mDevices;
    self.BLEDevicesName = self.mDevicesName;
    
    [self.tableView reloadData];
}

-(void) bleDidConnect
{
    NSLog(@"->DidConnect");
    
    self.lastUUID = [self getUUIDString:ble.activePeripheral.UUID];
    [[NSUserDefaults standardUserDefaults] setObject:self.lastUUID forKey:UUIDPrefKey3];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.lastUUID = [[NSUserDefaults standardUserDefaults] objectForKey:UUIDPrefKey3];
    if ([self.lastUUID isEqualToString:@""]) {
        
    } else {

    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    SignosVitalesViewController *vc = (SignosVitalesViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: @"SignosVitalesViewController"];
    vc.ble = ble;
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withCompletion:nil];
    
}

- (void)bleDidDisconnect
{
    NSLog(@"->DidDisconnect");

    //[self.navigationController popToRootViewControllerAnimated:true];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [ble connectPeripheral:[ble.peripherals objectAtIndex:indexPath.row]];
    
    
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
#if defined(MV_DEBUG)
    NSLog(@"->DidReceiveData");
#endif
    
    if (cv != nil)
    {
        [cv processData:data length:length];
    }
}

-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    NSLog(@"DidUpdate RSSI");
}

-(NSString *)getUUIDString:(CFUUIDRef)ref {
    NSString *str = [NSString stringWithFormat:@"%@", ref];
    return [[NSString stringWithFormat:@"%@", str] substringWithRange:NSMakeRange(str.length - 36, 36)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.BLEDevices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO
    NSString *uid = (ble.activePeripheral != nil) ? [ble.activePeripheral name] : @"";
    NSString *identif = [[ble.peripherals objectAtIndex:indexPath.row] name];
    ItemVInculacionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.lbDeviceName.text = [NSString stringWithFormat:@"Dispositivo %d", indexPath.row + 1];
    cell.lbDeviceId.text = [self.BLEDevices objectAtIndex:indexPath.row];

    BOOL activeDeviceStatus = NO;
    
    if ([uid isEqualToString:@""]) {
        activeDeviceStatus = NO;
    }
    else {
        activeDeviceStatus = ([identif isEqualToString:uid]) ? YES : NO;
    }
    cell.ivStatus.image = activeDeviceStatus ? activeDevice : inactiveDevice;
    cell.status = activeDeviceStatus ? YES : NO;
    cell.lbStatus.text = activeDeviceStatus ? @"Conectado" : @"Desconectado";
    cell.lbStatus.textColor = activeDeviceStatus ? green : gray;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemVInculacionTableViewCell *cell= (ItemVInculacionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.status) {
        /*
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        
        SignosVitalesViewController *vc = (SignosVitalesViewController*)[mainStoryboard
                                                                         instantiateViewControllerWithIdentifier: @"SignosVitalesViewController"];
        vc.ble = ble;
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withCompletion:nil];
         */
        [ble connectPeripheral:[ble.peripherals objectAtIndex:indexPath.row]];
    }
    else {
        cell.status = !cell.status;
        cell.ivStatus.image = (cell.status) ? activeDevice : inactiveDevice;
        cell.lbStatus.text = (cell.status) ? @"Conectado" : @"Desconectado";
        cell.lbStatus.textColor = (cell.status) ? green : gray;
        [ble connectPeripheral:[ble.peripherals objectAtIndex:indexPath.row]];
        
    }
    
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    ble.activePeripheral = nil;
    
    NSLog(@"alertviewdelegate");
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MainViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:NO andCompletion:nil];
    
}

@end
