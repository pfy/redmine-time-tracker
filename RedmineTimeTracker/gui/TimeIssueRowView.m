//
//  TimeIssueRowView.m
//  RedmineTimeTracker
//
//  Created by pfy on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "TimeIssueRowView.h"
#import "SMRedmineUser.h"
@implementation TimeIssueRowView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

-(void)setObjectValue:(id)objectValue{
    [self.objectValue removeObserver:self forKeyPath:@"currentUser"];
    [super setObjectValue:objectValue];
    [self.objectValue addObserver:self forKeyPath:@"currentUser" options:NSKeyValueObservingOptionNew context:nil ];
    [self updateState];
}

-(void)dealloc{
    [self.objectValue removeObserver:self forKeyPath:@"currentUser"];
}

-(void)updateState {
    SMRedmineUser *user = [[SMCurrentUser findOrCreate] n_user ];
    if([[self.objectValue n_user] isEqual:user]){
        [self.pauseButton setHidden:NO];
        if([self.objectValue currentUser]){
            [self.pauseButton setImage:[NSImage imageNamed:NSImageNameStopProgressTemplate]];
        } else {
            [self.pauseButton setImage:[NSImage imageNamed:NSImageNameRightFacingTriangleTemplate]];
        }
    } else {
        [self.pauseButton setHidden:YES];
    }
    
}

-(IBAction)pressPause:(id)sender{
    if([self.objectValue currentUser]){
        [self.objectValue setCurrentUser:nil];
    } else {
        [self.objectValue setCurrentUser:[SMCurrentUser findOrCreate]];
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    LOG_INFO(@"observerValueForKeyPath %@ of Object %@",keyPath,object);
    [self updateState];
    
}
@end
