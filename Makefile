ARCHS = arm64
PACKAGE_VERSION = 1.0.1
FINALPACKAGE=1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AutoAnswerPoundXI
AutoAnswerPoundXI_FILES = Tweak.xm
AutoAnswerPoundXI_PrivateFrameworks = TelephonyUtilities

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
