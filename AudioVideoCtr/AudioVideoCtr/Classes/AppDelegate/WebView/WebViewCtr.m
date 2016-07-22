
//
//  WebViewCtr.m
//  AudioVideoCtr
//
//  Created by Lokesh on 7/15/16.
//  Copyright © 2016 Practice. All rights reserved.
//

#import "WebViewCtr.h"
#import "XMLParserCtr.h"
#import "FolderDownload.h"
@interface WebViewCtr ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,XMLParserCtrDelegate,UIWebViewDelegate>{
    UITableView *tblView;
    NSMutableArray *arrayData,*arrayURLs;
    NSArray *arrayFormat;
    NSString *urlString,*path,*extension;
    NSURLRequest *urlRequest;
    UIView *viewCustom;
    NSURL *url;
    bool flag;
}

@end

@implementation WebViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayFormat = @[@"mp3",@"wav",@"mp4",@"3gp",@"aiff",@"act",@"au",@"mmr",@"ape",@"awb",@"dwf"];
    _SerachBar.delegate = self;
    _webView.delegate = self;
    arrayData = [[NSMutableArray alloc]init];
    _indicatorWeb.hidden = YES;
    arrayURLs = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - SearchBar Delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    if (searchText.length >0) {
        if(!flag){
   viewCustom= [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 170)];
    viewCustom.backgroundColor = [UIColor yellowColor];
    tblView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewCustom.frame.size.width, 170)];
    tblView.backgroundColor = [UIColor grayColor];
    tblView.delegate =self;
    tblView.dataSource = self;
    [viewCustom addSubview:tblView];
    [self.view addSubview:viewCustom];
        flag = true;
            
        }
        XMLParserCtr *obj_XMLParserCtr = [[XMLParserCtr alloc]init];
        [obj_XMLParserCtr  getData:searchText];
        obj_XMLParserCtr.delegate = self;
    }
    }
    
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @ " ";
    [viewCustom removeFromSuperview];

}
#pragma mark - //XMLParserCtr Delegate
-(void)getAllSuggestions:(NSMutableArray *)array
{
    [arrayData removeAllObjects];
    [arrayData addObjectsFromArray:array];
    [tblView reloadData];
}


#pragma mark - TableViewDelegates
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"  ];
    
    if (cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
   // cell.backgroundColor = [UIColor grayColor];
    cell.textLabel.text =  [arrayData objectAtIndex:indexPath.row];
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
if(flag ==true)
    {    [viewCustom removeFromSuperview];
    urlString = [arrayData objectAtIndex:indexPath.row];
    _SerachBar.text = urlString;
    urlRequest =  [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://google.com/search?q=%@",urlString]]];
        
    [_webView loadRequest:urlRequest];
    [arrayData removeAllObjects];
        flag= false;
        [_SerachBar resignFirstResponder];
    }
   
}



#pragma mark - //WebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    _indicatorWeb.hidden = NO;
    
    /*--Get extension--*/
    url  =[request URL];
    path = [url path];
    extension = [path pathExtension];
   
    if([arrayFormat containsObject:extension]){
        [arrayURLs addObject:url];
        [self actionSheetForDownloads];
       
    }
      [_indicatorWeb startAnimating];
    [viewCustom removeFromSuperview];
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
     [_indicatorWeb stopAnimating];
    _indicatorWeb.hidden = YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [_indicatorWeb stopAnimating];
    _indicatorWeb.hidden = YES;
    NSLog(@"Fail to Load");
    
}
#pragma mark- //Action Sheet
-(void)actionSheetForDownloads
{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.tabBarController.selectedIndex = 0;
    }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Download" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      
        UINavigationController *obj_navigation= [self.tabBarController.viewControllers objectAtIndex:2 ];
           FolderDownload *obj_FolderDownload = [obj_navigation.viewControllers objectAtIndex:0];
            [obj_FolderDownload concurrentDownloadURL:arrayURLs];
        
            
            
        }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}




@end
