//
// SnapAndRunAppDelegate.h
// RinaPhotoshop
//
// Created by yonglim on 4/20/16.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"

extern NSString *ShouldUpdateAuthInfoNotification;

@interface AppDelegate : NSObject <UIApplicationDelegate, OFFlickrAPIRequestDelegate>
{    
    UINavigationController *viewController;
    UIWindow *window;
	
	UIActivityIndicatorView *activityIndicator;
	UIView *progressView;
	UIButton *cancelButton;
	UILabel *progressDescription;
    
    OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
	NSString *flickrUserName;
}

+ (AppDelegate *)sharedDelegate;
- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken secret:(NSString *)inSecret;

- (IBAction)cancelAction;

@property (nonatomic, retain) IBOutlet UINavigationController *viewController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIView *progressView;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UILabel *progressDescription;

@property (nonatomic, readonly) OFFlickrAPIContext *flickrContext;
@property (nonatomic, retain) NSString *flickrUserName;
@end

extern NSString *SRCallbackURLBaseString;