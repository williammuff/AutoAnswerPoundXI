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
@property(retain) TPDialerNumberPad *keypad; // @synthesize keypad=_keypad;
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

%hook PHAudioCallViewController
	//GRAB OUR INSTANCES
	-(void)viewDidLoad {
		
		NSLog(@"[AutoAnswerPoundXI]----------GET INCOMING CALL----------------");
		TUCall *incomingCall = [[%c(TUCallCenter) sharedInstance] incomingCall];

		if (incomingCall) //incoming 
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
				
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) 
				{
					NSLog(@"[AutoAnswerPoundXI]----------PUSH POUND----------------");
					npad = [[self keypadViewController] keypad];
					[npad buttonDown:[[npad buttons] objectAtIndex:11]];
					[npad buttonUp:[[npad buttons] objectAtIndex:11]];
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) 
					{
						NSLog(@"[AutoAnswerPoundXI]----------HANG UP----------------");
						[self bottomBarActionPerformed:9 withCompletionState:1 fromBar:[self bottomBar]];
					});	
				});	
			}
			else NSLog(@"[AutoAnswerPoundXI]--------DO NOTHING NOT VPN CONTACT------------");
		}
		%orig;
	}
%end


