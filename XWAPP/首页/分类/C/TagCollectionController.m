//
//  TagCollectionController.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "TagCollectionController.h"
#import "TagCell.h"
#import "TagHeaderView.h"


@interface TagCollectionController ()

HitoPropertyNSMutableArray(dataArr);
HitoPropertyNSMutableArray(moreArr);
@property (nonatomic, strong) TagHeaderView *header;

@end

@implementation TagCollectionController

static NSString * const reuseIdentifier = @"TagCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 懒加载数据源

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 10; i++) {
            [_dataArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _dataArr;
}

- (NSMutableArray *)moreArr {
    if (!_moreArr) {
        _moreArr = [NSMutableArray arrayWithCapacity:0];
        
        for (int i = 10; i < 20; i++) {
            [_moreArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _moreArr;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArr.count;
    } else {
        return self.moreArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.rightBtn.hidden = !_header.editBtn.selected;
        cell.content.text = _dataArr[indexPath.row];
        [cell rightAction:^(UIButton *btn) {
            //删除cell
            [self.moreArr addObject:self.dataArr[indexPath.row]];
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [collectionView reloadData];
            
        }];
    } else {
        cell.rightBtn.hidden = NO;
        cell.content.text = _moreArr[indexPath.row];
        [cell rightAction:^(UIButton *btn) {
            //添加cell
        }];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    

    if (kind == UICollectionElementKindSectionHeader){
        _header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"TagHeader" forIndexPath:indexPath];
        HitoWeakSelf;
        [_header action:^(UIButton *btn) {
            btn.selected = !btn.selected;
            [WeakSelf.collectionView reloadData];
            
        }];
        return _header;
    }
    
    return nil;

}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    if (indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    _header.editBtn.selected = YES;
    //取出源item数据
    id objc = [self.dataArr objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [_dataArr removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [_dataArr insertObject:objc atIndex:destinationIndexPath.item];
    [collectionView reloadData];
}

@end
