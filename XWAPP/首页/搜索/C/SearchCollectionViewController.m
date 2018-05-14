//
//  SearchCollectionViewController.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SearchCollectionViewController.h"
#import "SearchCollecViewCell.h"
#import "SearchHeader.h"
#import "SearchHeaderSecond.h"
#import "YQMController.h"

@interface SearchCollectionViewController ()
{
    BOOL hidden;
    BOOL second;
}



@end

@implementation SearchCollectionViewController

static NSString * const reuseIdentifier = @"SearchCollecViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setView];

    

    
}

- (void)setView {
    hidden = YES;
    second = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置间距
    NSInteger margin = 0;
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    CGFloat itemW = HitoScreenW / 2;
    CGFloat itemH = 40;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake(100, 40);
    layout.footerReferenceSize = CGSizeMake(100, 8);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.alwaysBounceVertical = YES;
    

    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchHeader"];
        [self.collectionView registerNib:[UINib nibWithNibName:@"SearchHeaderSecond" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchHeaderSecond"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
    
    
    
}

#pragma mark - 懒加载



- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
        NSArray *arr = @[@"猜你喜欢", @"你喜欢的"];
        [_dataArr addObjectsFromArray:arr];
    }
    return _dataArr;
}

- (NSMutableArray *)historyArr {
    if (!_historyArr) {
        _historyArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _historyArr;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.historyArr.count!= 0) {
        return 2;
    }
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.historyArr.count != 0) {
        if (section == 0) {
            return self.historyArr.count;
        } else {
            if (second) {
                return 0;
            } else {
                return self.dataArr.count;
            }
        }
    } else {
        if (second) {
            return 0;
        }
        return self.dataArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchCollecViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (self.historyArr.count != 0) {
        
        if (indexPath.section == 0) {
            cell.rightBtn.hidden = hidden;
            cell.titleLB.text = self.historyArr[indexPath.row];
        } else {
            cell.rightBtn.hidden = YES;
            cell.titleLB.text = self.dataArr[indexPath.row];
        }
    } else {
        cell.rightBtn.hidden = YES;
        cell.titleLB.text = self.dataArr[indexPath.row];

    }

    
    HitoWeakSelf;
    [cell clickBtn:^{
        if (WeakSelf.historyArr.count != 0 && WeakSelf.historyArr.count != 1) {
            NSLog(@"%zd", indexPath.row);
            id objc = WeakSelf.historyArr[indexPath.row];
            [WeakSelf.historyArr removeObject:objc];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } else if (WeakSelf.historyArr.count == 1) {
            [WeakSelf.historyArr removeAllObjects];
            [collectionView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        }
    }];
    return cell;
}



#pragma mark <UICollectionViewDelegate>


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {

        
        if (self.historyArr.count != 0) {
            if (indexPath.section == 0) {
                SearchHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchHeader" forIndexPath:indexPath];
                [header clickBtn:^{
                    self->hidden = !self->hidden;
                    [collectionView reloadData];
                }];
                return header;
            } else {
                SearchHeaderSecond *searchHeaderSecond = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchHeaderSecond" forIndexPath:indexPath];
                [searchHeaderSecond clickBtnSecond:^{
                    self->second = !self->second;
                    [collectionView reloadData];
                }];
                return searchHeaderSecond;
            }
        } else {
            SearchHeaderSecond *searchHeaderSecond = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchHeaderSecond" forIndexPath:indexPath];
            [searchHeaderSecond clickBtnSecond:^{
                self->second = !self->second;
                [collectionView reloadData];
            }];
            return searchHeaderSecond;
        }

    } else {

        UICollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        foot.backgroundColor = HitoRGBA(241, 241, 241, 1);
        
        if (self.historyArr.count == 0) {
            foot.backgroundColor = [UIColor clearColor];
        } else {
            
            if (indexPath.section == 0) {
                foot.backgroundColor = HitoRGBA(241, 241, 241, 1);
            } else {
                foot.backgroundColor = [UIColor clearColor];
            }
        }
        
        
        return foot;
    }

    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YQMController *yqm = [[YQMController alloc] initWithNibName:@"YQMController" bundle:nil];
    [self.navigationController pushViewController:yqm animated:YES];
}
@end
