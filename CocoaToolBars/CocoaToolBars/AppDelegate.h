//
//  AppDelegate.h
//  CocoaToolBars
//
//  Created by Debasis Das on 4/30/15.
//  Copyright (c) 2015 Knowstack. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSToolbarDelegate>

{
    NSToolbar       *_toolbar;
    NSArray         *_toolbarTabsArray;
    NSMutableArray  *_toolbarTabsIdentifierArray;
    NSString        *_currentView;
}

@property (nonatomic, readonly) NSViewController *currentViewController;
@end

