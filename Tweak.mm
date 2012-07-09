#import <UIKit/UIKit.h>
#import <UIKit/UIHardware.h>
#import <libactivator/libactivator.h>

#define PLIST @"/var/mobile/Library/Preferences/com.gmoran.sbbrowser"


//static UIView* browserView = nil; //UNNEEDED?
static UIButton* searchButton = nil;
static UIButton* refreshButton = nil;
static UIButton* backButton = nil;
static UIButton* fowardButton = nil;
static UITextField* URLField = nil;
static UIWebView* WebView = nil;

static UIWindow* SBBrowserWindow = nil;
static UIButton* dismissButton = nil;

static UIView* controlsView = nil;

extern "C" void UIKeyboardEnableAutomaticAppearance();
//extern "C" void UIKeyboardDisableAutomaticAppearance();


@interface SBBrowser : NSObject <LAListener, UITextFieldDelegate> {}

-(void)buttonPressed;

@end

@implementation SBBrowser


- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    
    //===================== ADD THE MAIN WINDOW =====================//
    
    if (SBBrowserWindow == nil) {
        SBBrowserWindow = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] retain];
        SBBrowserWindow.windowLevel = 66666;
    }

    [SBBrowserWindow setAlpha:1];
    [SBBrowserWindow setHidden:NO];
    [SBBrowserWindow setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    
    //=================== ADD THE MAIN VIEW (UNNEEDED)===============//
    /* 
    if (browserView == nil) {
    browserView = [[[UIView alloc] initWithFrame:CGRectMake(0,20,320,460)] retain];
    }
    
    [browserView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SBBrowserPattern.png"]]];
    
    [SBBrowserWindow addSubview:browserView];
     */
    
    //========================= ADD WEBVIEW =====================//
    
    WebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0,20,320,460)]retain];
    
    WebView.userInteractionEnabled = YES;
    [WebView setScalesPageToFit:YES];
    
    
    [SBBrowserWindow addSubview:WebView];
    
    
    //========================= ADD BUTTONS ========================//
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(230,410,40,40)];
    [backButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"SBBrowserBack.png"] forState:UIControlStateNormal];
    [WebView addSubview:backButton];
    
    fowardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fowardButton setFrame:CGRectMake(270,410,40,40)];
    [fowardButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [fowardButton setImage:[UIImage imageNamed:@"SBBrowserForward.png"] forState:UIControlStateNormal];
    [WebView addSubview:fowardButton];
    
    dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setFrame:CGRectMake(5,20,30,30)];
    [dismissButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setImage:[UIImage imageNamed:@"SBBrowserClose.png"] forState:UIControlStateNormal];
    [WebView addSubview:dismissButton];
    
    //======================== ADD TEXTFIELD =========================//
    
    URLField = [[UITextField alloc] initWithFrame:CGRectMake(105, 20, 200, 30)];
    URLField.borderStyle = UITextBorderStyleRoundedRect;
    URLField.textColor = [UIColor whiteColor]; //text color
    URLField.font = [UIFont systemFontOfSize:17.0];  //font size
    URLField.placeholder = @"URL";  //place holder
    URLField.backgroundColor = [UIColor blackColor]; //background color
    URLField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
    URLField.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
    URLField.returnKeyType = UIReturnKeyDone;  // type of the return key
    URLField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    URLField.delegate = self;
    [URLField addTarget:self action:@selector(loadPage) forControlEvents:UIControlEventEditingDidEndOnExit];
    [WebView addSubview:URLField];
    
    UIKeyboardEnableAutomaticAppearance(); //Enable Keyboard on SpringBoard
        
    //Finish
    
	[event setHandled: YES];

}

-(void)loadPage {
    if ([URLField.text hasPrefix:@"http://"]) {
        [WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",URLField.text]]]];
        }
        else {
            [WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",URLField.text]]]];
        }
}

-(void)googleSearch {
    //Add Google Search Code here later.
}

-(void)buttonPressed {
    if (refreshButton.highlighted) {
        [WebView refresh];
    }
    else if (backButton.highlighted) {
        [WebView goBack];
    }
    else if (fowardButton.highlighted) {
        [WebView goForward];
    }
    else if (dismissButton.highlighted) {
        [SBBrowserWindow setAlpha:0];
        [SBBrowserWindow setHidden:YES];
        [URLField resignFirstResponder];
        //UIKeyboardDisableAutomaticAppearance();
    }
        
}

        
+ (void)load
{
  [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.gmoran.sbbrowser"];
}

@end