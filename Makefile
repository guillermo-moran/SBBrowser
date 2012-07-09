THEOS_DEVICE_IP = 192.168.1.102
GO_EASY_ON_ME=1
include theos/makefiles/common.mk

TWEAK_NAME = SBBrowser
SBBrowser_FILES = Tweak.mm
SBBrowser_FRAMEWORKS = UIKit
SBBrowser_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk
