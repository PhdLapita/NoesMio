
/*
 
 Copyright (c) 2013-2014 RedBearLab
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "RBLAppDelegate.h"
#import "TutorialRootViewController.h"

@interface RBLAppDelegate ()

@property (strong, nonatomic) CBCentralManager *CM;

@end

@implementation RBLAppDelegate

@synthesize CM;
@synthesize ble;
@synthesize protocol;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    ble = [BLE sharedInstance];
    
    //protocol = [[RBLProtocol alloc] init];
    protocol = [RBLProtocol sharedInstance];
    
    
    
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    //MENU
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    MenuTableViewController *menu = (MenuTableViewController*)[mainStoryboard
                                                               instantiateViewControllerWithIdentifier: @"MenuTableViewController"];
    
    [SlideNavigationController sharedInstance].leftMenu = menu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    [SlideNavigationController sharedInstance].enableShadow = NO;
    
    
    
    NSDictionary *VALUES_TEMPERATURE = @{@"normal":@[@36.5,@37.2], @"out":@[@37.3,@39]};
    NSDictionary *VALUES_RESPIRATION = @{@"normal":@[@12,@16], @"out":@[@17,@25]};
    NSDictionary *VALUES_CARDIO = @{@"normal":@[@60,@100], @"out":@[@101,@200]};
    NSDictionary *VALUES_MOVEMENT = @{@"normal":@[@50,@70], @"out":@[@80,@100]};
    
    
    RBLAppDelegate *appDelegate = [RBLAppDelegate sharedAppDelegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Parameters" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
        
        RBLAppDelegate *appDelegate = [RBLAppDelegate sharedAppDelegate];
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        
        NSManagedObject *failedBankInfo = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Parameters"
                                           inManagedObjectContext:context];
        [failedBankInfo setValue:[NSNumber numberWithFloat:[[VALUES_TEMPERATURE objectForKey:@"normal"][0] floatValue]] forKey:@"tNormalSince"];
        [failedBankInfo setValue:[NSNumber numberWithFloat:[[VALUES_TEMPERATURE objectForKey:@"normal"][1] floatValue]] forKey:@"tNormalUntil"];
        
        [failedBankInfo setValue:[NSNumber numberWithFloat:[[VALUES_RESPIRATION objectForKey:@"normal"][0] floatValue]] forKey:@"rNormalSince"];
        [failedBankInfo setValue:[NSNumber numberWithFloat:[[VALUES_RESPIRATION objectForKey:@"normal"][1] floatValue]] forKey:@"rNormalUntil"];
        
        [failedBankInfo setValue:[NSNumber numberWithFloat:[[VALUES_CARDIO objectForKey:@"normal"][0] floatValue]] forKey:@"cNormalSince"];
        [failedBankInfo setValue:[NSNumber numberWithFloat:[[VALUES_CARDIO objectForKey:@"normal"][1] floatValue]] forKey:@"cNormalUntil"];
        
        [failedBankInfo setValue:[NSNumber numberWithFloat:[[VALUES_MOVEMENT objectForKey:@"normal"][0] floatValue]] forKey:@"mNormalSince"];
        [failedBankInfo setValue:[NSNumber numberWithFloat:[[VALUES_MOVEMENT objectForKey:@"normal"][1] floatValue]] forKey:@"mNormalUntil"];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        else {
            NSLog(@"Register saved");
        }
    }
    
    /*
    NSEntityDescription *entity2 = [NSEntityDescription
                                   entityForName:@"App" inManagedObjectContext:context];
    [fetchRequest setEntity:entity2];
    NSArray *fetchedObjects2 = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects2.count == 0) {
        
        NSManagedObject *failedBankInfo = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"App"
                                           inManagedObjectContext:context];
        [failedBankInfo setValue:@YES forKey:@"first"];
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        else {
            NSLog(@"Register saved");
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TutorialRootViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TutorialRootViewController"];
        self.window.rootViewController = vc;
        
    }
    
    */
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TutorialRootViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TutorialRootViewController"];
    self.window.rootViewController = vc;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.avancestecnologicos.Cuponeo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Cuponeo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Cuponeo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

+ (RBLAppDelegate *)sharedAppDelegate{
    return (RBLAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - CBDelegate implementation

#pragma mark - CBCentral delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"APP DELEGATE DID UPDATE STATE");
    
    if (central.state == CBCentralManagerStatePoweredOff) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Advertencia"
                                                                             message:@"Se ha desconectado el bluetooth del iPhone; perdiéndose conectividad con el dispositivo de la prenda."
                                                                            delegate:self
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
        [alert show];
        
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

@end
