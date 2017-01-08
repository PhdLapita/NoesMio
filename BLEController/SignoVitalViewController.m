
//
//  SignoVitalViewController.m
//  BLEController
//
//  Created by Avances on 29/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "SignoVitalViewController.h"
#import "Utils.h"
#import "DetalleSignoTableViewController.h"
#import "RBLAppDelegate.h"
#import "ListadoVinculacionViewController.h"

NSString * const  UUIDPrefKey5 = @"UUIDPrefKey";


static UIColor *green;
static UIColor *red;

int const TEMPERATURE = 1;
int const RESPIRATION = 2;
int const CARDIO = 3;
int const MOVEMENT = 4;

uint8_t total_pin_count3  = 0;
uint8_t pin_mode3[128]    = {0};
uint8_t pin_cap3[128]     = {0};
uint8_t pin_digital3[128] = {0};
uint16_t pin_analog3[128]  = {0};
uint8_t pin_pwm3[128]     = {0};
uint8_t pin_servo3[128]   = {0};

uint8_t init_done3 = 0;

SignoVitalViewController *cv;

@interface SignoVitalViewController ()

@property(nonatomic, strong)NSDictionary *vitalSign;
@property(nonatomic, strong)NSTimer *timerIndicator;

@property(nonatomic,strong)NSArray *rank;

@end

@implementation SignoVitalViewController

@synthesize indicatorType;
@synthesize vitalSign;
@synthesize timerIndicator;
@synthesize ble;
@synthesize protocol;
@synthesize switchActivated;
@synthesize rank;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    green = [UIColor colorWithRed:36/255.f green:162/255.f blue:43/255.f alpha:1.0];
    red = [UIColor colorWithRed:226/255.f green:79/255.f blue:84/255.f alpha:1.0];
    
    NSLog(@"SignoVitalViewController viewDidLoad");
    NSLog(@"self.indicatorType: %d", indicatorType);
    
    NSDictionary *cardio = @{@"title": @"Cardio",
                             @"titleDescription": @"Frecuencia Cardiaca",
                             @"measure": @"Pulsos",
                             @"images": @[@"signo-individual-bg-general-card-off.png", @"signo-individual-bg-general-card-on.png"],
                             @"quantities": @[@60, @62, @63, @65, @66, @70, @73, @74, @78, @79, @101],
                             @"status": @"Saludable",
                             @"description": @"Recién nacidos de 0 a 1 mes  de edad: 70 a 190 latidos por minuto.\n\nBebés de 1 a 11 meses de edad: 80 a 160 latidos por minuto.\n\nNiños de 1 a 2 años de edad: 80 a 130 latidos por minuto.\n\nNiños de 3 a 4 años de edad: 80 a 120 latidos por minuto.\n\nNiños de 5 a 6 años de edad: 75 a 115 latidos por minuto.\n\nNiños de 7 a 9 años de edad: 70 a 110 latidos por minuto.\n\nNiños de 10 años o más y adultos (incluso ancianos): 60 a 100 latidos por minuto.\nAtletas bien entrenados: de 40 a 60 latidos por minuto.\n\nFuente: Bernstein D. Evaluation of the cardiovascular system."
                             },
    *temperature = @{@"title": @"Temperatura",
                     @"titleDescription": @"Temperatura Corporal",
                     @"measure": @"Grados",
                     @"images": @[@"signo-individual-bg-general-tem-off.png", @"signo-individual-bg-general-tem-on.png"],
                     @"quantities": @[@36.5, @36.6, @36.7, @36.8, @36.9, @37, @37.1, @37.2, @38, @38, @38],
                     @"status": @"Saludable",
                     @"description": @"36.5 – 37.2 según A.M.A. (Asociación Medica Americana).\n\nEs importante indicar las diferencias de temperatura en lugares estratégicos como Axilar 37 (+, -) 0.2 Oral 37.3, rectal 37.5 (Según cátedra de Semiología)"
                     },
    *respiration = @{@"title": @"Respiración",
                     @"titleDescription": @"Frecuencia Respiratoria",
                     @"measure": @"Pulsos",
                     @"images": @[@"signo-individual-bg-general-res-off.png", @"signo-individual-bg-general-res-on.png"],
                     @"quantities": @[@7, @8, @9, @10, @11, @12, @14, @14, @15, @16, @17],
                     @"status": @"Saludable",
                     @"description" : @"En adultos: 12 a 20 respiraciones por minuto. Los recién nacidos y los niños presentan frecuencias respiratorias más elevadas.\n\nTaquipnea: sobre 20 respiraciones por minuto (en adultos).\n\nBradipnea: menos de 12 respiraciones por minuto (en adultos).\n\nTipos de respiración: (Notas de Ayuda)\n\nFuente: Manual de Semiología (2007)"
                     },
    *movement = @{@"title": @"Movimiento",
                  @"titleDescription": @"Movimiento y Latidos del Corazón",
                  @"measure": @"Pulsos",
                  @"images": @[@"signo-individual-bg-general-mov-off.png", @"signo-individual-bg-general-mov-on.png"],
                  @"quantities": @[@70, @71, @72, @73, @74, @75, @76, @77, @78, @79, @80],
                  @"status": @"Saludable",
                  @"description": @"Entre 60 y 80 p.p.m - Reposo - Aeróbica.\n\nEntre 90 y 120 p.p.m. - Muy baja - Aeróbica.\n\nEntre 130 y 150 p.p.m. - Baja - Aeróbica.\n\nEntre 160 y 170 p.p.m. - Mediana - Aeróbica.\n\nEntre 180 y 190 p.p.m - Alta - Anaeróbica.\n\nEntre 200 y 220 p.p.m. - Muy alta - Anaeróbica."
                  };
    UIColor *temperatureColor = [UIColor colorWithRed:67/255.f green:174/255.f blue:191/255.f alpha:1.0],
    *respirationColor = [UIColor colorWithRed:155/255.f green:193/255.f blue:105/255.f alpha:1.0],
    *cardioColor = [UIColor colorWithRed:226/255.f green:79/255.f blue:84/255.f alpha:1.0],
    *movementColor = [UIColor colorWithRed:237/255.f green:161/255.f blue:52/255.f alpha:1.0];
    
    switch (indicatorType) {
        case TEMPERATURE:
            vitalSign = temperature;
            self.ivBackground.backgroundColor = temperatureColor;
            [self.btDetail setTitleColor:temperatureColor forState:UIControlStateNormal];
            break;
        case RESPIRATION:
            vitalSign = respiration;
            self.ivBackground.backgroundColor = respirationColor;
            [self.btDetail setTitleColor:respirationColor forState:UIControlStateNormal];
            break;
        case CARDIO:
            vitalSign = cardio;
            self.ivBackground.backgroundColor = cardioColor;
            [self.btDetail setTitleColor:cardioColor forState:UIControlStateNormal];
            break;
        case MOVEMENT:
            vitalSign = movement;
            self.ivBackground.backgroundColor = movementColor;
            [self.btDetail setTitleColor:movementColor forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    NSMutableArray *img = [NSMutableArray new];
    for (int i = 0; i < 2; i++) {
        [img addObject:[UIImage imageNamed:[[vitalSign objectForKey:@"images"] objectAtIndex:i]]];
    }
    self.ivLogo.animationImages = img;
    self.ivLogo.animationDuration = 1.0;
    self.lbTitle.text = [vitalSign objectForKey:@"title"];
    self.lbMeasure.text = [vitalSign objectForKey:@"measure"];
    self.lbStatus.text = [vitalSign objectForKey:@"status"];
    self.lbDescription.text = [vitalSign objectForKey:@"description"];
    self.lbDay.text = [Utils getDayTextDate];
    self.lbMonth.text = [Utils getMonthShortTextDate];
    self.lbTitleDescription.text = [vitalSign objectForKey:@"titleDescription"];
    [self.ivLogo startAnimating];
    
    
    ble = [BLE sharedInstance];
    ble.delegate = self;
    
    protocol = [RBLProtocol sharedInstance];
    protocol.delegate = self;
    protocol.ble = ble;
    switchActivated = NO;
    
    rank = [NSArray new];
    
    timerIndicator = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeValueIndicator) userInfo:nil repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"SignoVitalViewController viewDidAppear");
    [self.lbDescription sizeToFit];
    
    //syncTimer = [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(syncTimeout:) userInfo:nil repeats:NO];
    
    //[protocol queryProtocolVersion];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"viewWillDisappear");
    [timerIndicator invalidate];
    total_pin_count3 = 0;
    init_done3 = 0;
    [self stopVibration];
    ble.delegate = nil;
    protocol.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BLE implementation


NSTimer *syncTimer;

-(void) syncTimeout:(NSTimer *)timer
{
    NSLog(@"Timeout: no response");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"No response from the BLE Controller sketch."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    // disconnect it
    [ble.CM cancelPeripheralConnection:ble.activePeripheral];
}



-(void) processData:(uint8_t *) data length:(uint8_t) length
{
#if defined(CV_DEBUG)
    NSLog(@"ControlView: processData");
    NSLog(@"Length: %d", length);
#endif
    
    [protocol parseData:data length:length];
}

-(void) protocolDidReceiveProtocolVersion:(uint8_t)major Minor:(uint8_t)minor Bugfix:(uint8_t)bugfix
{
    NSLog(@"protocolDidReceiveProtocolVersion: %d.%d.%d", major, minor, bugfix);
    
    // get response, so stop timer
    [syncTimer invalidate];
    
    uint8_t buf[] = {'B', 'L', 'E'};
    [protocol sendCustomData:buf Length:3];
    
    [protocol queryTotalPinCount];
}

-(void) protocolDidReceiveTotalPinCount:(UInt8) count
{
    NSLog(@"protocolDidReceiveTotalPinCount: %d", count);
    
    total_pin_count3 = count;
    [protocol queryPinAll];
}

-(void) protocolDidReceivePinCapability:(uint8_t)pin Value:(uint8_t)value
{
    NSLog(@"protocolDidReceivePinCapability");
    NSLog(@" Pin %d Capability: 0x%02X", pin, value);
    
    if (value == 0)
        NSLog(@" - Nothing");
    else
    {
        if (value & PIN_CAPABILITY_DIGITAL)
            NSLog(@" - DIGITAL (I/O)");
        if (value & PIN_CAPABILITY_ANALOG)
            NSLog(@" - ANALOG");
        if (value & PIN_CAPABILITY_PWM)
            NSLog(@" - PWM");
        if (value & PIN_CAPABILITY_SERVO)
            NSLog(@" - SERVO");
    }
    
    pin_cap3[pin] = value;
    
    if (pin == 10) {
        [protocol setPinMode:10 Mode:OUTPUT];
    }
    else if (pin == 11) {
        [protocol setPinMode:11 Mode:OUTPUT];
    }
    
    if (pin >= 23){
        //self.aiLoad.hidden = YES;
    }
}

-(void) protocolDidReceivePinData:(uint8_t)pin Mode:(uint8_t)mode Value:(uint8_t)value
{
    //    NSLog(@"protocolDidReceiveDigitalData");
    //    NSLog(@" Pin: %d, mode: %d, value: %d", pin, mode, value);
    
    uint8_t _mode = mode & 0x0F;
    
    pin_mode3[pin] = _mode;
    if ((_mode == INPUT) || (_mode == OUTPUT))
        pin_digital3[pin] = value;
    else if (_mode == ANALOG)
        pin_analog3[pin] = ((mode >> 4) << 8) + value;
    else if (_mode == PWM)
        pin_pwm3[pin] = value;
    else if (_mode == SERVO)
        pin_servo3[pin] = value;
    
}

-(void) protocolDidReceivePinMode:(uint8_t)pin Mode:(uint8_t)mode
{
    NSLog(@"protocolDidReceivePinMode");
    
    if (mode == INPUT)
        NSLog(@" Pin %d Mode: INPUT", pin);
    else if (mode == OUTPUT)
        NSLog(@" Pin %d Mode: OUTPUT", pin);
    else if (mode == PWM)
        NSLog(@" Pin %d Mode: PWM", pin);
    else if (mode == SERVO)
        NSLog(@" Pin %d Mode: SERVO", pin);
    
    pin_mode3[pin] = mode;
}

-(void) protocolDidReceiveCustomData:(UInt8 *)data length:(UInt8)length
{
    // Handle your customer data here.
    for (int i = 0; i< length; i++)
        printf("0x%2X ", data[i]);
    printf("\n");
}

-(void) bleDidConnect
{
    NSLog(@"->DidConnect");
    
    self.lastUUID = [self getUUIDString:ble.activePeripheral.UUID];
    [[NSUserDefaults standardUserDefaults] setObject:self.lastUUID forKey:UUIDPrefKey5];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.lastUUID = [[NSUserDefaults standardUserDefaults] objectForKey:UUIDPrefKey5];
    if ([self.lastUUID isEqualToString:@""]) {
        
    } else {
        
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    /*
    SignoVitalViewController *vc = (SignoVitalViewController*)[mainStoryboard
                                                                     instantiateViewControllerWithIdentifier: @"SignosVitalesViewController"];
    vc.ble = ble;
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withCompletion:nil];
     */
    
}

- (void)bleDidDisconnect
{
    NSLog(@"->DidDisconnect");
    
    //[self.navigationController popToRootViewControllerAnimated:true];
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
}

-(NSString *)getUUIDString:(CFUUIDRef)ref {
    NSString *str = [NSString stringWithFormat:@"%@", ref];
    return [[NSString stringWithFormat:@"%@", str] substringWithRange:NSMakeRange(str.length - 36, 36)];
}


#pragma mark - Page implementation

- (void)changeValueIndicator{
    self.lbQuantity.text = [Utils pickRandomValue:[vitalSign objectForKey:@"quantities"]];
    [self.lbDescription sizeToFit];
    [self validateVibration];
}

- (void)validateVibration{
    NSLog(@"validateVibration : %i", rank.count);
    BOOL isVibrating = NO;
    if (rank.count == 0) {
        RBLAppDelegate *appDelegate = [RBLAppDelegate sharedAppDelegate];
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Parameters" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        NSArray *rankMov, *rankResp, *rankTemp, *rankCardio;
        for (NSManagedObject *info in fetchedObjects) {
            rankMov = @[[info valueForKey:@"mNormalSince"], [info valueForKey:@"mNormalUntil"]];
            rankResp = rank = @[[info valueForKey:@"rNormalSince"], [info valueForKey:@"rNormalUntil"]];
            rankTemp = @[[info valueForKey:@"tNormalSince"], [info valueForKey:@"tNormalUntil"]];
            rankCardio = @[[info valueForKey:@"cNormalSince"], [info valueForKey:@"cNormalUntil"]];
        }
        
        switch (indicatorType) {
            case TEMPERATURE:
                rank = rankTemp;
                break;
            case RESPIRATION:
                rank = rankResp;
                break;
            case CARDIO:
                rank = rankCardio;
                break;
            case MOVEMENT:
                rank = rankMov;
                break;
            default:
                break;
        }
        
    }
    
    if (rank.count != 0) {
        if ([self.lbQuantity.text floatValue] < [rank[0] floatValue] ||
            [self.lbQuantity.text floatValue] > [rank[1] floatValue]) {
            isVibrating = YES;
        }
        
        NSLog(@"isVibrating %@", isVibrating ? @"YES" : @"NO");
        
        if (isVibrating) {
            self.lbStatus.textColor = red;
            self.lbStatus.text = @"No Saludable";
            [self vibrateDevice];
        }
        else {
            self.lbStatus.textColor = green;
            self.lbStatus.text = @"Saludable";
            [self stopVibration];
        }
    }
}

- (void)vibrateDevice{

    [protocol digitalWrite:10 Value:HIGH];
    [protocol digitalWrite:11 Value:HIGH];
    pin_digital3[10] = HIGH;
    pin_digital3[11] = HIGH;
    NSLog(@"VIBRATING");
    NSLog(@"====================================================");
}
- (void)stopVibration{

    [protocol digitalWrite:10 Value:LOW];
    [protocol digitalWrite:11 Value:LOW];
    pin_digital3[10] = LOW;
    pin_digital3[11] = LOW;
    NSLog(@"NOT VIBRATING");
    NSLog(@"====================================================");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        DetalleSignoTableViewController *vc = segue.destinationViewController;
        vc.indicatorType = indicatorType;
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
    ListadoVinculacionViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ListadoVinculacionViewController"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:NO andCompletion:nil];
    
}

@end
