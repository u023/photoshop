//
//  RinaPhotoAlbumsViewController.h
//  RinaPhotoshop
//
//  Created by yonglim on 4/27/16.
//
//

#import <UIKit/UIKit.h>

@interface RinaPhotoAlbumsViewController : UIViewController
- (id)initWithURLArray:(NSArray *)urlArray;

@property (retain, nonatomic) IBOutlet UIScrollView *imageScrollView;

@end
