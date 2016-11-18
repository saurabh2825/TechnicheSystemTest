//
//  HomeViewController.m
//  Saurabh_Techniche_Test
//
//  Created by Saurabh Suman on 2016-11-17.
//  Copyright © 2016 Saurabh. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "HMSegmentedControl.h"
#import "HexColors.h"
#import "NetworkHandlerParseData.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "HomeModel.h"
#import "FoodModel.h"
#import "ItemModel.h"
#import "DBManager.h"

#define  NULL_CHECKER(X) [X isKindOfClass:[NSNull class]]?nil:X

@interface HomeViewController ()<DBManagerDelegate>
{
    NSMutableArray *foodCategoryArr,*foodNameArr,*foodItem,*totalArr,*menuARR;
    NSIndexPath *selectedIndexPath;
    HomeTableViewCell *cell;
    NetworkHandlerParseData *networkManager;
//    HMSegmentedControl *segmentControl;
    HomeModel *hModel;
    NSInteger secgementNumber;
    BOOL isUpdateCartTable;
    DBManager *dbManager,*compareDB;
    NSMutableArray *compareArr;



}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.navigationBarHidden = YES;

    foodCategoryArr =[[NSMutableArray alloc]init];
    foodNameArr = [[NSMutableArray alloc]init];
    foodItem =[[NSMutableArray alloc]init];
    totalArr =[[NSMutableArray alloc]init];
    menuARR =[[NSMutableArray alloc]init];
   
    dbManager =[[DBManager alloc]initWithFileName:@"ABB.db"];
    dbManager.delegate = self;
    
    NSString *tableCreateQuery = @"create table if not exists cart (id INTEGER PRIMARY KEY AUTOINCREMENT, productName TEXT, price TEXT, quentity INTEGER, code TEXT)";
    
    [dbManager createTableForQuery:tableCreateQuery];
    

    
    
    networkManager=[NetworkHandlerParseData shareManger];

    [self callServicesForData];
    

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



- (IBAction)gotoCartViewController:(id)sender {

    [self performSegueWithIdentifier:@"hometomycartSegua" sender:self];

}

-(void)topMenuList{
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    NSMutableArray *segmentTitleArray;
    segmentTitleArray =[[NSMutableArray alloc]init];
    for (int i =0 ; i<foodCategoryArr.count; i++) {
        hModel = foodCategoryArr[i];
        [segmentTitleArray addObject:hModel.foodCategoryName];
        
//        NSLog(@"%@",segmentTitleArray);
        
        self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, viewWidth, 40)];
        self.segmentedControl.sectionTitles = segmentTitleArray;
        self.segmentedControl.backgroundColor = [UIColor colorWithHexString:@"#98B926"];
        
        self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        self.segmentedControl.selectionIndicatorColor = [UIColor colorWithHexString:@"#E8A514"];
        self.segmentedControl.titleTextAttributes =@{ NSFontAttributeName :[UIFont fontWithName:@"HelveticaNeue" size:13.0f]};
        
        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
        [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.segmentedControl];
        
        
    }
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    NSLog(@"%ld",(long)segmentedControl.selectedSegmentIndex);
    [self tableDataaccordingToSegment:segmentedControl.selectedSegmentIndex];
    secgementNumber = segmentedControl.selectedSegmentIndex;
    
     [self gettingAccordingtoSubMenuArray:selectedIndexPath.row andselectedSegement:secgementNumber];
    [foodItem removeAllObjects];
    selectedIndexPath = nil;
    [self.tableView reloadData];
}







-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [foodNameArr count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedIndexPath != nil)
    {
        if (selectedIndexPath.section == section)
        {
            return foodItem.count+1;
        }
    }
    
    return 1;
    
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
        FoodModel *fModel = [foodNameArr objectAtIndex:indexPath.section];
        UILabel *tableLabel=(UILabel *)[cell viewWithTag:100];
        tableLabel.text =  fModel.foodName;
        NSLog(@"menu titles is %@",tableLabel.text);
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"menuBottomCell" forIndexPath:indexPath];
        ItemModel *fModel = foodItem[indexPath.row-1];
        
        cell.foodName.text = fModel.foodName;
        NSLog(@"food name is %@",cell.foodName.text  );
        cell.priceLabel.text =[NSString stringWithFormat:@"₹ %@",fModel.foodCost];
        cell.quentityLabel.text=[NSString stringWithFormat:@"%ld",(long)fModel.cartCount];
        cell.addButton.tag = indexPath.row;
        cell.removeButton.tag = indexPath.row;
        
        if (fModel.cartCount > 0) {
            cell.removeButton.hidden = NO;
            cell.quentityLabel.hidden = NO;
        }
        else
        {
            cell.removeButton.hidden = YES;
            cell.quentityLabel.hidden = YES;
        }
        [cell.addButton addTarget:self action:@selector(incrementButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.removeButton addTarget:self action:@selector(decrementButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIImageView *image =(UIImageView *)[cell viewWithTag:101];
    if (selectedIndexPath==indexPath) {
        image.image = [UIImage imageNamed:@"iconup"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *tableLabel=(UILabel *)[cell viewWithTag:100];
        tableLabel.textColor = [UIColor colorWithHexString:@"#C85F27"];
    }
    else
    {
        image.image = [UIImage imageNamed:@"icondown"];
        cell.contentView.backgroundColor = [UIColor clearColor];
        UILabel *tableLabel=(UILabel *)[cell viewWithTag:100];
        tableLabel.textColor = [UIColor colorWithHexString:@"#4F5252"];
   }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        NSInteger previousSection = selectedIndexPath.section;
        if (selectedIndexPath != nil)
        {
            //[childArr removeAllObjects];
            selectedIndexPath = nil;
        }
        
        else
        {
            previousSection = -1;//Negative vlues are not possible for sectoin value.
            
        }
        if (indexPath.section != previousSection)
        {
            //                      [self prepopulateData];
            
            
            foodItem = [self gettingAccordingtoSubMenuArray:indexPath.section andselectedSegement:secgementNumber];
            selectedIndexPath=indexPath;
            
            
        }
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return 60;
    }
    
    else
    {
        return 80;
    }
    
    
    return 80;
}



-(void)decrementButtonAction:(UIButton *)decrementButton
{
        ItemModel *aModel =foodItem[decrementButton.tag-1];;
        aModel.cartCount -=1;
    
        if (aModel.cartCount<0) {
            aModel.cartCount =0;
        }
    
    
    if (aModel.cartCount > 0) {
        cell.removeButton.hidden = NO;
        cell.quentityLabel.hidden = NO;
    }
    else
    {
        cell.removeButton.hidden = YES;
        cell.quentityLabel.hidden = YES;
    }

    
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:decrementButton.tag inSection:0]];
    cell.quentityLabel.text=[NSString stringWithFormat:@"%ld",(long)aModel.cartCount];
    
    if (aModel.cartCount==0) {
        [self deletCartItem:aModel];
    }



}


-(void)incrementButtonAction:(UIButton *)incrementButton
{
    ItemModel *aModel = foodItem[incrementButton.tag-1];
    aModel.cartCount +=1;
    if (aModel.cartCount<0) {
        aModel.cartCount =0;
    }
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:incrementButton.tag inSection:0]];
    cell.quentityLabel.text=[NSString stringWithFormat:@"%ld",(long)aModel.cartCount];
    
    if (aModel.cartCount > 0) {
        cell.removeButton.hidden = NO;
        cell.quentityLabel.hidden = NO;
    }
    else
    {
        cell.removeButton.hidden = YES;
        cell.quentityLabel.hidden = YES;
    }

    
    [self getCartDataFromCartTable:aModel];
    


}





-(void)callServicesForData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
[networkManager foodListDataFromAPI:^(BOOL success, NSMutableArray *totalfoodArr) {
    
    if (success) {

        if (totalfoodArr.count>0) {
            foodCategoryArr =totalfoodArr;
        }
        [self topMenuList];
        selectedIndexPath = nil;
        [self tableDataaccordingToSegment:_segmentedControl.selectedSegmentIndex];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } else {

        [MBProgressHUD hideHUDForView:self.view animated:YES];

    
    }
    
}];


}

-(NSMutableArray *)tableDataaccordingToSegment :(NSInteger )item
{
    [foodNameArr removeAllObjects];
    [foodItem removeAllObjects];
    [totalArr removeAllObjects];
    [menuARR removeAllObjects];
    hModel = foodCategoryArr[item];
    for (NSDictionary *adic in hModel.foodArr ) {
        FoodModel *fModel = [[FoodModel alloc]init];
        fModel.foodName = NULL_CHECKER(adic[@"name"]);
        fModel.itemArr = NULL_CHECKER(adic[@"products"]);
        [foodNameArr addObject:fModel];
    }
    NSLog(@"menu list is ..%@",foodNameArr);
    for ( FoodModel *mItem in foodNameArr) {
        menuARR = [mItem.itemArr mutableCopy];
        for (NSDictionary *subMenuDic in menuARR) {
            ItemModel *aModel = [[ItemModel alloc]init];
            aModel.foodName = NULL_CHECKER(subMenuDic[@"name"]);
            [foodItem addObject:aModel];
            
        }
        [totalArr addObject:foodItem];
    }
    return totalArr;
}



-(NSMutableArray *)gettingAccordingtoSubMenuArray:(NSInteger)Item andselectedSegement:(NSInteger)segmentNo
{
    
    [foodNameArr removeAllObjects];
    [foodItem removeAllObjects];
    [totalArr removeAllObjects];
    [menuARR removeAllObjects];
    hModel = foodCategoryArr[segmentNo];
    for (NSDictionary *adic in hModel.foodArr ) {
        FoodModel *fModel = [[FoodModel alloc]init];
        fModel.foodName = NULL_CHECKER(adic[@"name"]);
        fModel.itemArr = NULL_CHECKER(adic[@"products"]);
        [foodNameArr addObject:fModel];
    }
    FoodModel *mItem = foodNameArr[Item];
    menuARR = [mItem.itemArr mutableCopy];
    for (NSDictionary *subMenuDic in menuARR) {
        ItemModel *aModel = [[ItemModel alloc]init];
        aModel.foodName = NULL_CHECKER(subMenuDic[@"name"]);
        aModel.foodCost = NULL_CHECKER(subMenuDic[@"price"]);
        aModel.imageCode = NULL_CHECKER(subMenuDic[@"image"]);
        aModel.foodWeight = NULL_CHECKER(subMenuDic[@"stock"]);
        aModel.code = NULL_CHECKER(subMenuDic[@"code"]);
        [foodItem addObject:aModel];
        
    }
    
   foodItem = [self compareandreturnMenuArray:foodItem];

       return foodItem;
}

-(NSMutableArray *)compareandreturnMenuArray:(NSMutableArray *)arr



{
    
    compareDB =[[DBManager alloc]initWithFileName:@"ABB.db"];
    compareDB.delegate = self;
    NSString *queryString = @"SELECT * FROM cart";
    [compareDB getDataForQuery:queryString];
    for (int i = 0; i<arr.count; i++) {
        ItemModel *aModel = arr[i];
        for (int i = 0; i<compareArr.count; i++) {
            ItemModel *aModell = compareArr[i];
            
            NSString *code1=[NSString stringWithFormat:@"%@",aModel.code];
            NSString *code2=[NSString stringWithFormat:@"%@",aModell.code];
            
            if ([code1 isEqualToString:code2]) {
                aModel.cartCount = aModell.cartCount;
            }
        }
    }
    
    return arr;
    
}



-(void)saveDatainCart:(ItemModel *)aModel
{
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO cart (productName, price, quentity,code) values ('%@', '%@','%ld','%@')", aModel.foodName, aModel.foodCost,(long)aModel.cartCount,aModel.code];
    [dbManager saveDataToDBForQuery:insertSQL];
    
    
    
    
}

-(void)deletCartItem:(ItemModel *)aModel
{
    NSString *deletequery =[NSString stringWithFormat:@"DELETE FROM cart WHERE code = %@",aModel.code];
    [dbManager deleteRowForQuery:deletequery];
    
    
}





-(void)updateDatainCart:(ItemModel *)aModel
{
    
    NSString *updatequery =[NSString stringWithFormat:@"UPDATE cart SET quentity = '%ld' WHERE code = %@",(long)aModel.cartCount,aModel.code];
    [dbManager saveDataToDBForQuery:updatequery];
    
    
    
}





-(void)ShowDatainCartButton:(ItemModel *)aModel
{
    
    
    
    
}

-(void)getCartDataFromCartTable:(ItemModel *)aModel
{
    
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM cart WHERE code = '%@'", aModel.code];
    [dbManager getDataForQuery:queryString];
    if (isUpdateCartTable) {
        
        NSLog(@"update table");
        
        [self updateDatainCart:aModel];
        
        
    }else
    {
        
        [self saveDatainCart:aModel];
    }
    
    
    
    
}


- (void)DBManager:(DBManager *)manager gotSqliteStatment:(sqlite3_stmt *)statment
{
    //This will give latest entry. So only one value is needed here. No need to loop through all.
    if ([manager isEqual:compareDB]) {
        compareArr = [[NSMutableArray alloc] init];
        while (sqlite3_step(statment) == SQLITE_ROW)
        {
            ItemModel *aModel = [[ItemModel alloc] init];
            aModel.code = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 4)];
            aModel.cartCount =sqlite3_column_int(statment, 3);;
            [compareArr addObject:aModel];
        }
    }
    if (sqlite3_step(statment) == SQLITE_ROW)
    {
        NSLog(@"data present");
        isUpdateCartTable = YES;
        
    }else
    {
        isUpdateCartTable = NO;
        
    }
    
}




@end
