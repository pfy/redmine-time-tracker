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

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    self.user = [SMCurrentUser findOrCreate];
    [self.user addObserver:self forKeyPath:@"currentTimeEntry" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setObjectValue:(id)objectValue {
    [super setObjectValue:objectValue];
    [self updateState];
}

- (void)dealloc {
    [self.user removeObserver:self forKeyPath:@"currentTimeEntry"];
}

- (void)updateState {
    SMRedmineUser *user = [self.user n_user];
    if ([[self.objectValue n_user] isEqual:user]) {
        [self.pauseButton setHidden:NO];
        if ([self.objectValue currentUser]) {
            [self.pauseButton setImage:[NSImage imageNamed:NSImageNameStopProgressTemplate]];
        } else {
            [self.pauseButton setImage:[NSImage imageNamed:NSImageNameRightFacingTriangleTemplate]];
        }
    } else {
        [self.pauseButton setHidden:YES];
    }
}

- (void)pressPause:(id)sender {
    if ([self.objectValue currentUser]) {
        LOG_INFO(@"Removing current user");
        [self.objectValue setCurrentUser:nil];
    } else {
        LOG_INFO(@"Adding current user");
        [self.objectValue setCurrentUser:self.user];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.user && [keyPath isEqualToString:@"currentTimeEntry"]) {
        [self updateState];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
