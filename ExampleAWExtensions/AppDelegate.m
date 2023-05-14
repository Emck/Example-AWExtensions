//
//  AppDelegate.m
//  ExampleAWExtensions
//
//  Created by Emck on 2023/5/14.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

#pragma mark - IBAction
- (IBAction)clickLaunchAtLogin:(id)sender {
    NSLog(@"clickLaunchAtLogin %ld", ((NSButton *)sender).state);
}

- (IBAction)clickShowDockIcon:(id)sender {
    NSLog(@"clickShowDockIcon %ld", ((NSButton *)sender).state);
}

- (IBAction)clickShowStatusBarIcon:(id)sender {
    NSLog(@"clickShowStatusBarIcon %ld", ((NSButton *)sender).state);
}

@end
