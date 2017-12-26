# ScreeningMoreTag
更新记录
2017.12.24 新增文件

从本地读取数据用到了，主要用到了一下第三方库MJExtension，SDAutoLayout，SVProgressHUD，特别要感谢SDAutoLayout的作者，更加方便的实现了页面的布局，
通过baseAreaArray,baseSubArray来区分第二个tabView的数据是来自区域还是地铁，通过listAreasArray,listAreasArray来区分第三个tebView数据是来自具体区域还是具体地铁，通过ChooseMoreMenuItem的类型来确定点击的类别：区域或地铁，通过selectedSectondAreasArray和selectedSubArray来记录点击的具体区域和地铁站，因为还要来记录来自哪个区和哪条地铁线又引入selectedAreasArray和selectedSectondSubArray，可通过block分别传值或delegate一次传值，当然block也可一次传值但暂未写
Details是三级tabview数据的核心，引入了变量BOOL flag来区分当前cell是否点击进而添加或取消,一下代码是点击判断来源的重点
#pragma mark - 处理第三级数据是否点击
- (void)updateSelectedItemListWithItem:(Details*)model chooseTyep:(ChooseMoreMenuItem)menType and:(NSString*)seleString{
    NSLog(@"seleString---->%@",seleString);
    model.flag = !model.flag;
    //加入ChooseMoreMenuItem区分点击的类型是区域还是地铁
    if (menType == ChooseMoreMenuItemArea) {//区域
        if (model.flag) {//选中
            if ((self.selectedAreasArray.count +self.selectedSubArray.count)>=5 ) {
                model.flag = NO;
                [SVProgressHUD showErrorWithStatus:@"最多只能选择5个"];
                return;
            }
            [self.selectedAreasArray addObject:model];
            [self.selectedSectondAreasArray addObject:seleString];
        } else {//取消
            
            NSMutableArray * tempArray = self.selectedAreasArray;
            NSMutableArray * tempAreasArray = self.selectedSectondAreasArray;
            
            [tempArray mutableCopy];
            [tempAreasArray mutableCopy];
            
            for (int i=0; i<tempArray.count; i++) {
                Details * tempModel = tempArray[i];
                if ([tempModel.text isEqualToString:model.text]) {
                    [tempArray removeObject:tempModel];
                    [tempAreasArray removeObjectAtIndex:i];
                    break;
                }
            }
            self.selectedAreasArray = tempArray;
            self.selectedSectondAreasArray = tempAreasArray;
        }
        NSLog(@"区域-----%@---------------->%@",self.selectedAreasArray,self.selectedSectondAreasArray);
    }
    else{//选择地铁
        if (model.flag) {//选中
            if ((self.selectedAreasArray.count +self.selectedSubArray.count)>=5 ) {
                model.flag = NO;
                [SVProgressHUD showErrorWithStatus:@"最多只能选择5个"];
                return;
            }
            [self.selectedSubArray addObject:model];
            [self.selectedSectondSubArray addObject:seleString];
            
        } else {//取消
            NSMutableArray * tempArray = self.selectedSubArray;
            [tempArray mutableCopy];
            NSMutableArray * tempSubArray = self.selectedSectondSubArray;
            [tempSubArray mutableCopy];
            
            for (int i=0; i<tempArray.count; i++) {
                Details * tempModel = tempArray[i];
                if ([tempModel.text isEqualToString:model.text]) {
                    [tempArray removeObject:tempModel];
                    [tempSubArray removeObjectAtIndex:i];
                    break;
                }
            }
            self.selectedSubArray = tempArray;
            self.selectedSectondSubArray = tempSubArray;
        }
        NSLog(@"地铁----------%@--------------->%@",self.selectedSubArray,self.selectedSectondSubArray);
    }
    [self.threetableView reloadData];
}

水平有限，大佬莫要见笑，有不足之处欢迎指正！qq：643342713
