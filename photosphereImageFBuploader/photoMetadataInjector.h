
//  Created by Tom Tong on 16/1/2017.
//
//

@import AssetsLibrary;
@import Photos;

#import <UIKit/UIKit.h>
#import "ExifContainer.h"
#import "UIImage+Exif.h"


@interface PhotoMetadataInjector : NSObject
-(NSURL *)addMetaData:(UIImage *)image;
- (void)saveToAlbum:(NSURL*)imageURL toAlbum:(NSString*)album withCompletionBlock:(void(^)(NSError *error))block;

@end
