//
//  DetalleSignoTableViewController.m
//  BLEController
//
//  Created by Avances on 29/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "DetalleSignoTableViewController.h"
#import "Utils.h"
#import "RegistroSignoTableViewCell.h"

int const TEMPERATURE = 1;
int const RESPIRATION = 2;
int const CARDIO = 3;
int const MOVEMENT = 4;

@interface DetalleSignoTableViewController ()

@property int numberOfHours;
@property(nonatomic,strong)NSDictionary *vitalSign;

@end

@implementation DetalleSignoTableViewController

@synthesize numberOfHours;
@synthesize indicatorType;
@synthesize vitalSign;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    numberOfHours = [Utils numberOfHoursToday];
    NSDictionary *cardio = @{@"description": @"Cardio", @"icon": @"signo-individual-card.png", @"quantities": @[@70, @71, @72, @73, @74, @75, @76, @77, @78, @79, @80]},
    *temperature = @{@"description": @"Cardio", @"icon": @"signo-individual-temp.png", @"quantities": @[@70, @71, @72, @73, @74, @75, @76, @77, @78, @79, @80]},
    *respiration = @{@"description": @"Cardio", @"icon": @"signo-individual-resp.png", @"quantities": @[@70, @71, @72, @73, @74, @75, @76, @77, @78, @79, @80]},
    *movement = @{@"description": @"Cardio", @"icon": @"signo-individual-mov.png", @"quantities": @[@70, @71, @72, @73, @74, @75, @76, @77, @78, @79, @80]};
    
    switch(indicatorType){
        case TEMPERATURE:
            vitalSign = temperature;
            break;
        case RESPIRATION:
            vitalSign = respiration;
            break;
        case CARDIO:
            vitalSign = cardio;
            break;
        case MOVEMENT:
            vitalSign = movement;
            break;
        default:
            break;
    }
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
    return numberOfHours;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RegistroSignoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.lbTime.text = (indexPath.row < 10) ? [NSString stringWithFormat:@"0%d:00", indexPath.row] : [NSString stringWithFormat:@"%d:00", indexPath.row];
    cell.lbQuantity.text = [Utils pickRandomValue:[vitalSign objectForKey:@"quantities"]];
    cell.ivIcon.image = [UIImage imageNamed:[vitalSign objectForKey:@"icon"]];
    cell.lbDescription.text = [vitalSign objectForKey:@"description"];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
