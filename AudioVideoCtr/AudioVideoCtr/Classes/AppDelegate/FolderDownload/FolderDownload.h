//
//  FolderDownload.h
//  AudioVideoCtr
//
//  Created by Lokesh on 7/15/16.
//  Copyright © 2016 Practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface FolderDownload : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblView;

-(void)concurrentDownloadURL:(NSMutableArray *)urlArray;
@end
