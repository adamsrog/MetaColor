//
//  RAKulerObject.h
//  RAKulerizer
//
//  Created by Roger Adams on 4/7/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAKulerSwatch.h"

@interface RAKulerObject : NSObject {

}

@property (nonatomic) NSString      *themeID;
@property (nonatomic) NSString      *themeTitle;
@property (nonatomic) NSURL         *themeImageURL;
@property (nonatomic) NSString      *themeAuthorID;
@property (nonatomic) NSString      *themeAuthorLabel;
@property (nonatomic) NSString      *themeTags;
@property (nonatomic) int            themeRating;
@property (nonatomic) int            themeDownloadCount;
@property (nonatomic) NSString      *themeCreatedAt;
@property (nonatomic) NSString      *themeEditedAt;
@property (nonatomic) RAKulerSwatch *themeSwatch1;
@property (nonatomic) RAKulerSwatch *themeSwatch2;
@property (nonatomic) RAKulerSwatch *themeSwatch3;
@property (nonatomic) RAKulerSwatch *themeSwatch4;
@property (nonatomic) RAKulerSwatch *themeSwatch5;
@property (nonatomic) NSString      *themePublishDate;

- (void)setSwatch:(RAKulerSwatch *)swatch atIndex:(int)index;
- (RAKulerSwatch *)getSwatchAtIndex:(int)index;
- (void)swapSwatchAtIndex:(int)startIndex withIndex:(int)newIndex;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;
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
     publishDate:(NSString *)      themePublishDate;

@end
