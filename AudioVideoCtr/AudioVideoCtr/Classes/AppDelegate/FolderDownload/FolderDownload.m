//
//  FolderDownload.m
//  AudioVideoCtr
//
//  Created by Lokesh on 7/15/16.
//  Copyright © 2016 Practice. All rights reserved.
//

#import "FolderDownload.h"
#import "DownloadCell.h"
static float written;
static float sizeTotal,sizeRemaining;
@interface FolderDownload ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDownloadDelegate>{
    
    NSString *urlPath,*urlFileName;
    float progress;
    NSMutableArray *arrayURL;
    NSString *urlPathExtension;
    DownloadCell *cell;
    NSOperationQueue *queue;
}
@end

@implementation FolderDownload

- (void)viewDidLoad {
    [super viewDidLoad];
    _tblView.delegate = self;
    _tblView.dataSource = self;
    UIImage *image = [UIImage imageNamed:@"folder.png"];
    [image drawInRect:CGRectMake(0, 0, 30, 30)];
    self.tabBarItem.image = image;
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-//ConcurrentCall to Download Multiple URL
-(void)concurrentDownloadURL:(NSMutableArray *)urlArray{
  /*--For Concurrency of folder--*/
    queue= [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = urlArray.count;
    
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"Concurrently done : ");
        }];
    }];
    
    for (NSURL *url in urlArray) {
        /*--Getting path,filename and extension of URL--*/
        urlPath = [NSString stringWithFormat:@"%@",url];
        urlFileName = [url lastPathComponent];
        urlPathExtension = [urlFileName pathExtension];
        NSLog(@"URL:%@",url);
   
        /*--Block Operation on Downloading the url --*/
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            [self downloadTaskURL:url];
        }];
        [completionOperation addDependency:operation];
        
    }
    [queue addOperations:completionOperation.dependencies waitUntilFinished:NO];
    [queue addOperation:completionOperation];
    
    arrayURL = [urlArray mutableCopy];
}
#pragma  mark - Table Delegates

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayURL count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell =[tableView dequeueReusableCellWithIdentifier:@
                         "Cell"forIndexPath:indexPath];
    cell.imgCustom.image= [self generateThumbImage:[arrayURL objectAtIndex:indexPath.row]];
    cell.lblName.text = [arrayURL objectAtIndex:indexPath.row];
    
   
    return cell;
    
}
#pragma mark-//Get Image
-(UIImage *)generateThumbImage : (NSString *)filepath
{
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:filepath]];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    return thumbnail;
}

#pragma mark - Download File
-(void)downloadTaskURL:(NSURL *)url
{
    
    NSURLSessionConfiguration  *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"backgorund"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
   NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url];
    [downloadTask resume];
    
    
    
}
#pragma mark - // DownloadTask Delegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
   didFinishDownloadingToURL:(NSURL *)location{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *urlDocDir = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",urlFileName,urlPathExtension]]];
    if([fileManager copyItemAtURL:location toURL:urlDocDir error:nil]){
        NSLog(@"File save at location: %@",urlDocDir);
    }
    
    else{
       NSLog(@"Try try till you succeed");
    }
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
      totalBytesWritten:(int64_t)totalBytesWritten
      totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    sizeTotal = totalBytesExpectedToWrite;
    sizeRemaining = totalBytesWritten;
    /*--Table Reloading--*/
 
    dispatch_async(dispatch_get_main_queue(), ^{
        
        written = (float )totalBytesWritten/totalBytesExpectedToWrite;
        cell.progressBarView.progress = written;
        cell.lblDownloadRemainingSize.text = [NSString stringWithFormat:@"%lld/%lld",totalBytesWritten /1000000,totalBytesExpectedToWrite/1000000];
        NSLog(@"TotalByteExepcted:%f TotalBytesWritten:%f",sizeTotal,sizeRemaining);
    });
}


@end