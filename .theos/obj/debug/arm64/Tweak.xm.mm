#line 1 "Tweak.xm"
@interface TUCall : NSObject
-(NSString *)displayName;
@end
@interface TUCallCenter
+(id)sharedInstance;
- (id)incomingCall;
@end

@interface TPNumberPad : NSObject
@property (retain) NSArray * buttons; 
@end

@interface TPDialerNumberPad : TPNumberPad
-(void)buttonDown:(id)arg1;
-(void)buttonUp:(id)arg1;
@end

@interface PHBottomBar : NSObject
@end

@interface PHInCallKeypadViewController : NSObject
@property(retain) TPDialerNumberPad *keypad; 
@end

@interface PHAudioCallControlsViewController : NSObject
- (void)controlTypeTapped:(unsigned long long)arg1 forView:(id)arg2;
@end

@interface PHCallViewController
@property (nonatomic,retain) PHBottomBar * bottomBar; 
@end 

@interface PHAudioCallViewController : PHCallViewController
@property (nonatomic,retain) PHAudioCallControlsViewController * buttonsViewController;
@property (nonatomic,retain) PHInCallKeypadViewController * keypadViewController; 
-(void)bottomBarActionPerformed:(long long)arg1 withCompletionState:(long long)arg2 fromBar:(id)arg3;
@property (nonatomic,retain) TUCall * callForBackgroundImage;
@end

NSString *contactName = @"VPN";
PHAudioCallControlsViewController *pcv;
TPDialerNumberPad *npad;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class TUCallCenter; @class PHAudioCallViewController; 
static void (*_logos_orig$_ungrouped$PHAudioCallViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL PHAudioCallViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$PHAudioCallViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL PHAudioCallViewController* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$TUCallCenter(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("TUCallCenter"); } return _klass; }
#line 44 "Tweak.xm"

	
	static void _logos_method$_ungrouped$PHAudioCallViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL PHAudioCallViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
		
		NSLog(@"[AutoAnswerPoundXI]----------GET INCOMING CALL----------------");
		TUCall *incomingCall = [[_logos_static_class_lookup$TUCallCenter() sharedInstance] incomingCall];

		if (incomingCall) 
		{
			NSString *callContactName = [incomingCall displayName];
			NSLog(@"[AutoAnswerPoundXI]----------DISPLAY NAME:%@----------------",callContactName);
			if ([callContactName rangeOfString:contactName].location != NSNotFound)
			{
				NSLog(@"[AutoAnswerPoundXI]----------ANSWER CALL----------------");
				[self bottomBarActionPerformed:1 withCompletionState:1 fromBar:[self bottomBar]];
				NSLog(@"[AutoAnswerPoundXI]----------PUSH KEYPAD----------------");
				pcv = [self buttonsViewController];
				[pcv controlTypeTapped:1 forView:nil];
				
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) 
				{
					NSLog(@"[AutoAnswerPoundXI]----------PUSH POUND----------------");
					npad = [[self keypadViewController] keypad];
					[npad buttonDown:[[npad buttons] objectAtIndex:11]];
					[npad buttonUp:[[npad buttons] objectAtIndex:11]];
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) 
					{
						NSLog(@"[AutoAnswerPoundXI]----------HANG UP----------------");
						[self bottomBarActionPerformed:9 withCompletionState:1 fromBar:[self bottomBar]];
					});	
				});	
			}
			else NSLog(@"[AutoAnswerPoundXI]--------DO NOTHING NOT VPN CONTACT------------");
		}
		_logos_orig$_ungrouped$PHAudioCallViewController$viewDidLoad(self, _cmd);
	}



static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$PHAudioCallViewController = objc_getClass("PHAudioCallViewController"); MSHookMessageEx(_logos_class$_ungrouped$PHAudioCallViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$PHAudioCallViewController$viewDidLoad, (IMP*)&_logos_orig$_ungrouped$PHAudioCallViewController$viewDidLoad);} }
#line 83 "Tweak.xm"
