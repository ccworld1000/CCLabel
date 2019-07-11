//
//  CCTableViewCell.h
//  CCLabelDemo
//
//  Created by dengyouhua on 2019/7/2.
//  Copyright © 2019 cc | ccworld1000@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CCLabel.h>

@interface CCTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *summaryText;
@property (nonatomic, strong) CCLabel *summaryLabel;

+ (CGFloat)heightForCellWithText:(NSString *)text availableWidth:(CGFloat)availableWidth;

@end
