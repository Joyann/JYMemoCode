//
//  JYStatusCellInfo.m
//  CalculateDynamicHeightOfCellByFrame
//
//  Created by joyann on 15/10/10.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYStatusCellInfo.h"
#import "JYStatus.h"

@implementation JYStatusCellInfo

- (instancetype)initWithStatus: (JYStatus *)status
{
    if (self = [super init]) {
        
        _status = status;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat spacing = 10;
        CGFloat iconWH = 60;
        CGFloat vipWH = 14;
        CGFloat contentImageWH = 100;
        
        // 计算头像的frame.
        CGFloat iconImageViewX = spacing;
        CGFloat iconImageViewY = spacing;
        CGFloat iconImageViewW = iconWH;
        CGFloat iconImageViewH = iconWH;
        _statusIconImageViewFrame = CGRectMake(iconImageViewX, iconImageViewY, iconImageViewW, iconImageViewH);
        
        // 计算昵称的frame.
        CGFloat nameLabelX = CGRectGetMaxX(self.statusIconImageViewFrame) + spacing;
        CGFloat nameLabelY = iconImageViewY;
        // 计算UILabel文字所占尺寸（注意这个方法只能计算一行的文字，不能用这个方法来计算正文的尺寸）
        // 另外，在layoutSubviews中可以拿到self.status，说明setStatus:在layoutSubviews后面执行，也就是说layoutSubviews在将要出现在屏幕上的时候调用一次，然后每当frame改变的时候都会调用一次
        CGSize nameLabelSize = [self.status.name sizeWithAttributes:@{ NSFontAttributeName:  NameLabelFont }];
        CGFloat nameLabelW = nameLabelSize.width;
        CGFloat nameLabelH = nameLabelSize.height;
        _statusNameLabelFrame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
        
        // 只有确定是vip才计算frame.
        if (self.status.vip) {
            CGFloat vipLabelW = vipWH;
            CGFloat vipLabelH = vipWH;
            CGFloat vipLabelX = CGRectGetMaxX(self.statusNameLabelFrame) + spacing;
            CGFloat vipLabelY = CGRectGetMidY(self.statusNameLabelFrame) - vipLabelH / 2;
            _statusVipFrame = CGRectMake(vipLabelX, vipLabelY, vipLabelW, vipLabelH);
        }
        
        // 计算正文的frame.
        CGFloat contentLabelX = iconImageViewX;
        CGFloat contentLabelY = CGRectGetMaxY(self.statusIconImageViewFrame) + spacing;
        // 设置给正文限定的size
        // 意思是最大的宽度是cell的宽度减去2个spcing，最大的高度是无限大.用无限大是因为下面的方法总会选择小的高度，比如高度是50，那么就会选择50，如果是100，那么就会选择100.用无限大保证能一直取到较小的值.
        // 也就是说，我们希望内容的宽度是cellWidth - 2 * spacing，高度不限.
        CGSize constraintSize = CGSizeMake(width - 2 * spacing, MAXFLOAT);
        CGRect contentLabelRect = [self.status.text boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: ContentLabelFont } context:nil];
        _statusTextLabelFrame = CGRectMake(contentLabelX, contentLabelY, contentLabelRect.size.width, contentLabelRect.size.height);
        
        // 只有确定正文中有图片才计算frame.
        if (self.status.picture) {
            CGFloat contentImageViewX = iconImageViewX;
            CGFloat contentImgaeViewY = CGRectGetMaxY(self.statusTextLabelFrame) + spacing;
            CGFloat contentImageViewW = contentImageWH;
            CGFloat contentImageViewH = contentImageWH;
            _statusPictureLabelFrame = CGRectMake(contentImageViewX, contentImgaeViewY, contentImageViewW, contentImageViewH);
            
            _cellHeight = CGRectGetMaxY(self.statusPictureLabelFrame) + spacing;
        } else {
            _cellHeight = CGRectGetMaxY(self.statusTextLabelFrame) + spacing;
        }
    }
    return self;
}

@end
