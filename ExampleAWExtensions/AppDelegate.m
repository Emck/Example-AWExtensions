//
//  AppDelegate.m
//  ExampleAWExtensions
//
//  Created by Emck on 2023/5/14.
//

#import "AppDelegate.h"
#import <AWExtensions/NSApplication+Extension.h>

#define ALastStartKey            @"LastStart"
#define ALaunchAtLoginKey        @"LaunchAtLogin"
#define AShowDockIconKey         @"ShowDockIcon"
#define AShowStatusBarIconKey    @"ShowStatusBarIcon"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@property (weak  ) IBOutlet NSMenu *menuBarMenu;
@property (weak  ) IBOutlet NSButton       *LaunchAtLogin;
@property (weak  ) IBOutlet NSButton       *ShowDockIcon;
@property (weak  ) IBOutlet NSButton       *ShowStatusBarIcon;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // init defaults data
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] objectForKey: ALastStartKey]  ? NO : YES;
    if (isFirst) {       // first run, init data...
        [[NSUserDefaults standardUserDefaults] setBool:NO  forKey:ALaunchAtLoginKey];       // default launch at login
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AShowDockIconKey];        // default show dock icon
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AShowStatusBarIconKey];   // default show status bar icon
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    // init by AWExtensions
    [NSApplication.sharedApplication setupDataAW:@{@"MenuBar": self.menuBarMenu, @"BarIcon": @"StatusBarIcon"}];
    [NSApplication.sharedApplication setupDelegateAW:self];

    // hidden or show DockIcon and StatusBarIcon
    [NSApplication.sharedApplication postDockIconEvent:     [[NSUserDefaults standardUserDefaults] boolForKey:AShowDockIconKey]];
    [NSApplication.sharedApplication postStatusBarIconEvent:[[NSUserDefaults standardUserDefaults] boolForKey:AShowStatusBarIconKey]];

    // update button state
    self.LaunchAtLogin.state      = [[NSUserDefaults standardUserDefaults] boolForKey:ALaunchAtLoginKey];
    self.ShowDockIcon.state       = [[NSUserDefaults standardUserDefaults] boolForKey:AShowDockIconKey];
    self.ShowStatusBarIcon.state  = [[NSUserDefaults standardUserDefaults] boolForKey:AShowStatusBarIconKey];

    // update defaults LastStart
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:ALastStartKey];   // save last Start
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

#pragma mark - IBAction
- (IBAction)clickLaunchAtLogin:(id)sender {
    [NSApplication.sharedApplication postLaunchAtLoginEvent:sender];
}

- (IBAction)clickShowDockIcon:(id)sender {
    NSButton *checkButton = (NSButton *)sender;
    [[NSUserDefaults standardUserDefaults] setBool:checkButton.state forKey:AShowDockIconKey];
    if ([self verifyDockStatusMenu]) [NSApplication.sharedApplication postDockIconEvent:checkButton.state];
    else {      // fail, recovery state
        checkButton.state = !checkButton.state;
        [[NSUserDefaults standardUserDefaults] setBool:checkButton.state forKey:AShowDockIconKey];
    }
}

- (IBAction)clickShowStatusBarIcon:(id)sender {
    NSButton *checkButton = (NSButton *)sender;
    [[NSUserDefaults standardUserDefaults] setBool:checkButton.state forKey:AShowStatusBarIconKey];
    if ([self verifyDockStatusMenu]) [NSApplication.sharedApplication postStatusBarIconEvent:checkButton.state];
    else {      // fail, recovery state
        checkButton.state = !checkButton.state;
        [[NSUserDefaults standardUserDefaults] setBool:checkButton.state forKey:AShowStatusBarIconKey];
    }
}

#pragma mark - NSNotification Event by AWExtensions
- (void)handleLaunchAtLoginResultEvent:(NSNotification *)noti {
    BOOL Result = [[noti.userInfo objectForKey:@"Result"] boolValue];
    NSButton *checkButton =  [noti.userInfo objectForKey:@"Button"];
    if (Result) {
        [[NSUserDefaults standardUserDefaults] setBool:checkButton.state forKey:ALaunchAtLoginKey];
        return;
    }
    // fail
    checkButton.state = !checkButton.state;             // recovery state
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert setIcon:[NSImage imageNamed:NSImageNameCaution]];
    [alert setMessageText:@"Warning"];
    if ([[noti.userInfo objectForKey:@"Enable"] boolValue]) [alert setInformativeText:@"Register Launch At Login fail"];
    else [alert setInformativeText:@"Unregister Launch At Login fail"];
    [alert runModal];
}

#pragma mark - util
- (BOOL)verifyDockStatusMenu {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:AShowDockIconKey] || [[NSUserDefaults standardUserDefaults] boolForKey:AShowStatusBarIconKey]) return YES;
    else {  // both NO, alert Warning
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSAlertStyleWarning];
        [alert setIcon:[NSImage imageNamed:NSImageNameCaution]];
        [alert setMessageText:@"How to get back to this window"];
        [alert setInformativeText:@"When both the dock icon and menu icon are disabled"];
        [alert runModal];
        return NO;
    }
}

@end
