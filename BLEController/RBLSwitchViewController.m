//
//  RBLSwitchViewController.m
//  BLEController
//
//  Created by Avances on 21/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "RBLSwitchViewController.h"

uint8_t total_pin_count10  = 0;
uint8_t pin_mode10[128]    = {0};
uint8_t pin_cap10[128]     = {0};
uint8_t pin_digital10[128] = {0};
uint16_t pin_analog10[128]  = {0};
uint8_t pin_pwm10[128]     = {0};
uint8_t pin_servo10[128]   = {0};

uint8_t init_done10 = 0;

@interface RBLSwitchViewController ()

@property (nonatomic,strong)UIImage *active;
@property (nonatomic,strong)UIImage *inactive;

@end

@implementation RBLSwitchViewController

@synthesize switchActivated;
@synthesize ble;
@synthesize protocol;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    protocol = [[RBLProtocol alloc] init];
    protocol.delegate = self;
    protocol.ble = ble;
    
    self.active = [UIImage imageNamed:@"ico-vibr-on.png"];
    self.inactive = [UIImage imageNamed:@"ico-vibr-off.png"];
    self.image.image = self.inactive;
    switchActivated = NO;
    
}

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


NSTimer *syncTimer;

-(void) syncTimeout:(NSTimer *)timer
{
    NSLog(@"Timeout: no response");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"No response from the BLE Controller sketch."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    // disconnect it
    [ble.CM cancelPeripheralConnection:ble.activePeripheral];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"ControlView: viewDidAppear");
    self.aiLoad.hidden = NO;
    self.aiLoad.startAnimating;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Dispositivo 1" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:back];
    
    syncTimer = [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(syncTimeout:) userInfo:nil repeats:NO];
    
    [protocol queryProtocolVersion];
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"ControlView: viewDidDisappear");
    
    total_pin_count10 = 0;
    init_done10 = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    total_pin_count10 = count;
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
    
    pin_cap10[pin] = value;
    
    if (pin == 10) {
        [protocol setPinMode:10 Mode:OUTPUT];
    }
    else if (pin == 11) {
        [protocol setPinMode:11 Mode:OUTPUT];
    }
    
    if (pin >= 23){
        self.aiLoad.hidden = YES;
    }
}

-(void) protocolDidReceivePinData:(uint8_t)pin Mode:(uint8_t)mode Value:(uint8_t)value
{
    //    NSLog(@"protocolDidReceiveDigitalData");
    //    NSLog(@" Pin: %d, mode: %d, value: %d", pin, mode, value);
    
    uint8_t _mode = mode & 0x0F;
    
    pin_mode10[pin] = _mode;
    if ((_mode == INPUT) || (_mode == OUTPUT))
        pin_digital10[pin] = value;
    else if (_mode == ANALOG)
        pin_analog10[pin] = ((mode >> 4) << 8) + value;
    else if (_mode == PWM)
        pin_pwm10[pin] = value;
    else if (_mode == SERVO)
        pin_servo10[pin] = value;
    
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
    
    pin_mode10[pin] = mode;
}

-(void) protocolDidReceiveCustomData:(UInt8 *)data length:(UInt8)length
{
    // Handle your customer data here.
    for (int i = 0; i< length; i++)
        printf("0x%2X ", data[i]);
    printf("\n");
}

- (IBAction)toggleHL:(id)sender
{
    NSLog(@"High/Low clicked, pin id: %d", [sender tag]);
    
    uint8_t pin = [sender tag];
    UISegmentedControl *sgmControl = (UISegmentedControl *) sender;
    if ([sgmControl selectedSegmentIndex] == LOW)
    {
        [protocol digitalWrite:pin Value:LOW];
        pin_digital10[pin] = LOW;
    }
    else
    {
        [protocol digitalWrite:pin Value:HIGH];
        pin_digital10[pin] = HIGH;
    }
}

uint8_t current_pin = 0;

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    uint8_t correctIndex = (buttonIndex == 0) ? 10:11;
    NSLog(@"actionSheet button clicked, pin id: %d", correctIndex);
    NSLog(@"title: %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
    //NSLog(@"actionSheet button clicked, pin id: %d", buttonIndex);
    //NSLog(@"title: %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
    
    NSString *mode_str = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([mode_str isEqualToString:@"Input"])
    {
        [protocol setPinMode:current_pin Mode:INPUT];
    }
    else if ([mode_str isEqualToString:@"Output"])
    {
        [protocol setPinMode:current_pin Mode:OUTPUT];
    }
    else if ([mode_str isEqualToString:@"Analog"])
    {
        [protocol setPinMode:current_pin Mode:ANALOG];
    }
    else if ([mode_str isEqualToString:@"PWM"])
    {
        [protocol setPinMode:current_pin Mode:PWM];
    }
    else if ([mode_str isEqualToString:@"Servo"])
    {
        [protocol setPinMode:current_pin Mode:SERVO];
    }
}

- (IBAction)modeChange:(id)sender
{
    uint8_t pin = [sender tag];
    NSLog(@"Mode button clicked, pin id: %d", pin);
    
    NSString *title = [NSString stringWithFormat:@"Select Pin %d Mode", pin];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    
    if (pin_cap10[pin] & PIN_CAPABILITY_DIGITAL)
    {
        [sheet addButtonWithTitle:@"Input"];
        [sheet addButtonWithTitle:@"Output"];
    }
    
    if (pin_cap10[pin] & PIN_CAPABILITY_PWM)
        [sheet addButtonWithTitle:@"PWM"];
    
    if (pin_cap10[pin] & PIN_CAPABILITY_SERVO)
        [sheet addButtonWithTitle:@"Servo"];
    
    if (pin_cap10[pin] & PIN_CAPABILITY_ANALOG)
        [sheet addButtonWithTitle:@"Analog"];
    
    sheet.cancelButtonIndex = [sheet addButtonWithTitle: @"Cancel"];
    
    current_pin = pin;
    
    // Show the sheet
    [sheet showInView:self.view];
}

- (IBAction)sliderChange:(id)sender
{
    uint8_t pin = [sender tag];
    UISlider *sld = (UISlider *) sender;
    uint8_t value = sld.value;
    
    if (pin_mode10[pin] == PWM)
        pin_pwm10[pin] = value; // for updating the GUI
    else
        pin_servo10[pin] = value;
}

- (IBAction)sliderTouchUp:(id)sender
{
    uint8_t pin = [sender tag];
    UISlider *sld = (UISlider *) sender;
    uint8_t value = sld.value;
    NSLog(@"Slider, pin id: %d, value: %d", pin, value);
    
    if (pin_mode10[pin] == PWM)
    {
        pin_pwm10[pin] = value;
        [protocol analogWrite:pin Value:value];
    }
    else
    {
        pin_servo10[pin] = value;
        [protocol servoWrite:pin Value:value];
    }
}

- (IBAction)switchVibration:(id)sender {
        
    switchActivated = !switchActivated;
    
    if (switchActivated) {
        [protocol digitalWrite:10 Value:HIGH];
        [protocol digitalWrite:11 Value:HIGH];
        pin_digital10[10] = HIGH;
        pin_digital10[11] = HIGH;
        self.image.image = self.active;
        self.lblEstado.text = @"Activado";
        self.lblEstado.textColor = [UIColor colorWithRed:49/255.f green:213/255.f blue:145/255.f alpha:1.0];
    }
    else {
        [protocol digitalWrite:10 Value:LOW];
        [protocol digitalWrite:11 Value:LOW];
        pin_digital10[10] = LOW;
        pin_digital10[11] = LOW;
        self.image.image = self.inactive;
        self.lblEstado.text = @"Desactivado";
        self.lblEstado.textColor = [UIColor colorWithRed:173/255.f green:173/255.f blue:173/255.f alpha:1.0];
    }
    
    
}
@end
