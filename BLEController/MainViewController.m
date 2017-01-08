//
//  MainViewController.m
//  BLEController
//
//  Created by Avances on 27/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "MainViewController.h"
#import "ListadoVinculacionTableViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) CBCentralManager *CM;
@property (strong, nonatomic) NSMutableArray *peripherals;

@end

@implementation MainViewController
@synthesize ble;
@synthesize CM;
@synthesize peripherals;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
     
}

- (void)viewDidAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)goToList:(id)sender {
    
    /*
    UIViewController *vc ;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ListadoVinculacionTableViewController"];
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withCompletion:nil];
    */
}
- (IBAction)openApp:(id)sender {
    self.viBluetooth.hidden = YES;
}

- (IBAction)openBluetoothSettings:(id)sender {
    NSLog(@"openBluetoothSettings");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showDevices"]) {
        ListadoVinculacionTableViewController *vc = segue.destinationViewController;
        vc.ble = ble;
    }
}

#pragma mark - CBCentral delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
#if TARGET_OS_IPHONE
    NSLog(@"Status of CoreBluetooth central manager changed %d (%s)", central.state, [self centralManagerStateToString:central.state]);
#else
    [self isLECapableHardware];
#endif
    
    if (central.state == CBCentralManagerStatePoweredOff) {
        self.viBluetooth.hidden = NO;
    }
    if (central.state == CBCentralManagerStatePoweredOn) {
        self.viBluetooth.hidden = YES;
    }
    
}

- (BOOL) isLECapableHardware
{
    NSString * state = nil;
    
    switch ([CM state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
            
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
            
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
            
        case CBCentralManagerStatePoweredOn:
            return TRUE;
            
        case CBCentralManagerStateUnknown:
        default:
            return FALSE;
            
    }
    
    NSLog(@"Central manager state: %@", state);
    
    return FALSE;
}

- (const char *) centralManagerStateToString: (int)state
{
    switch(state)
    {
        case CBCentralManagerStateUnknown:
            return "State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return "State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return "State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return "State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return "State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return "State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return "State unknown";
    }
    
    return "Unknown state";
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (!self.peripherals) {
        self.peripherals = [[NSMutableArray alloc] initWithObjects:peripheral,nil];
        //self.peripheralsRssi = [[NSMutableArray alloc] initWithObjects:RSSI, nil];
    }
    else
    {
        for(int i = 0; i < self.peripherals.count; i++)
        {
            CBPeripheral *p = [self.peripherals objectAtIndex:i];
            
            if ((p.identifier == NULL) || (peripheral.identifier == NULL))
                continue;
            
            if ([self UUIDSAreEqual:p.identifier UUID2:peripheral.identifier])
            {
                [self.peripherals replaceObjectAtIndex:i withObject:peripheral];
                NSLog(@"Duplicate UUID found updating...");
                return;
            }
        }
        
        [self.peripherals addObject:peripheral];
        //[self.peripheralsRssi addObject:RSSI];
        
        NSLog(@"New UUID, adding");
    }
    
    NSLog(@"didDiscoverPeripheral");
}

- (BOOL) UUIDSAreEqual:(NSUUID *)UUID1 UUID2:(NSUUID *)UUID2
{
    if ([UUID1.UUIDString isEqualToString:UUID2.UUIDString])
        return TRUE;
    else
        return FALSE;
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (peripheral.identifier != NULL)
        NSLog(@"Connected to %@ successful", peripheral.identifier.UUIDString);
    else
        NSLog(@"Connected to NULL successful");
    
    //self.activePeripheral = peripheral;
    //[self.activePeripheral discoverServices:nil];
}


@end
