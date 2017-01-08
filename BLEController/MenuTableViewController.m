//
//  MenuTableViewController.m
//  BLEController
//
//  Created by Avances on 27/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MenuTableViewCell.h"
#import "MenuTitleTableViewCell.h"
#import "MenuTitleOptionsTableViewCell.h"
#import "TemporalViewController.h"
#import "SignoVitalViewController.h"
#import "ListadoVinculacionViewController.h"
#import "MainViewController.h"
#import "RBLAppDelegate.h"

@interface MenuTableViewController ()

@property(nonatomic,strong)UIAlertView *alerta;

@end

@implementation MenuTableViewController

@synthesize ble;

- (void)viewDidLoad {
    [super viewDidLoad];
    ble = [BLE sharedInstance];
    
    self.alerta = [[UIAlertView alloc] initWithTitle:@"Mensaje"
                                             message:@"Aún no te has conectado con el dispositivo de tu prenda. Ir a opción Conexión a ropa."
                                            delegate:self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
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
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MenuTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.row == 4) {
        MenuTitleOptionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optionsCell" forIndexPath:indexPath];
        UIImage *iMain = [UIImage imageNamed:@"men-signo-individual.png"],
        *iTemperatura = [UIImage imageNamed:@"men-sub-temp.png"],
        *iRespiracion = [UIImage imageNamed:@"men-sub-resp.png"],
        *iCardio = [UIImage imageNamed:@"men-sub-cardio.png"],
        *iMovimiento = [UIImage imageNamed:@"men-sub-mov.png"];
        NSDictionary *main = @{@"text": @"Signos Vitales - Individual", @"icon": iMain},
        *temperatura = @{@"text": @"Temperatura", @"icon": iTemperatura},
        *respiracion = @{@"text": @"Respiración", @"icon": iRespiracion},
        *cardio = @{@"text": @"Cardio", @"icon": iCardio},
        *movimiento = @{@"text": @"Movimiento", @"icon": iMovimiento};
        
        cell.lbMain.text = [main objectForKey:@"text"];
        cell.ivIconMain.image = [main objectForKey:@"icon"];
        cell.lbOne.text = [temperatura objectForKey:@"text"];
        cell.ivIconOne.image = [temperatura objectForKey:@"icon"];
        cell.lbTwo.text = [respiracion objectForKey:@"text"];
        cell.ivIconTwo.image = [respiracion objectForKey:@"icon"];
        cell.lbThree.text = [cardio objectForKey:@"text"];
        cell.ivIconThree.image = [cardio objectForKey:@"icon"];
        cell.lbFour.text = [movimiento objectForKey:@"text"];
        cell.ivIconFour.image = [movimiento objectForKey:@"icon"];
        
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOptionOne)];
        UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOptionTwo)];
        UITapGestureRecognizer *tapThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOptionThree)];
        UITapGestureRecognizer *tapFour = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOptionFour)];
        [cell.viOne addGestureRecognizer:tapOne];
        [cell.viTwo addGestureRecognizer:tapTwo];
        [cell.viThree addGestureRecognizer:tapThree];
        [cell.viFour addGestureRecognizer:tapFour];
        
        return cell;
        
    }
    else{
        UIImage *iHome = [UIImage imageNamed:@"men-home.png"],
        *iConnection = [UIImage imageNamed:@"men-vincular.png"],
        *iVitalSigns = [UIImage imageNamed:@"men-signo-grupal.png"],
        *iVibration = [UIImage imageNamed:@"men-vibracion.png"],
        *iParameters = [UIImage imageNamed:@"men-parametros.png"],
        *iHelp = [UIImage imageNamed:@"men-ayuda.png"];
        
        
        MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        NSDictionary *home = @{@"text": @"Inicio", @"icon": iHome};
        NSDictionary *connection = @{@"text": @"Conexión a ropa", @"icon": iConnection};
        NSDictionary *vitalSigns = @{@"text": @"Signos Vitales - Grupal", @"icon": iVitalSigns};
        //NSDictionary *vitalSign = @{@"text": @"Signos Vitales - Individual", @"icon": iVitalSign};
        NSDictionary *vibration = @{@"text": @"Vibración de prenda", @"icon": iVibration};
        NSDictionary *parameters = @{@"text": @"Parámetros", @"icon": iParameters};
        NSDictionary *help = @{@"text": @"Opción de ayuda", @"icon": iHelp};
        switch (indexPath.row) {
            case 1:
                cell.lbName.text = [home objectForKey:@"text"];
                cell.ivIcon.image = [home objectForKey:@"icon"];
                break;
            case 2:
                cell.lbName.text = [connection objectForKey:@"text"];
                cell.ivIcon.image = [connection objectForKey:@"icon"];
                break;
            case 3:
                cell.lbName.text = [vitalSigns objectForKey:@"text"];
                cell.ivIcon.image = [vitalSigns objectForKey:@"icon"];
                break;
            /*
            case 3:
                cell.lbName.text = [vitalSign objectForKey:@"text"];
                cell.ivIcon.image = [vitalSign objectForKey:@"icon"];
                break;
             */
            case 5:
                cell.lbName.text = [vibration objectForKey:@"text"];
                cell.ivIcon.image = [vibration objectForKey:@"icon"];
                break;
            case 6:
                cell.lbName.text = [parameters objectForKey:@"text"];
                cell.ivIcon.image = [parameters objectForKey:@"icon"];
                break;
            case 7:
                cell.lbName.text = [help objectForKey:@"text"];
                cell.ivIcon.image = [help objectForKey:@"icon"];
                break;
            default:
                break;
        }
        
        return cell;
    }
}

- (void)openOptionOne{
    [self openOption:1];
}

- (void)openOptionTwo{
    [self openOption:2];
}

- (void)openOptionThree{
    [self openOption:3];
}

- (void)openOptionFour{
    [self openOption:4];
}

- (void)openOption:(int)option{
    
    if (ble.activePeripheral != nil){
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        TemporalViewController *vcAux = [mainStoryboard instantiateViewControllerWithIdentifier:@"TemporalViewController"];
        SignoVitalViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SignoVitalViewController"];
        switch (option){
            case 1:
                vc.indicatorType = 1;
                break;
            case 2:
                vc.indicatorType = 2;
                break;
            case 3:
                vc.indicatorType = 3;
                break;
            case 4:
                vc.indicatorType = 4;
                break;
            default:
                break;
        }
        NSLog(@"vc.indicatorType: %d", vc.indicatorType);
        
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vcAux withSlideOutAnimation:NO andCompletion:^{
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:NO andCompletion:nil];
        }];
        
    }
    
    else {
        
        [self.alerta show];
    
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 64;
            break;
        case 4:
            if ([indexPath compare:_selectedIndexPath] == NSOrderedSame) {
                return 176;
            }
            else {
                return 44;
            }
        default:
            return 44;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    UIViewController *vc ;
    switch (indexPath.row){
        case 0:
            vc = nil;
            [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{}];
            break;
        case 1:
            vc = (MainViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            break;
        case 2:
            vc = (ListadoVinculacionViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ListadoVinculacionViewController"];
            ;
            break;
        case 3:
            vc =  (ble.activePeripheral != nil) ? [mainStoryboard instantiateViewControllerWithIdentifier: @"SignosVitalesViewController"] : nil;
            if (ble.activePeripheral == nil) {
                [self.alerta show];
            }
            break;
        case 5:
            vc = (ble.activePeripheral != nil) ? [mainStoryboard instantiateViewControllerWithIdentifier: @"VibracionViewController"] : nil;
            if (ble.activePeripheral == nil) {
                [self.alerta show];
            }
            break;
        case 6:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ParametroViewController"];
            break;
        case 7:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"AyudaViewController"];
            break;
        default:
            break;
    }
    if (vc != nil) {
        
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:YES andCompletion:nil];

        
    }
    
    if (indexPath.row == 4) {
        NSIndexPath *clickedNow = indexPath;
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        bool alreayopen= NO;
        UIImage *abrir =[UIImage imageNamed:@"men-arrow-off.png"];
        UIImage *cerrar =[UIImage imageNamed:@"men-arrow-on.png"];
        MenuTitleOptionsTableViewCell *cell = (MenuTitleOptionsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if ([clickedNow isEqual:_selectedIndexPath]) {
            alreayopen = YES;
            CATransition *animation = [CATransition animation];
            animation.type = kCATransitionFromTop;
            animation.duration = 0.4;
            if (indexPath.row == 3) {
                cell.ivOptionsDisplayed.image = abrir;
            }
            _selectedIndexPath = nil;
            [UIView animateWithDuration:2.0 animations:^{
                cell.viOne.hidden = !cell.viOne.hidden;
                cell.viTwo.hidden = !cell.viTwo.hidden;
                cell.viThree.hidden = !cell.viThree.hidden;
                cell.viFour.hidden = !cell.viFour.hidden;
            } completion:^(BOOL finished) {
                
            }];
            
        }
        else {
            CATransition *animation = [CATransition animation];
            animation.type = kCATransitionFromBottom;
            animation.duration = 0.0;
            if (indexPath.row == 3) {
                cell.ivOptionsDisplayed.image = cerrar;
            }
            _selectedIndexPath = clickedNow;
            [UIView animateWithDuration:2.0 animations:^{
                cell.viOne.hidden = !cell.viOne.hidden;
                cell.viTwo.hidden = !cell.viTwo.hidden;
                cell.viThree.hidden = !cell.viThree.hidden;
                cell.viFour.hidden = !cell.viFour.hidden;
            } completion:^(BOOL finished) {
                
            }];
        }
        [tableView beginUpdates];
        [tableView endUpdates];
    }
    
}

@end
