//
//  RinaPhotoAlbumsViewController.m
//  RinaPhotoshop
//
//  Created by yonglim on 4/27/16.
//
//

#import "RinaPhotoAlbumsViewController.h"

@interface RinaPhotoAlbumsViewController ()
@property (nonatomic, retain) NSArray *photoURLs;
@property (nonatomic, strong) UIImage *image;

@end

@implementation RinaPhotoAlbumsViewController

- (id)initWithURLArray:(NSArray *)urlArray
{
    self = [super init];
    if (self) {
        self.photoURLs = urlArray;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (NSURL *url in self.photoURLs) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session =[NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                if ([request.URL isEqual:self.photoURLs]) {
                    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:location]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.image = image;
                        
                        [self addImageToView:image];
                    });
                }
            }
        }];
        [task resume];
    }
}

- (void)addImageToView:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat width = CGRectGetWidth(self.imageScrollView.frame);
    CGFloat imageRatio = image.size.width / image.size.height;
    CGFloat height = width / imageRatio;
    CGFloat x = 0;
    CGFloat y = self.imageScrollView.contentSize.height;
    
    imageView.frame = CGRectMake(x, y, width, height);
    
    CGFloat newHeight = self.imageScrollView.contentSize.height + height;
    self.imageScrollView.contentSize = CGSizeMake(320, newHeight);
    
    [self.imageScrollView addSubview:imageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_imageScrollView release];
    [super dealloc];
}
@end
