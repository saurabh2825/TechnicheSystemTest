//
//  MyCartViewController.m
//  Saurabh_Techniche_Test
//
//  Created by Amit Kumar on 2016-11-18.
//  Copyright © 2016 Saurabh. All rights reserved.
//

#import "MyCartViewController.h"
#import "ItemModel.h"
#import "DBManager.h"
#import "CartTableViewCell.h"
#import "TotalpriceTableViewCell.h"


@interface MyCartViewController ()<DBManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{

    DBManager *dbManager;
    NSMutableArray *cartArr;
    CartTableViewCell *cartCell;
    NSInteger totalPrice;

    

}
@property (weak, nonatomic) IBOutlet UILabel *bottomTotalAmountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MyCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    dbManager = [[DBManager alloc]initWithFileName:@"ABB.db"];
    dbManager.delegate = self;
    totalPrice = 0;
    
    [self getSelectedData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   
    if (section==0) {
        return cartArr.count;
    }else
    {
        if (cartArr.count) {
            return 1;

        } else {
            return 0;
        }
    }
   
}

//secondCell



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section ==1) {
        TotalpriceTableViewCell *cell =[_tableView dequeueReusableCellWithIdentifier:@"secondCell"];
        UILabel *totalCost = (UILabel *)[cell viewWithTag:101];
        UILabel *totalSet = (UILabel *)[cell viewWithTag:102];
        totalCost.text =[NSString stringWithFormat:@"%ld",(long)_totalCost];
        totalSet.text =[NSString stringWithFormat:@"%ld",(long)_totalCost];

        
        
        return cell;
        
    
    }else
    {
    ItemModel *aModel =cartArr[indexPath.row];
    cartCell = [_tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        cartCell.foodNameLabel.text = aModel.foodName;
        cartCell.foodQuantityLabel.text = [NSString stringWithFormat:@"%ld",(long)aModel.cartCount];
        cartCell.pricePerProduct.text =[NSString stringWithFormat:@"₹ %@",aModel.foodCost];
    
    
    NSInteger totalprice =aModel.foodCost.integerValue*aModel.cartCount;
    cartCell.totalPrice.text =[NSString stringWithFormat:@"₹ %ld",(long)totalprice];
    
    
    cartCell.incrementButton.tag = indexPath.row;
        cartCell.decrementButton.tag = indexPath.row;
        [cartCell.incrementButton addTarget:self action:@selector(incrementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cartCell.decrementButton addTarget:self action:@selector(decrementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cartCell.amountholderView.layer.cornerRadius = 13;
    cartCell.amountholderView.layer.masksToBounds = YES;
    [self totalCostCalculationMethod:totalprice];
    return cartCell;
    }
    
}



-(TotalpriceTableViewCell *)configureCostItemCell :(ItemModel *)model
{
    TotalpriceTableViewCell *totalCell = [_tableView dequeueReusableCellWithIdentifier:@"secondCell"];
    return totalCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    } else {
        return 180;
    }
}

-(void)incrementBtnClick:(UIButton *)aIncBtn
{
    cartCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:aIncBtn.tag inSection:0]];
    ItemModel *aModel =cartArr[aIncBtn.tag];
    aModel.cartCount +=1;
    if (aModel.cartCount > 0) {
               cartCell.foodQuantityLabel.text=[NSString stringWithFormat:@"%ld",(long)aModel.cartCount];
    }
    else
    {
}
    
    
    
    
    [self updateDatainCart:aModel];
    
    [self.tableView reloadData];

}


-(void)decrementBtnClick:(UIButton *)aIncBtn
{
    cartCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:aIncBtn.tag inSection:0]];
    
    ItemModel *aModel =cartArr[aIncBtn.tag];
    aModel.cartCount -=1;
    
    if (aModel.cartCount<=0) {
        aModel.cartCount =0;
        //        cell.decrementButton.hidden = YES;
        //        cell.foodNumberLabel.hidden = YES;
    }
    else
    {
        //        cell.decrementButton.hidden = NO;
        //        cell.foodNumberLabel.hidden = NO;
    }
    
    cartCell.foodQuantityLabel.text=[NSString stringWithFormat:@"%ld",(long)aModel.cartCount];
    
    
    if (aModel.cartCount == 0) {
        [self deletCartItem:aModel];
    } else {
        [self updateDatainCart:aModel];
        
    }
    
    [self.tableView reloadData];
 
}


-(void)getSelectedData
{
    cartArr =[[NSMutableArray alloc]init];
    NSString *selectquery = @"SELECT * FROM cart";
    [dbManager getDataForQuery:selectquery];
    [self.tableView reloadData];
    
}

-(void)deletCartItem:(ItemModel *)aModel
{
    
    NSString *deletequery =[NSString stringWithFormat:@"DELETE FROM cart WHERE code = %@",aModel.code];
    
    [dbManager deleteRowForQuery:deletequery];
    
    [self getSelectedData];
    
}





- (void)DBManager:(DBManager *)manager gotSqliteStatment:(sqlite3_stmt *)statment
{
    while (sqlite3_step(statment) == SQLITE_ROW){
        ItemModel *aModel =[[ItemModel alloc]init];
        aModel.foodName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 1)];
        aModel.foodCost = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 2)];
        aModel.code  = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 4)];
        aModel.cartCount = sqlite3_column_int(statment, 3);
        [cartArr addObject:aModel];
        
    }
    
}


-(void)updateDatainCart:(ItemModel *)aModel
{
    
    NSString *updatequery =[NSString stringWithFormat:@"UPDATE cart SET quentity = '%ld' WHERE code = %@",(long)aModel.cartCount,aModel.code];
    [dbManager saveDataToDBForQuery:updatequery];
    
    
}

-(void)updateCartCount:(NSMutableArray *)aDBArray{
    int totalCartCount = 0 ;
    for (ItemModel * dataModel in aDBArray) {
        totalCartCount+= dataModel.cartCount;
        
        
    }
   // cartlabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)totalCartCount];
    self.navigationController.navigationBar.topItem.backBarButtonItem.title = [NSString stringWithFormat:@"My Cart (%lu)",(unsigned long)totalCartCount];
    
}

-(void)totalCostCalculationMethod:(NSInteger)cost

{

    
     totalPrice =  totalPrice +cost;
    
    self.bottomTotalAmountLabel.text = [NSString stringWithFormat:@" ₹ %ld",(long)totalPrice];


    totalPrice = 0;
}


@end
