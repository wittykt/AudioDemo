//
//  Downloads.m
//  AudioVideoCtr
//
//  Created by Lokesh on 7/15/16.
//  Copyright © 2016 Practice. All rights reserved.
//

#import "Downloads.h"

@interface Downloads ()

@end

@implementation Downloads

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"folderDownload"];
    [image drawInRect:CGRectMake(0, 0, 30, 30)];
    self.tabBarItem.image = image;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
