//
//  DockTheme.m
//  MacTheme
//
//  Created by Wolfgang Baird on 8/3/19.
//  Copyright © 2019 macenhance. All rights reserved.
//

#import "CDStructures.h"
#import "ZKSwizzle/ZKSwizzle.h"
#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@interface Tile : NSObject {
    unsigned int bouncing:1;
    struct FloatRect rectNow;
    struct CGRect fGlobalBounds;
}
- (void)setSelected:(BOOL)arg1;
- (void)setLabel:(id)arg1 stripAppSuffix:(_Bool)arg2;
- (void)setHidden:(BOOL)arg1;
- (void)doCommand:(unsigned int)arg1;
- (id)layer;
- (void)willBeRemovedFromDock;
- (BOOL)hasIndicator;
- (id)statusLabelForType:(long long)arg1;
- (void)setReplacementAppImage:(id)arg1;
@end

@interface DOCKProcessTile : Tile {
    NSData *_bookmark;
    //    struct CPSProcessSerNum _psn;
    NSString *_bundleIdentifier;
}

- (id)bundleIdentifier;
- (void)dockExtraSetCustomIconImage:(id)arg1 withContext:(id)arg2;
- (void)dockExtraSetBadgeLabel:(id)arg1 withContext:(id)arg2;
- (void)scaleFactorChanged;
- (void)render;
- (BOOL)supportsExpose;
- (BOOL)hasIndicator;
- (void)doCommand:(unsigned int)arg1;
- (id)recentsController;
- (struct CPSProcessSerNum *)psn;
- (BOOL)isRemovable;
- (BOOL)doAction:(unsigned int)arg1 fromKeyboard:(BOOL)arg2;
- (id)bookmark;
- (void)dealloc;
- (id)initWithTile:(id)arg1 psn:(struct CPSProcessSerNum)arg2;
- (id)initWithPSN:(struct CPSProcessSerNum)arg1 url:(id)arg2 bookmark:(id)arg3 name:(id)arg4 useProcessName:(_Bool)arg5;

@end

@interface LPRunnable : NSObject {
    NSData *_bookmarkData;
    NSURL *_lastURL;
    unsigned long long _lastKnownVersion;
    NSString *_categoryUTI;
    NSString *_storeID;
    NSString *_bundleID;
    double _modificationTime;
    unsigned int _lastScan;
    unsigned long long _largeIconSize;
    unsigned long long _miniIconSize;
    id _customBigIcon;
    id _customMiniIcon;
    unsigned int _loadingMini:1;
    unsigned int _reloadingFromDisk:1;
    unsigned int _loadingLarge:1;
}

@property(readonly, nonatomic) NSString *bundleIdentifier; // @synthesize bundleIdentifier=_bundleID;

@end



// Dock icons

@interface __MT_Tile : NSObject
@end

@implementation __MT_Tile

- (BOOL)labelNeedsUpdate {
    // Icon theming
    if ([self.className isEqualToString:@"DOCKProcessTile"] ||
        [self.className isEqualToString:@"DOCKFileTile"] ||
        [self.className isEqualToString:@"DOCKDesktopTile"]) {
        
        // Get application name of tile
        DOCKProcessTile *dpt = (DOCKProcessTile*)self;
        NSWorkspace * workspace = [NSWorkspace sharedWorkspace];
        NSString *path = [workspace absolutePathForAppBundleWithIdentifier:dpt.bundleIdentifier];
        NSBundle *bund = [NSBundle bundleWithPath:path];
        NSString *appName = [bund objectForInfoDictionaryKey:(id)kCFBundleExecutableKey];
        
        // Get path to custom icon
        NSString *iconPath = [NSString stringWithFormat:@"/Library/Application Support/MacEnhance/Themes/Offset_b1a4.bundle/%@.png", appName];
        
//        [(Tile*)self setReplacementAppImage:[[NSImage alloc] initWithDataIgnoringOrientation:[NSData dataWithContentsOfFile:iconPath]]];
        
        // Set custom icon
        if ([NSFileManager.defaultManager fileExistsAtPath:iconPath])
            [(Tile*)self setReplacementAppImage:[[NSImage alloc] initWithContentsOfFile:iconPath]];
    }
    
    return ZKOrig(BOOL);
}

@end



// Launchpad icons

@interface __MT_LPRunnable : NSObject
@end

@implementation __MT_LPRunnable

- (void)setIcon:(id)arg1 {
    NSWorkspace * workspace = [NSWorkspace sharedWorkspace];
    LPRunnable *lpr = (LPRunnable*)self;
    NSString *path = [workspace absolutePathForAppBundleWithIdentifier:lpr.bundleIdentifier];
    NSBundle *bund = [NSBundle bundleWithPath:path];
    NSString *appName = [bund objectForInfoDictionaryKey:(id)kCFBundleExecutableKey];
    
    // Get path to custom icon
    NSString *iconPath = [NSString stringWithFormat:@"/Library/Application Support/MacEnhance/Themes/Offset_b1a4.bundle/%@.png", appName];
    
    if ([NSFileManager.defaultManager fileExistsAtPath:iconPath])
        ZKOrig(void, [[NSImage alloc] initWithContentsOfFile:iconPath]);
    else
        ZKOrig(void, arg1);
}

@end



// Tab switcher icons

int selected = 0;
int icons = 0;

@interface __MT_ECBezelIconList : NSObject
@end

@implementation __MT_ECBezelIconList

- (_Bool)selectForward:(_Bool)arg1 wrap:(_Bool)arg2 {
    if (selected < icons - 1)
        selected += 1;
    else
        selected = 0;
    return ZKOrig(_Bool, arg1, arg2);
}

- (void)show:(_Bool)arg1 {
    selected = 0;
    ZKOrig(void, arg1);
    for (int i = 0; i < icons; i++)
        [self selectForward:true wrap:true];
//    NSLog(@"mactheme : icons : %d", icons);
}

@end

@interface ECBezelIconListLabelLayer : CALayer
@end

@interface ECBezelIconListLayer : CALayer
- (void)setImage:(id)arg1 atIndex:(unsigned long long)arg2;
@end


@interface __MT_ECBezelIconListLabelLayer : CALayer
@end

@implementation __MT_ECBezelIconListLabelLayer

- (void)setString:(id)arg1 maxWidth:(unsigned int)arg2 {
    ZKOrig(void, arg1, arg2);
    
    // Get path to custom icon
    NSString *iconPath = [NSString stringWithFormat:@"/Library/Application Support/MacEnhance/Themes/Offset_b1a4.bundle/%@.png", arg1];
    
    if ([NSFileManager.defaultManager fileExistsAtPath:iconPath]) {
        ECBezelIconListLayer *ec = (ECBezelIconListLayer*)self.superlayer;
        [ec setImage:[[NSImage alloc] initWithContentsOfFile:iconPath] atIndex:selected];
    }
}

@end


@interface __MT_ECMaterialLayer : CALayer
@end

@implementation __MT_ECMaterialLayer

-(void)inspectView:(CALayer *)aView level:(NSString *)level {
//    NSLog(@"mactheme : Level : %@ View : %@", level, aView);
    if ([aView.className isEqualToString:@"ECBezelIconListItemLayer"])
        icons++;
    NSArray *arr = aView.sublayers;
    for (int i=0;i<[arr count];i++) {
        [self inspectView:[arr objectAtIndex:i]
                    level:[NSString stringWithFormat:@"%d", i]];
    }
}

- (void)setBounds:(CGRect)arg1 {
    ZKOrig(void, arg1);
    icons = 0;
    if (self.superlayer.class == NSClassFromString(@"ECBezelIconListLayer"))
        [self inspectView:self.superlayer level:0];
}

@end
