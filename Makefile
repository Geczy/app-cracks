ARCHS = arm64e
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

include $(THEOS)/makefiles/common.mk

export TARGET = iphone:latest:14.0
TWEAK_NAME = MacroFactorPremium
MacroFactorPremium_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk
