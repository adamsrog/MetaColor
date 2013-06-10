//
//  RAKulerObject.m
//  RAKulerizer
//
//  Created by Roger Adams on 4/7/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import "RAKulerObject.h"

@implementation RAKulerObject

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithID:(NSString *)      themeID
           title:(NSString *)      themeTitle
           image:(NSURL *)         themeImageURL
        authorID:(NSString *)      themeAuthorID
     authorLabel:(NSString *)      themeAuthorLabel
            tags:(NSString *)      themeTags
          rating:(int)             themeRating
   downloadCount:(int)             themeDownloadCount
       createdAt:(NSString *)      themeCreatedAt
        editedAt:(NSString *)      themeEditedAt
         swatch1:(RAKulerSwatch *) themeSwatch1
         swatch2:(RAKulerSwatch *) themeSwatch2
         swatch3:(RAKulerSwatch *) themeSwatch3
         swatch4:(RAKulerSwatch *) themeSwatch4
         swatch5:(RAKulerSwatch *) themeSwatch5
     publishDate:(NSString *)      themePublishDate {
    
    self = [super init];
    if (self) {
        self.themeID = themeID;
        self.themeTitle = themeTitle;
        self.themeImageURL = themeImageURL;
        self.themeAuthorID = themeAuthorID;
        self.themeAuthorLabel = themeAuthorLabel;
        self.themeTags = themeTags;
        self.themeRating = themeRating;
        self.themeDownloadCount = themeDownloadCount;
        self.themeCreatedAt = themeCreatedAt;
        self.themeEditedAt = themeEditedAt;
        self.themeSwatch1 = themeSwatch1;
        self.themeSwatch2 = themeSwatch2;
        self.themeSwatch3 = themeSwatch3;
        self.themeSwatch4 = themeSwatch4;
        self.themeSwatch5 = themeSwatch5;
        self.themePublishDate = themePublishDate;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.themeID            = [coder decodeObjectForKey:@"themeID"];
        self.themeTitle         = [coder decodeObjectForKey:@"themeTitle"];
        self.themeImageURL      = [coder decodeObjectForKey:@"themeImageURL"];
        self.themeAuthorID      = [coder decodeObjectForKey:@"themeAuthorID"];
        self.themeAuthorLabel   = [coder decodeObjectForKey:@"themeAuthorLabel"];
        self.themeTags          = [coder decodeObjectForKey:@"themeTags"];
        self.themeRating        = [coder decodeIntForKey:@"themeRating"];
        self.themeDownloadCount = [coder decodeIntForKey:@"themeDownloadCount"];
        self.themeCreatedAt     = [coder decodeObjectForKey:@"themeCreatedAt"];
        self.themeEditedAt      = [coder decodeObjectForKey:@"themeEditedAt"];
        self.themeSwatch1       = [coder decodeObjectForKey:@"themeSwatch1"];
        self.themeSwatch2       = [coder decodeObjectForKey:@"themeSwatch2"];
        self.themeSwatch3       = [coder decodeObjectForKey:@"themeSwatch3"];
        self.themeSwatch4       = [coder decodeObjectForKey:@"themeSwatch4"];
        self.themeSwatch5       = [coder decodeObjectForKey:@"themeSwatch5"];
        self.themePublishDate   = [coder decodeObjectForKey:@"themePublishDate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.themeID            forKey:@"themeID"];
    [coder encodeObject:self.themeTitle         forKey:@"themeTitle"];
    [coder encodeObject:self.themeImageURL      forKey:@"themeImageURL"];
    [coder encodeObject:self.themeAuthorID      forKey:@"themeAuthorID"];
    [coder encodeObject:self.themeAuthorLabel   forKey:@"themeAuthorLabel"];
    [coder encodeObject:self.themeTags          forKey:@"themeTags"];
    [coder encodeInt:   self.themeRating        forKey:@"themeRating"];
    [coder encodeInt:   self.themeDownloadCount forKey:@"themeDownloadCount"];
    [coder encodeObject:self.themeCreatedAt     forKey:@"themeCreatedAt"];
    [coder encodeObject:self.themeEditedAt      forKey:@"themeEditedAt"];
    [coder encodeObject:self.themeSwatch1       forKey:@"themeSwatch1"];
    [coder encodeObject:self.themeSwatch2       forKey:@"themeSwatch2"];
    [coder encodeObject:self.themeSwatch3       forKey:@"themeSwatch3"];
    [coder encodeObject:self.themeSwatch4       forKey:@"themeSwatch4"];
    [coder encodeObject:self.themeSwatch5       forKey:@"themeSwatch5"];
    [coder encodeObject:self.themePublishDate   forKey:@"themePublishDate"];
}

- (void)setSwatch:(RAKulerSwatch *)swatch atIndex:(int)index {
    switch (index) {
        case 0:
            self.themeSwatch1 = swatch;
            break;
        case 1:
            self.themeSwatch2 = swatch;
            break;
        case 2:
            self.themeSwatch3 = swatch;
            break;
        case 3:
            self.themeSwatch4 = swatch;
            break;
        case 4:
            self.themeSwatch5 = swatch;
            break;
        default:
            break;
    }
}

- (RAKulerSwatch *)getSwatchAtIndex:(int)index {
    if (index < 0 || index > 4) {
        NSLog(@"Invalid swatch index... returning nil.");
        return nil;
    }
    switch (index) {
        case 0:
            return self.themeSwatch1;
            break;
        case 1:
            return self.themeSwatch2;
            break;
        case 2:
            return self.themeSwatch3;
            break;
        case 3:
            return self.themeSwatch4;
            break;
        case 4:
            return self.themeSwatch5;
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)swapSwatchAtIndex:(int)startIndex withIndex:(int)newIndex {
    // confirm the swatch was moved before proceeding
    if (startIndex == newIndex) return;
    
    RAKulerSwatch *tempSwatch = [[RAKulerSwatch alloc] initWithKulerSwatch:[self getSwatchAtIndex:startIndex]];
    
    [self setSwatch:[self getSwatchAtIndex:newIndex] atIndex:startIndex];
    [self setSwatch:tempSwatch atIndex:newIndex];
    
    NSLog(@"Swapping index: %i <--> %i", startIndex, newIndex);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\nTitle: %@ (%@)\nImageURL: %@\nAuthor: %@ (%@)\nRating: %i\nTags: %@\nDownload Count: %i\nCreated: %@ (Edited: %@)\n%@\n%@\n%@\n%@\n%@\nPublish Date: %@", self.themeTitle, self.themeID, self.themeImageURL, self.themeAuthorLabel, self.themeAuthorID, self.themeRating, self.themeTags, self.themeDownloadCount, self.themeCreatedAt, self.themeEditedAt, self.themeSwatch1.description, self.themeSwatch2.description, self.themeSwatch3.description, self.themeSwatch4.description, self.themeSwatch5.description, self.themePublishDate];
}

@end
