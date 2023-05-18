//
//  AppDelegate.m
//  LoginItemsHelper
//
//  Created by Emck on 2023/5/18.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // get Main App BundleIdentifier
    NSString *mainApp = [[NSBundle mainBundle] bundleIdentifier];
    NSRange dot = [mainApp rangeOfString:@"." options:NSBackwardsSearch];
    if (dot.location == NSNotFound) {
        NSLog(@"LoginItemsHelper NotFound Main App BundleIdentifier by %@", mainApp);
        [NSApp terminate:nil];                      // fail, exit app
    }
    else {
        // get LoginItemsHelper path (/xxx/$CFBundleName.app/Contents/Library/LoginItems/LoginItemsHelper.app)
        NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
        // return four directories(only directorie,does not contain LoginItemsHelper.app), path is '/xxx/$CFBundleName.app'
        pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
        NSString *appPath = [NSString pathWithComponents:pathComponents];
        NSString *mainIdentifier = [mainApp substringWithRange:NSMakeRange(0,dot.location)];
        // startApp
        NSArray* apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:mainIdentifier];      // get runningApplications by BundleIdentifier
        if (apps == nil || apps.count <=0) {        // not find Application by BundleIdentifier
            if (@available(macOS 10.15, *)) {
                NSWorkspaceOpenConfiguration* configuration = [NSWorkspaceOpenConfiguration configuration]; // create NSWorkspaceOpenConfiguration
                [configuration setActivates:YES];
                [configuration setCreatesNewApplicationInstance:YES];
                [[NSWorkspace sharedWorkspace] openApplicationAtURL:[NSURL fileURLWithPath:appPath] configuration:configuration completionHandler:^(NSRunningApplication* mainApp, NSError* error) {
                    if (error) {
                        NSLog(@"LoginItemsHelper Start Main App Fail by %@", mainIdentifier);
                        [NSApp terminate:nil];      // start fail, exit app
                    }
                    else [NSApp terminate:nil];     // start success, exit app
                }];
            }
            else {
                if (![NSWorkspace.sharedWorkspace launchApplication:appPath]) {
                    NSLog(@"LoginItemsHelper Start Main App Fail by %@", mainIdentifier);
                    [NSApp terminate:nil];          // start fail, exit app
                }
                else [NSApp terminate:nil];         // start success, exit app
            }
        }
        else [NSApp terminate:nil];
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
