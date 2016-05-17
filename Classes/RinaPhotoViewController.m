//
// RinaPhotoViewController.m
// RinaPhotoshop
//
// Created by yonglim on 4/20/16.
//

#import "RinaPhotoViewController.h"
#import "AppDelegate.h"

NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";

@interface RinaPhotoViewController (PrivateMethods)
- (void)updateUserInterface:(NSNotification *)notification;
@end


@implementation RinaPhotoViewController
@synthesize flickrRequest;
@synthesize imagePicker;
@synthesize authorizeButton;
@synthesize authorizeDescriptionLabel;
@synthesize snapPictureButton;
@synthesize snapPictureDescriptionLabel;
@synthesize choosePhotoButton;
@synthesize choosePhotoDescriptionLabel;
@synthesize showMyAlbumsButton;

- (void)viewDidUnload
{
    self.flickrRequest = nil;
    self.imagePicker = nil;
    
    self.authorizeButton = nil;
    self.authorizeDescriptionLabel = nil;
    self.snapPictureButton = nil;
    self.snapPictureDescriptionLabel = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
//    [self viewDidUnload];
    self.flickrRequest = nil;
    self.imagePicker = nil;
    
    self.authorizeButton = nil;
    self.authorizeDescriptionLabel = nil;
    self.snapPictureButton = nil;
    self.snapPictureDescriptionLabel = nil;
    
    self.choosePhotoDescriptionLabel = nil;
    self.choosePhotoButton = nil;
    self.showMyAlbumsButton = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LocalizedString(@"RINA_PHOTO_TITLE", nil); //@"Rina Photoshop";
	
	if ([[AppDelegate sharedDelegate].flickrContext.OAuthToken length]) {
		authorizeButton.enabled = NO;
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInterface:) name:ShouldUpdateAuthInfoNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateUserInterface:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateUserInterface:(NSNotification *)notification
{
	if ([[AppDelegate sharedDelegate].flickrContext.OAuthToken length]) {
		[authorizeButton setTitle:@"Reauthorize" forState:UIControlStateNormal];
		[authorizeButton setTitle:@"Reauthorize" forState:UIControlStateHighlighted];
		[authorizeButton setTitle:@"Reauthorize" forState:UIControlStateDisabled];		
		
		if ([[AppDelegate sharedDelegate].flickrUserName length]) {
			authorizeDescriptionLabel.text = [NSString stringWithFormat:@"You are %@", [AppDelegate sharedDelegate].flickrUserName];
		}
		else {
			authorizeDescriptionLabel.text = @"You've logged in";
		}
		
		snapPictureButton.enabled = YES;
	}
	else {
		[authorizeButton setTitle:@"Authorize" forState:UIControlStateNormal];
		[authorizeButton setTitle:@"Authorize" forState:UIControlStateHighlighted];
		[authorizeButton setTitle:@"Authorize" forState:UIControlStateDisabled];
		
		authorizeDescriptionLabel.text = @"Login to Flickr";		
		snapPictureButton.enabled = NO;
	}
	
	if ([self.flickrRequest isRunning]) {
		[snapPictureButton setTitle:@"Cancel" forState:UIControlStateNormal];
		[snapPictureButton setTitle:@"Cancel" forState:UIControlStateHighlighted];
		[snapPictureButton setTitle:@"Cancel" forState:UIControlStateDisabled];
		authorizeButton.enabled = NO;
	}
	else {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			[snapPictureButton setTitle:@"Snap" forState:UIControlStateNormal];
			[snapPictureButton setTitle:@"Snap" forState:UIControlStateHighlighted];
			[snapPictureButton setTitle:@"Snap" forState:UIControlStateDisabled];
			snapPictureDescriptionLabel.text = @"Use camera";
		}
		
        [choosePhotoButton setTitle:@"Choose Photo" forState:UIControlStateNormal];
        [choosePhotoButton setTitle:@"Choose Photo" forState:UIControlStateHighlighted];
        [choosePhotoButton setTitle:@"Choose Photo" forState:UIControlStateDisabled];
        choosePhotoDescriptionLabel.text = @"Choose from library";
        
        [showMyAlbumsButton setTitle:@"Show My Albums" forState:UIControlStateNormal];
        [showMyAlbumsButton setTitle:@"Show My Albums" forState:UIControlStateHighlighted];
        [showMyAlbumsButton setTitle:@"Show My Albums" forState:UIControlStateDisabled];
        
		authorizeButton.enabled = YES;
	}
}

#pragma mark Actions

- (IBAction)snapPictureAction
{
	if ([self.flickrRequest isRunning]) {
		[self.flickrRequest cancel];
		[self updateUserInterface:nil];		
		return;
	}
	
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)choosePhotoButtonPressed:(id)sender
{
    if ([self.flickrRequest isRunning]) {
        [self.flickrRequest cancel];
        [self updateUserInterface:nil];
        return;
    }
    
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:photoPicker animated:YES completion:nil];
}

- (IBAction)showMyAlbumsPressed:(id)sender
{
    
}

- (IBAction)authorizeAction
{
    // if there's already OAuthToken, we want to reauthorize
    if ([[AppDelegate sharedDelegate].flickrContext.OAuthToken length]) {
        [[AppDelegate sharedDelegate] setAndStoreFlickrAuthToken:nil secret:nil];
    }
    
	authorizeButton.enabled = NO;
	authorizeDescriptionLabel.text = @"Authenticating...";    

    self.flickrRequest.sessionInfo = kFetchRequestTokenStep;
    [self.flickrRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:SRCallbackURLBaseString]];
}

#pragma mark OFFlickrAPIRequest delegate methods

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    // these two lines are important
    [AppDelegate sharedDelegate].flickrContext.OAuthToken = inRequestToken;
    [AppDelegate sharedDelegate].flickrContext.OAuthTokenSecret = inSecret;

    NSURL *authURL = [[AppDelegate sharedDelegate].flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];
    [[UIApplication sharedApplication] openURL:authURL];    
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    
	if (inRequest.sessionInfo == kUploadImageStep) {
		snapPictureDescriptionLabel.text = @"Setting properties...";

        NSLog(@"%@", inResponseDictionary);
        NSString *photoID = [[inResponseDictionary valueForKeyPath:@"photoid"] textContent];

        flickrRequest.sessionInfo = kSetImagePropertiesStep;
        [flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:[NSDictionary dictionaryWithObjectsAndKeys:photoID, @"photo_id", @"Rina Photoshop", @"title", @"Uploaded from my iPhone/iPod Touch", @"description", nil]];
	}
    else if (inRequest.sessionInfo == kSetImagePropertiesStep) {
		[self updateUserInterface:nil];		
		snapPictureDescriptionLabel.text = @"Done";
        
		[UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
	if (inRequest.sessionInfo == kUploadImageStep) {
		[self updateUserInterface:nil];
		snapPictureDescriptionLabel.text = @"Failed";		
		[UIApplication sharedApplication].idleTimerDisabled = NO;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"API Failed" message:inError.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
	}
	else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"API Failed" message:inError.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
	}
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes
{
	if (inSentBytes == inTotalBytes) {
		snapPictureDescriptionLabel.text = @"Waiting for Flickr...";
	}
	else {
		snapPictureDescriptionLabel.text = [NSString stringWithFormat:@"%u/%u (KB)", inSentBytes / 1024, inTotalBytes / 1024];
	}
}


#pragma mark UIImagePickerController delegate methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_startUpload:(UIImage *)image
{
    NSData *JPEGData = UIImageJPEGRepresentation(image, 1.0);
    
	snapPictureButton.enabled = NO;
	snapPictureDescriptionLabel.text = @"Uploading";
	
    self.flickrRequest.sessionInfo = kUploadImageStep;
    [self.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:JPEGData] suggestedFilename:@"Rina Photo" MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"is_public", nil]];
	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	[self updateUserInterface:nil];
}

#ifndef __IPHONE_3_0
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//  NSDictionary *editingInfo = info;
#else
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
#endif

    [self dismissViewControllerAnimated:YES completion:nil];
	
    snapPictureDescriptionLabel.text = @"Preparing...";
	
	// we schedule this call in run loop because we want to dismiss the modal view first
	[self performSelector:@selector(_startUpload:) withObject:image afterDelay:0.0];
}

#pragma mark Accesors

- (OFFlickrAPIRequest *)flickrRequest
{
    if (!flickrRequest) {
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[AppDelegate sharedDelegate].flickrContext];
        flickrRequest.delegate = self;
		flickrRequest.requestTimeoutInterval = 60.0;
    }
    
    return flickrRequest;
}

- (UIImagePickerController *)imagePicker
{
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
		
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    return imagePicker;
}
    
#ifndef __IPHONE_3_0
- (void)setView:(UIView *)view
{
	if (view == nil) {
		[self viewDidUnload];
	}
	
	[super setView:view];
}
#endif

@end
