#import "AppDelegate.h"
#import "IAIconDrop.h"
#import "App_Factory-Swift.h"

@implementation AppDelegate {
    NSButton *buildAppButton;
    IAScriptDrop *scriptDrop;
    IAIconDrop *iconDrop;
    __unsafe_unretained NSWindow *window;
}

@synthesize buildAppButton;
@synthesize scriptDrop;
@synthesize iconDrop;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (IBAction)buildAppClicked:(id)sender {

    if (self.scriptDrop.scriptPath != nil) {

        NSSavePanel *savePanel = [NSSavePanel savePanel];
        [savePanel setExtensionHidden:YES];
        savePanel.allowedFileTypes = @[@"app"];
        savePanel.allowsOtherFileTypes = NO;
        savePanel.nameFieldStringValue = [[self.scriptDrop.scriptPath lastPathComponent] stringByDeletingPathExtension];

        [savePanel beginWithCompletionHandler:^(NSInteger response) {
            if (response == NSFileHandlingPanelOKButton) {
                
                ScriptConverter *converter =
                        [[ScriptConverter alloc] initWithScriptPath: self.scriptDrop.scriptPath
                                                               savePath: [[savePanel URL] path]
                                                               iconPath: self.iconDrop.iconPath];
                [converter createApp];
            }
        }];
    }
    else {

        NSAlert *alert = [NSAlert alertWithMessageText:@"No script selected"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"Please select a script file"];
        [alert runModal];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

@end
