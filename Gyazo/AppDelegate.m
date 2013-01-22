//
//  AppDelegate.m
//  Gyazo
//
//  Created by Isshu Rakusai on 12/15/11.
//  Copyright (c) 2011 Nota Inc. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

int callRubyScript(NSString * filename) { 
    
    // Call Ruby script
    NSTask *             task = [ [ NSTask alloc ] init ]; 
    NSPipe *          pipeErr = [ NSPipe pipe ];
    NSMutableString* curPath  = [ NSMutableString string ];
    NSMutableString* scrPath  = [ NSMutableString string ]; 
    
    // Set error pipe 
    [ task setStandardError : pipeErr ]; 
    
    // Get path 
    [ curPath setString : [ [ NSBundle mainBundle ] bundlePath ] ];
    [ curPath setString : [ curPath stringByDeletingLastPathComponent ] ];
    
    [ scrPath setString    : [ [ NSBundle mainBundle ] bundlePath ] ];
    [ scrPath appendString : @"/Contents/Resources/script" ]; 
    
    
    // Execute 
    [ task setLaunchPath           : @"/usr/bin/ruby" ];
    [ task setCurrentDirectoryPath : curPath ];
    if (filename == nil){
        [ task setArguments:[NSArray arrayWithObjects:scrPath,scrPath,nil ] ];
    }else{
        [ task setArguments:[NSArray arrayWithObjects:scrPath,scrPath,filename,nil ] ];
    }
    [ task launch ];
    [ task waitUntilExit ];
    
    { // Read from pipe
        
        NSData*   dataErr = [ [ pipeErr fileHandleForReading ] availableData ];
        NSString* strErr  = [ NSString stringWithFormat : @"%s", [ dataErr bytes ] ];
        NSLog( @"%@",strErr );
        
    }
    return( [ task terminationStatus ] );    
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

    callRubyScript(nil);
    [NSApp terminate: nil];

}


-(BOOL)application:(NSApplication *)theApplication openFile:(NSString *) filename
{
    if (filename != nil ){
        callRubyScript(filename);
        [NSApp terminate: nil];
        return YES;
    }else{
        return NO;
    }
}


@end
