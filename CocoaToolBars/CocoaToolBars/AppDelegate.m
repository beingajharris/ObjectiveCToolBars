//
//  AppDelegate.m
//  CocoaToolBars
//
//  Created by Debasis Das on 4/30/15.
//  Copyright (c) 2015 Knowstack. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    
    _toolbarTabsArray = [self toolbarItems];
    _toolbarTabsIdentifierArray = [NSMutableArray new];
    
    for (NSDictionary *dict in _toolbarTabsArray){
        [_toolbarTabsIdentifierArray addObject:dict[@"identifier"]];
    }

    _toolbar = [[NSToolbar alloc] initWithIdentifier:@"ScreenNameToolbarIdentifier"];
    _toolbar.allowsUserCustomization = YES;
    _toolbar.delegate = self;
    self.window.toolbar = _toolbar;

}

-(NSArray *)toolbarItems{
    NSArray *toolbarItemsArray = [NSArray arrayWithObjects:
                                  [NSDictionary dictionaryWithObjectsAndKeys:@"Find Departments",@"title",@"Department-50",@"icon",@"DepartmentViewController",@"class",@"DepartmentViewController",@"identifier", nil],
                                  [NSDictionary dictionaryWithObjectsAndKeys:@"Find Accounts",@"title",@"Business-50",@"icon",@"AccountViewController",@"class",@"AccountViewController",@"identifier", nil],
                                  [NSDictionary dictionaryWithObjectsAndKeys:@"Find Employees",@"title",@"Edit User-50",@"icon",@"EmployeeViewController",@"class",@"EmployeeViewController",@"identifier", nil],
                                  nil];
    return  toolbarItemsArray;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag
{
    NSDictionary *itemInfo = nil;
    
    for (NSDictionary *dict in _toolbarTabsArray)
    {
        if([dict[@"identifier"] isEqualToString:itemIdentifier])
        {
            itemInfo = dict;
            break;
        }
    }
    
    NSAssert(itemInfo, @"Could not find preferences item: %@", itemIdentifier);
    
    NSImage *icon = [NSImage imageNamed:itemInfo[@"icon"]];
    if(!icon) {
        icon = [NSImage imageNamed:NSImageNamePreferencesGeneral];
    }
    
    
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    item.label = itemInfo[@"title"];
    item.image = icon;
    item.target = self;
    item.action = @selector(viewSelected:);
    
    return item;
}

-(void)viewSelected:(id)sender{
    
    NSToolbarItem *item = sender;
    [self loadViewWithIdentifier:item.itemIdentifier withAnimation:YES];
    
}

-(void)loadViewWithIdentifier:(NSString *)viewTabIdentifier
                          withAnimation:(BOOL)shouldAnimate{
    NSLog(@"viewTabIdentifier %@",viewTabIdentifier);
    
    
    if ([_currentView isEqualToString:viewTabIdentifier]){
        return;
    }
    else
    {
        _currentView = viewTabIdentifier;
    }
    //Loop through the view array and find out the class to load
    
    NSDictionary *viewInfoDict = nil;
    for (NSDictionary *dict in _toolbarTabsArray){
        if ([dict[@"identifier"] isEqualToString:viewTabIdentifier]){
            viewInfoDict = dict;
            break;
        }
    }
    NSString *class = viewInfoDict[@"class"];
    if(NSClassFromString(class))
    {
        _currentViewController = [[NSClassFromString(class) alloc] init];
        
        //Old View
        //NSView * oldView = self.window.contentView;
        
        //New View
        NSView *newView = _currentViewController.view;
        
        NSRect windowRect = self.window.frame;
        NSRect currentViewRect = newView.frame;
        
        windowRect.origin.y = windowRect.origin.y + (windowRect.size.height - currentViewRect.size.height);
        windowRect.size.height = currentViewRect.size.height;
        windowRect.size.width = currentViewRect.size.width;
        
        self.window.title = viewInfoDict[@"title"];
        [self.window setContentView:newView];
        [self.window setFrame:windowRect display:YES animate:shouldAnimate];
        
    }
    else{
        NSAssert(false, @"Couldn't load %@", class);
    }
}


- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    NSLog(@"%s %@",__func__,_toolbarTabsIdentifierArray);
    return _toolbarTabsIdentifierArray;

}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    NSLog(@"%s",__func__);
    return [self toolbarDefaultItemIdentifiers:toolbar];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar
{
    NSLog(@"%s",__func__);
    return [self toolbarDefaultItemIdentifiers:toolbar];
    //return nil;
}

- (void)toolbarWillAddItem:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
}

- (void)toolbarDidRemoveItem:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
}


@end
