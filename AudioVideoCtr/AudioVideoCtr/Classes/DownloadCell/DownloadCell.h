//
//  DownloadCell.h
//  AudioVideoCtr
//
//  Created by Apple on 18/07/16.
//  Copyright © 2016 Practice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIProgressView *progressBarView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDownloadRemainingSize;
@property (weak, nonatomic) IBOutlet UIImageView *imgCustom;

@end
