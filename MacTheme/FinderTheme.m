//
//  FinderTheme.m
//  MacTheme
//
//  Created by Wolfgang Baird on 8/3/19.
//  Copyright © 2019 macenhance. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "ZKSwizzle/ZKSwizzle.h"

struct TFENode {
    struct OpaqueNodeRef *fNodeRef;
};

struct TFENodeVector {
    struct TFENode *_begin;
    struct TFENode *_end;
    struct TFENode *_end_cap;
};



// Desktop icons

@interface __MT_TDesktopIconView : NSView
{
    int iconUpdated;
}
- (void)viewWillDraw;
@end

@implementation __MT_TDesktopIconView

//- (void)configureICloudBadgeImageView:(_Bool)arg1 {
//    ZKOrig(void, true);
//}
//
//- (_Bool)isICloudBadgeVisible {
//    return true;
//}

- (id)createIconViewWithFrame:(struct CGRect)arg1 {
    return ZKOrig(id, arg1);
}

- (void)updateIcon {
    ZKOrig(void);
}

- (void)viewWillDraw {
    ZKOrig(void);

    @try {
//        NSLog(@"mactheme : %@", [self valueForKey:@"title"]);
        NSString *title = [self valueForKey:@"title"];
        NSString *iconPath = [NSString stringWithFormat:@"/Library/Application Support/MacEnhance/Themes/Offset_b1a4.bundle/%@.png", title];
        if ([NSFileManager.defaultManager fileExistsAtPath:iconPath]) {
            [self setValue:[[NSImage alloc] initWithContentsOfFile:iconPath] forKey:@"icon"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self->iconUpdated <= 2) {
                    self->iconUpdated++;
                    [self viewWillDraw];
                }
            });
            NSLog(@"mactheme : %@", @"setting icon");
        }
        
    } @catch (NSException *exception) {
        NSLog(@"mactheme : %@", exception);
    } @finally {
    }
    
    @try {
        NSString *title = [self valueForKey:@"title"];
        if ([title isEqualToString:@"z"]) {
//            NSLog(@"hello sublayers %@", self.subviews);
            
            NSString *iconPath = [NSString stringWithFormat:@"/Library/Application Support/MacEnhance/Themes/Offset_b1a4.bundle/%@.gif", title];
            if ([NSFileManager.defaultManager fileExistsAtPath:iconPath]) {
                if (self.subviews.count <= 4 && self.subviews.count > 1) {
//                    NSImageView *v = [[NSImageView alloc] initWithFrame:self.frame];
//                    [v setImage:[[NSImage alloc] initWithContentsOfFile:iconPath]];
//                    [v setAnimates:true];
//                    [self setSubviews:@[v]];
//
//                    NSLog(@"hello sublayers %@", NSStringFromRect(self.frame));
//                    NSLog(@"hello sublayers %lu", (unsigned long)self.subviews.count);
                    
                    [self setValue:[[NSImage alloc] initWithContentsOfFile:iconPath] forKey:@"icon"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (self->iconUpdated <= 2) {
                            self->iconUpdated++;
                            [self viewWillDraw];
                        }
                    });
                    NSLog(@"mactheme : %@", @"setting icon");
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"mactheme : %@", exception);
    } @finally {
    }
}

- (NSArray *)arrayForNodeVector:(const struct TFENodeVector *)vector
{
    NSInteger capacity = vector->_end - vector->_begin;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:capacity];
    struct TFENode *node;
    for (node = vector->_begin; node < vector->_end; ++node) {
//        [array addObject: [self pathForNode:node]];
    }
    return array;
}

@end


@interface __MT_TView : NSView
@end

@implementation __MT_TView

- (id)initWithFrame:(struct CGRect)arg1 {
    __MT_TView *res = ZKOrig(id, arg1);
    
    if ([res respondsToSelector:@selector(setImage:)]) {
//            NSLog(@"Why hello there");
            
            NSString *title = @"z";
            NSString *iconPath = [NSString stringWithFormat:@"/Library/Application Support/MacEnhance/Themes/Offset_b1a4.bundle/%@.gif", title];
    //        [self setValue:[[NSImage alloc] initWithContentsOfFile:iconPath] forKey:@"icon"];
            [res performSelector:@selector(setImage:) withObject:[[NSImage alloc] initWithContentsOfFile:iconPath]];
    }
    
    if ([res respondsToSelector:@selector(setAnimates:)]) {
        NSLog(@"Why hello there... oh god");
        [res performSelector:@selector(setAnimates:) withObject:[NSNumber numberWithBool:true]];
    }

    return res;
}

- (void)setFrameSize:(struct CGSize)arg1 {
    if ([self respondsToSelector:@selector(setImage:)]) {
//        NSLog(@"Why hello there");
        
        NSString *title = @"z";
        NSString *iconPath = [NSString stringWithFormat:@"/Library/Application Support/MacEnhance/Themes/Offset_b1a4.bundle/%@.gif", title];
//        [self setValue:[[NSImage alloc] initWithContentsOfFile:iconPath] forKey:@"icon"];
        [self performSelector:@selector(setImage:) withObject:[[NSImage alloc] initWithContentsOfFile:iconPath]];
    }

    ZKOrig(void, arg1);
}

@end
