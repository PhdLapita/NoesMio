//
//  ParametrosTableViewController.m
//  BLEController
//
//  Created by Avances on 29/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "ParametrosTableViewController.h"
#import "ParametroTableViewCell.h"

static NSDictionary *VALUES_TEMPERATURE;
static NSDictionary *VALUES_RESPIRATION;
static NSDictionary *VALUES_CARDIO;
static NSDictionary *VALUES_MOVEMENT;

int const TEMPERATURE = 0;
int const RESPIRATION = 1;
int const CARDIO = 2;
int const MOVEMENT = 3;

@interface ParametrosTableViewController ()

@end

@implementation ParametrosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VALUES_TEMPERATURE = @{@"normal":@[@36.5,@37.2], @"out":@[@37.3,@39]};
    VALUES_RESPIRATION = @{@"normal":@[@12,@16], @"out":@[@17,@25]};
    VALUES_CARDIO = @{@"normal":@[@60,@100], @"out":@[@101,@200]};
    VALUES_MOVEMENT = @{@"normal":@[@100,@150], @"out":@[@151,@200]};
    
    
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
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath compare:_selectedIndexPath] == NSOrderedSame) {
        return 200;
    }
    else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParametroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *info = [NSDictionary new];
    switch (indexPath.row) {
        case TEMPERATURE:
            info = @{@"title":@"Temperatura",
                     @"icon": @"signo-grupal-temp-on.png",
                     @"normalSince": [[VALUES_TEMPERATURE objectForKey:@"normal"] objectAtIndex:0],
                     @"normalUntil": [[VALUES_TEMPERATURE objectForKey:@"normal"] objectAtIndex:1],
                     @"outSince": [[VALUES_TEMPERATURE objectForKey:@"out"] objectAtIndex:0],
                     @"outUntil": [[VALUES_TEMPERATURE objectForKey:@"out"] objectAtIndex:1],
                     };
            break;
        case RESPIRATION:
            info = @{@"title":@"Respiración",
                     @"icon": @"signo-grupal-resp-on.png",
                     @"normalSince": [[VALUES_RESPIRATION objectForKey:@"normal"] objectAtIndex:0],
                     @"normalUntil": [[VALUES_RESPIRATION objectForKey:@"normal"] objectAtIndex:1],
                     @"outSince": [[VALUES_RESPIRATION objectForKey:@"out"] objectAtIndex:0],
                     @"outUntil": [[VALUES_RESPIRATION objectForKey:@"out"] objectAtIndex:1],
                     };
            break;
        case CARDIO:
            info = @{@"title":@"Cardio",
                     @"icon": @"signo-grupal-card-on.png",
                     @"normalSince": [[VALUES_CARDIO objectForKey:@"normal"] objectAtIndex:0],
                     @"normalUntil": [[VALUES_CARDIO objectForKey:@"normal"] objectAtIndex:1],
                     @"outSince": [[VALUES_CARDIO objectForKey:@"out"] objectAtIndex:0],
                     @"outUntil": [[VALUES_CARDIO objectForKey:@"out"] objectAtIndex:1],
                     };
            break;
        case MOVEMENT:
            info = @{@"title":@"Movimiento",
                     @"icon": @"signo-grupal-mov-on.png",
                     @"normalSince": [[VALUES_MOVEMENT objectForKey:@"normal"] objectAtIndex:0],
                     @"normalUntil": [[VALUES_MOVEMENT objectForKey:@"normal"] objectAtIndex:1],
                     @"outSince": [[VALUES_MOVEMENT objectForKey:@"out"] objectAtIndex:0],
                     @"outUntil": [[VALUES_MOVEMENT objectForKey:@"out"] objectAtIndex:1],
                     };
            break;
        default:
            break;
    }
    cell.lbTitle.text = [info objectForKey:@"title"];
    cell.ivIcon.image = [UIImage imageNamed:[info objectForKey:@"icon"]];
    cell.lbNormalSince.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"normalSince"]];
    cell.lbNormalUntil.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"normalUntil"]];
    cell.lbOutSince.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"outSince"]];
    cell.lbOutUntil.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"outUntil"]];
    cell.viShow.tag = indexPath.row;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCell:)];
    [cell.viShow addGestureRecognizer:gesture];

    return cell;
}

- (IBAction)toggleCell:(UITapGestureRecognizer *)sender{
    UIView *v = sender.view;
    NSIndexPath *clickedNow = [NSIndexPath indexPathForItem:v.tag inSection:0];
    NSIndexPath *ipOne =[NSIndexPath indexPathForItem:0 inSection:0],
    *ipTwo = [NSIndexPath indexPathForItem:1 inSection:0],
    *ipThree = [NSIndexPath indexPathForItem:2 inSection:0],
    *ipFour = [NSIndexPath indexPathForItem:3 inSection:0];
    ParametroTableViewCell *cellSelected = (ParametroTableViewCell *)[self.tableView cellForRowAtIndexPath:clickedNow];
    ParametroTableViewCell *cellOne = (ParametroTableViewCell *)[self.tableView cellForRowAtIndexPath:ipOne],
    *cellTwo = (ParametroTableViewCell *)[self.tableView cellForRowAtIndexPath:ipTwo],
    *cellThree = (ParametroTableViewCell *)[self.tableView cellForRowAtIndexPath:ipThree],
    *cellFour = (ParametroTableViewCell *)[self.tableView cellForRowAtIndexPath:ipFour];
    [self.tableView deselectRowAtIndexPath:clickedNow animated:NO];
    bool alreayopen= NO;
    UIImage *abrir =[UIImage imageNamed:@"men-arrow-off.png"];
    UIImage *cerrar =[UIImage imageNamed:@"men-arrow-on.png"];
    
    if ([clickedNow isEqual:_selectedIndexPath]) {
        alreayopen = YES;
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFromTop;
        animation.duration = 0.4;
        _selectedIndexPath = nil;
        [UIView animateWithDuration:2.0 animations:^{
            cellOne.ivShow.image = abrir;
            cellOne.viContainer.hidden = YES;
            cellTwo.ivShow.image = abrir;
            cellTwo.viContainer.hidden = YES;
            cellThree.ivShow.image = abrir;
            cellThree.viContainer.hidden = YES;
            cellFour.ivShow.image = abrir;
            cellFour.viContainer.hidden = YES;
        } completion:^(BOOL finished) {
            cellSelected.ivShow.image = abrir;
            cellSelected.viContainer.hidden = YES;
        }];
        
    }
    else {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFromBottom;
        animation.duration = 0.0;
        
        _selectedIndexPath = clickedNow;
        [UIView animateWithDuration:2.0 animations:^{
            cellOne.ivShow.image = abrir;
            cellOne.viContainer.hidden = YES;
            cellTwo.ivShow.image = abrir;
            cellTwo.viContainer.hidden = YES;
            cellThree.ivShow.image = abrir;
            cellThree.viContainer.hidden = YES;
            cellFour.ivShow.image = abrir;
            cellFour.viContainer.hidden = YES;
        } completion:^(BOOL finished) {
            cellSelected.ivShow.image = cerrar;
            cellSelected.viContainer.hidden = NO;
        }];
    }
        
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    NSIndexPath *clickedNow = indexPath;
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    bool alreayopen= NO;
    UIImage *abrir =[UIImage imageNamed:@"men-arrow-off.png"];
    UIImage *cerrar =[UIImage imageNamed:@"men-arrow-on.png"];
    ParametroTableViewCell *cell = (ParametroTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([clickedNow isEqual:_selectedIndexPath]) {
        alreayopen = YES;
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFromTop;
        animation.duration = 0.4;
        cell.ivShow.image = abrir;
        _selectedIndexPath = nil;
        [UIView animateWithDuration:2.0 animations:^{
            
        } completion:^(BOOL finished) {
            cell.viContainer.hidden = !cell.viContainer.hidden;
        }];
            
    }
    else {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFromBottom;
        animation.duration = 0.0;
        cell.ivShow.image = cerrar;
        _selectedIndexPath = clickedNow;
        [UIView animateWithDuration:2.0 animations:^{
            
        } completion:^(BOOL finished) {
            cell.viContainer.hidden = !cell.viContainer.hidden;  
        }];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
     */
}

@end
