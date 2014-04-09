//
//  TimeIssueRowView.m
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "TimeIssueRowView.h"
#import "SMRedmineUser.h"
#import "SMCurrentUser+trackingExtension.h"
@interface TimeIssueRowView ()
@property (nonatomic,strong) SMCurrentUser* user;
@end

@implementation TimeIssueRowView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.user = [SMCurrentUser findOrCreate];
        [self.user addObserver:self forKeyPath:@"currentTimeEntry" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

-(void)setObjectValue:(id)objectValue{
    [super setObjectValue:objectValue];
    [self updateState];
}

-(void)dealloc{
    [self.user removeObserver:self forKeyPath:@"currentTimeEntry"];
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
    [self updateState];
    
}
@end
