//
//  AyudaViewController.m
//  BLEController
//
//  Created by Avances on 4/11/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "AyudaViewController.h"

static NSString *howItWorks;
static NSString *whatIsItFor;
static NSString *activate;
static UIImage *displayed;
static UIImage *hidden;
static UIImage *one;
static UIImage *two;
static UIImage *three;

float const heightDisplayed = 160;

@interface AyudaViewController ()

@end

@implementation AyudaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    howItWorks = @"El primer paso que debes realizar es enlazar tu prenda con la aplicación vía bluetooth, para ello ir a la opción de menú “conexión a ropa” y listo! De esta forma tu prenda inteligente podrá tener comunicación con tu app y podrás navegar en sus opciones.";
    whatIsItFor = @"De un primer vistazo podrás monitorear todos tus signos vitales, la app te brinda esta opción grupal, para ello ir a la opción de menú “Signos vitales - Grupal”. Si aún requieres consultar más detalles, puedes ir la opción de menú “Signos vitales -Individual”.";
    activate = @"Puedes hacer uso de la función de vibración de tu prenda desde tu app, aprovecha esta buena ventaja, para ello ir a la opción de menú “Vibración de prenda”. La función de vibración también se activa de forma automática, si la lectura de alguno de tus signos vitales están fuera de rango.";
    
    displayed = [UIImage imageNamed:@"ico-help-on.png"];
    hidden = [UIImage imageNamed:@"ico-help-off.png"];
    one = [UIImage imageNamed:@"help-001.png"];
    two = [UIImage imageNamed:@"help-002.png"];
    three = [UIImage imageNamed:@"help-003.png"];
    
    self.lbCF.text = howItWorks;
    self.lbPQS.text = whatIsItFor;
    self.lbAP.text = activate;
    
    [self tapHowItWorks:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapHowItWorks:(UITapGestureRecognizer *)sender {
    
    [UIView animateWithDuration:2.0 animations:^{
        self.ivMain.image = one;
        
        self.lcHeightCF.constant = heightDisplayed;
        self.lcHeightPQS.constant = 0;
        self.lcHeightAP.constant = 0;
        
        self.viCCF.hidden = NO;
        self.viCPQS.hidden = YES;
        self.viCAP.hidden = YES;
        
        self.ivCF.image = displayed;
        self.ivPQS.image = hidden;
        self.ivAP.image = hidden;
        
    } completion:^(BOOL finished) {
    }];
    
    
}

- (IBAction)tapWhatIsItFor:(UITapGestureRecognizer *)sender {
    
    [UIView animateWithDuration:2.0 animations:^{
        self.ivMain.image = two;
        
        self.lcHeightCF.constant = 0;
        self.lcHeightPQS.constant = heightDisplayed;
        self.lcHeightAP.constant = 0;
        
        self.viCCF.hidden = YES;
        self.viCPQS.hidden = NO;
        self.viCAP.hidden = YES;
        
        self.ivCF.image = hidden;
        self.ivPQS.image = displayed;
        self.ivAP.image = hidden;
        
    } completion:^(BOOL finished) {
    }];
    
}

- (IBAction)tapActivate:(UITapGestureRecognizer *)sender {
    
    [UIView animateWithDuration:2.0 animations:^{
        self.ivMain.image = three;
        
        self.lcHeightCF.constant = 0;
        self.lcHeightPQS.constant = 0;
        self.lcHeightAP.constant = heightDisplayed;
        
        self.viCCF.hidden = YES;
        self.viCPQS.hidden = YES;
        self.viCAP.hidden = NO;
        
        self.ivCF.image = hidden;
        self.ivPQS.image = hidden;
        self.ivAP.image = displayed;
        
    } completion:^(BOOL finished) {
    }];
    
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
@end
