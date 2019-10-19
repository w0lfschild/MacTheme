//
//  test01.m
//  test01
//
//  Created by Wolfgang Baird on 11/22/18.
//  Copyright © 2018 macenhance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <objc/objc-runtime.h>
#import "ZKSwizzle/ZKSwizzle.h"
#import "fishhook.h"
#import "CDStructures.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

#define dockSwipeGesturePhase 123
#define dockSwipeGestureMotion 134
#define dockSwipeEvent 30
#define kIOHIDGestureMotionVerticalY 2

// Undocumented CoreGraphics function:
CGPoint CGSCurrentInputPointerPosition(void);
static int mouseOverrideCount = 0;
static CGPoint (*originalCGSCurrentInputPointerPosition)(void);

static CGPoint moveToTopOfScreen(CGPoint p) {
    CGDirectDisplayID displayContainingCursor;
    uint32_t matchingDisplayCount = 0;
    
    CGGetDisplaysWithPoint(p, 1, &displayContainingCursor, &matchingDisplayCount);
    
    if (matchingDisplayCount >= 1) {
        CGRect rect = CGDisplayBounds(displayContainingCursor);
        p.y = rect.origin.y+1;
    }
    return p;
}

static CGPoint overrideCGSCurrentInputPointerPosition() {
    CGPoint result = originalCGSCurrentInputPointerPosition();
    if (mouseOverrideCount > 0) {
        mouseOverrideCount -= 1;
        result = moveToTopOfScreen(result);
    }
    return result;
}

@interface Hacked_WVExpose : NSObject

@end

@implementation Hacked_WVExpose

@end

void macOS10_11Method() {
    ZKSwizzle(Hacked_WVExpose, WVExpose);
}

@interface Hacked_TtC4Dock8WVExpose : NSObject

@end

@implementation Hacked_TtC4Dock8WVExpose

- (void)changeMode:(long long)arg1 {
    if (arg1 == 1) {
        mouseOverrideCount = 1;
    }
    ZKOrig(void, arg1);
}

@end

@interface Hacked_DOCKGestures : NSObject

@end

@implementation Hacked_DOCKGestures

- (void)handleEvent:(id)arg1 {
    CGEventRef event = (__bridge CGEventRef)arg1;
    if (event) {
        CGEventType type = CGEventGetType(event);
        CGGesturePhase phase = (CGGesturePhase)CGEventGetIntegerValueField(event, dockSwipeGestureMotion);
        uint64_t direction = (CGGesturePhase)CGEventGetIntegerValueField(event, dockSwipeGesturePhase);
        if (type == dockSwipeEvent && phase == kCGGesturePhaseBegan && direction == kIOHIDGestureMotionVerticalY) {
            mouseOverrideCount = 2;
        }
    }
    ZKOrig(void, arg1);
}

@end

void macOS10_13AndLaterMethod() {
    ZKSwizzle(Hacked_TtC4Dock8WVExpose, _TtC4Dock8WVExpose);
    ZKSwizzle(Hacked_DOCKGestures, DOCKGestures);
    int result = rebind_symbols((struct rebinding[2]){{"CGSCurrentInputPointerPosition", overrideCGSCurrentInputPointerPosition, (void *)&originalCGSCurrentInputPointerPosition}}, 1);
    if (result != 0) {
        return;
    }
}

#import "MacTheme.h"

@interface MacTheme()

@end

@implementation MacTheme

+ (instancetype)sharedInstance {
    static MacTheme *plugin = nil;
    @synchronized(self) {
        if (!plugin) {
            plugin = [[self alloc] init];
        }
    }
    return plugin;
}

+ (void)load {
//    test01 *plugin = [test01 sharedInstance];
    NSUInteger osx_ver = [[NSProcessInfo processInfo] operatingSystemVersion].minorVersion;
    NSLog(@"mactheme : %@ loaded into %@ on macOS 10.%ld", [self class], [[NSBundle mainBundle] bundleIdentifier], (long)osx_ver);
//    NSInteger osxMinorVersion = [[NSProcessInfo processInfo] operatingSystemVersion].minorVersion;
    
    // Dock tile theming
    ZKSwizzle(__MT_Tile, Tile);
    
    // Launchpad theming
    ZKSwizzle(__MT_LPRunnable, LPRunnable);
    
    // App switcher theming
    ZKSwizzle(__MT_ECBezelIconList, ECBezelIconList);
    ZKSwizzle(__MT_ECMaterialLayer, ECMaterialLayer);
    ZKSwizzle(__MT_ECBezelIconListLabelLayer, ECBezelIconListLabelLayer);
    
    // Finder
    ZKSwizzle(__MT_TDesktopIconView, TDesktopIconView);
    ZKSwizzle(__MT_TView, TView);
}


@end
