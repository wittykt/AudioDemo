//
//  WebViewCtr.h
//  AudioVideoCtr
//
//  Created by Lokesh on 7/15/16.
//  Copyright © 2016 Practice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewCtr : UIViewController
@property (strong, nonatomic) IBOutlet UISearchBar *SerachBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorWeb;

@property (strong, nonatomic) IBOutlet UIWebView *webView;


@end
