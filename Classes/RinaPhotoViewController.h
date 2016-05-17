//
// RinaPhotoViewController.h
// RinaPhotoshop
//
// Created by yonglim on 4/20/16.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"
#import "LocalizedString.h"

@interface RinaPhotoViewController : UIViewController <OFFlickrAPIRequestDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    OFFlickrAPIRequest *flickrRequest;
    UIImagePickerController *imagePicker;
    UILabel *authorizeDescriptionLabel;
    UILabel *snapPictureDescriptionLabel;
    UIButton *authorizeButton;
    UIButton *snapPictureButton;
    UIButton *choosePhotoButton;
    UILabel *choosePhotoDescriptionLabel;
    UIButton *showMyAlbumsButton;
}
- (IBAction)authorizeAction;
- (IBAction)snapPictureAction;
- (IBAction)choosePhotoButtonPressed:(id)sender;
- (IBAction)showMyAlbumsPressed:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *authorizeDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *snapPictureDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIButton *snapPictureButton;
@property (nonatomic, retain) IBOutlet UIButton *authorizeButton;
@property (retain, nonatomic) IBOutlet UIButton *choosePhotoButton;
@property (retain, nonatomic) IBOutlet UILabel *choosePhotoDescriptionLabel;
@property (retain, nonatomic) IBOutlet UIButton *showMyAlbumsButton;

@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@end
