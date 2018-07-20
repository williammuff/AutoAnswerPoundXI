#line 1 "Tweak.xm"

@interface TUCallCenter
+(id)sharedInstance;
- (id)incomingCall;
- (void)answerCall:(id)arg1;
- (void)disconnectCall:(id)arg1;
@end

@interface TUCall : NSObject
@property (nonatomic,copy,readonly) NSString * callUUID;
-(NSString *)displayName;
-(int)status;
@end


NSString *contactName = @"VPN";





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

@class TUCall; @class TUCallCenter; 
static void (*_logos_orig$_ungrouped$TUCall$_handleStatusChange)(_LOGOS_SELF_TYPE_NORMAL TUCall* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$TUCall$_handleStatusChange(_LOGOS_SELF_TYPE_NORMAL TUCall* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$TUCallCenter(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("TUCallCenter"); } return _klass; }
#line 21 "Tweak.xm"

static void _logos_method$_ungrouped$TUCall$_handleStatusChange(_LOGOS_SELF_TYPE_NORMAL TUCall* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$_ungrouped$TUCall$_handleStatusChange(self, _cmd);
	
	TUCall *incomingCall = [[_logos_static_class_lookup$TUCallCenter() sharedInstance] incomingCall];
	if (incomingCall) 
	{
		
		NSString *callContactName = [incomingCall displayName];
		if ([callContactName rangeOfString:contactName].location != NSNotFound)
		{
			NSLog(@"[AutoAnswerPoundXI]-------------------------_handleStatusChange----------------------------");
			NSLog(@"[AutoAnswerPoundXI]-------------------------%@----------------------------",callContactName);
			[[_logos_static_class_lookup$TUCallCenter() sharedInstance] answerCall:incomingCall];	
		}
	}
	
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$TUCall = objc_getClass("TUCall"); MSHookMessageEx(_logos_class$_ungrouped$TUCall, @selector(_handleStatusChange), (IMP)&_logos_method$_ungrouped$TUCall$_handleStatusChange, (IMP*)&_logos_orig$_ungrouped$TUCall$_handleStatusChange);} }
#line 40 "Tweak.xm"
