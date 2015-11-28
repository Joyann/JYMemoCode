//
//  ViewController.m
//  JYConnectionDownloadBigFile
//
//  Created by joyann on 15/11/8.
//  Copyright © 2015年 Joyann. All rights reserved.
//

/*
 网络请求通常有两种形式：一种是请求数据，一种是下载数据，这两种形式都要进行异步操作
 请求数据：可以直接使用NSURLConnection的sendAsync...方法直接在block中获得data.也可以使用NSURLConnection的delegate的方式.
 下载数据：这种形式要分两种情况：
 1. 如果是小文件下载，那么可以使用sendAsync...的形式(不过不能拿到下载数据的进度并且不能实现大文件的下载),或者使用NSURLConnection的delegate(可以拿到下载进度.),因为delegate会将数据分成若干次来接收，所以需要将每次的数据加到一个属性中来记录，当接收完毕所有的数据后，再写到沙盒里(代码在之前的例子).但是这有一个弊端，因为属性里记录了所有下载的数据，使用这种方式会让程序运行时的内存慢慢增大.所以说是`小文件下载`.
 2. 如果是大文件下载(当前的例子)，如果使用NSURLConnection，那么最好使用NSURLConnection的delegate这种形式(可以拿到下载进度并且可以实现更强大的功能，比如断点下载或者大文件下载).但是并不使用一个属性来记录下载的进度，而是每次下载新的数据的时候，直接将数据写到沙盒中，这样下载的内容就不会存在于当前运行的内存中了. 每次写数据到文件中要在文件内容的末尾接着上一次的数据来写(可以通过NSFileManager+NSFileHandle或者NSOutputStream来实现). 这样当接受数据完毕，沙盒中的数据也写入完毕.
 */

#import "ViewController.h"

static NSString * const JYDownloadVideoURLString = @"http://120.25.226.186:32812/resources/videos/minion_04.mp4";

@interface ViewController () <NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) NSFileHandle *fileHandle;

@property (nonatomic, assign) NSInteger totalSize;
@property (nonatomic, assign) NSInteger currentSize;

@property (nonatomic, copy) NSString *fullPath;

@property (nonatomic, strong) NSOutputStream *stream;

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

#pragma mark - Actions

- (IBAction)startDownload:(id)sender
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:JYDownloadVideoURLString]];
    // 设置需要下载的字节
    NSString *downloadValue = [NSString stringWithFormat:@"bytes=%ld-", self.currentSize];
    // 设置请求头实现断点下载
    [request setValue:downloadValue forHTTPHeaderField:@"Range"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    self.connection = connection;
}

/*
 因为NSURLConnection只有`cancel`方法而没有`suspend`方法，所以如果想要断点下载(暂停之后继续下载而不用重头下载)，就需要在点击`暂停下载`按钮的时候发送`cancel`消息，并且记录下当前已经下载的数据量.再次点击`开始下载`按钮的时候，重新创建一个connection, 在`请求头`中设置`Range`，这样可以控制每次请求获得的数据的数量，只需要每次设置`bytes=currentSize-`,这样每次获得的字节数就是从currentSize开始到文件总大小，这样就可以达到断点下载的效果.(NSURLConnection只能这样做，而NSURLSession则更高级)
 也就是说，NSURLConnection并不是真正的`暂停`，而是每次`暂停`之后进行`取消`操作，再次开始的时候并不是`恢复`，而是`重新创建一个connection`,但是新的connection不再重头开始下载，而是在`请求头`中设置好,只下载那些`未下载的数据`.
 */

- (IBAction)suspendDownload:(id)sender
{
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 注意这一行和self.currentSize > 0这几句的位置. 如果先计算totalSize再判断是否有任务在下载：
    // expectedContentLength是本次connection的请求的要下载的字节数. 也就是说，如果这次请求头中设置的要下载的是`4.7M - 10.0M`,那么`expectedContentLength = 10 - 4.7`.所以如果在请求头中改变了要下载的数据的大小，那么每次暂停-开始,会来到这个方法，获得的expectedContentLength是不一样的,这样造成计算progress不正确.
    // 因为是先计算totalSize,此时不能保证是否有任务在进行，如果没有任务，那么一切正常；但是如果有任务，此时expectedContentLength是本次请求要下载的字节数，很明显不是完整的字节数（因为此时已经下载好了一部分），那么应该重新计算totalSize的值.
    // self.totalSize的真正值应该是`expectedContentLength + 当前已经下载的数据`.
    self.totalSize = response.expectedContentLength + self.currentSize;
    
    // 如果当前有任务正在下载，则直接返回.
    if (self.currentSize > 0) {
        return;
    }
    
    // 这一行如果在self.currentSize > 0这几行代码的下面，说明来到这一行的时候一定是当前没有任务的时候，那么当前请求下载的字节数就是完整文件的大小，此时这样做就可以保证totalSize是正确的.
//    self.totalSize = response.expectedContentLength;
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = response.suggestedFilename;
    NSString *fullPath = [cachePath stringByAppendingPathComponent:fileName];
    self.fullPath = fullPath;
//    NSFileManager *manager = [NSFileManager defaultManager];
    // 接受到相应的时候在沙盒中创建一个文件用来保存下载下来的数据.
//    [manager createFileAtPath:fullPath contents:nil attributes:nil];
    
    // 创建一个文件句柄来实现文件内容追加.
//    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fullPath];
//    self.fileHandle = fileHandle;
    
    // 或者使用NSOutputStream
    // 使用NSOutputStream会自动创建文件并且自动在原来的内容上直接加上新的数据.
    // 但是如果多次点击开始下载，就会在原来文件的基础上直接加新数据. 这样可能会造成最后文件的大小比真实的大小更大的情况.
    // 而NSFileManager不会出现这种情况，因为如果有重名的文件它会先删除原来的然后创建新的来下载.
    // NSOutputStream记得要open和close.NSFileHandle只需要close.
    NSOutputStream *stream = [[NSOutputStream alloc] initToFileAtPath:self.fullPath append:YES];
    [stream open];
    self.stream = stream;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    // 将文件句柄移到文件中内容的最后面
//    [self.fileHandle seekToEndOfFile];
//    // 在内容的最后面写入数据
//    [self.fileHandle writeData:data];
    [self.stream write:data.bytes maxLength:data.length];
    
    self.currentSize += data.length;
    
    self.progressView.progress = 1.0 * self.currentSize / self.totalSize;
    
    NSLog(@"%f", self.progressView.progress);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 关闭文件
//    [self.fileHandle closeFile];
//    self.fileHandle = nil;
    
    [self.stream close];
    self.stream = nil;
}

@end
