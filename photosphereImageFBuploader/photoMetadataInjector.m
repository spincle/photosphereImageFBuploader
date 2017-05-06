#import "photoMetadataInjector.h"


@implementation PhotoMetadataInjector

-(NSURL *)addMetaData:(UIImage *)image {
    ExifContainer *container = [[ExifContainer alloc] init];
    [container addMakeInfo:@"RICOH"];
    [container addModelInfo:@"RICOH THETA S"];
    NSData *imgData = [image addExif:container];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* filePath=[NSString stringWithFormat:@"%@/sample.jpg",paths[0]];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    [imgData writeToFile:filePath atomically:YES];
    NSURL* imgURL=[NSURL fileURLWithPath:filePath];
    
    return imgURL;
}

- (void)saveToAlbum:(NSURL*)imageURL toAlbum:(NSString*)album withCompletionBlock:(void(^)(NSError *error))block
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            NSMutableArray* assets = [[NSMutableArray alloc]init];
            PHAssetChangeRequest* assetRequest;
            @autoreleasepool {
                assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:imageURL];
                [assets addObject:assetRequest.placeholderForCreatedAsset];
            }
            __block PHAssetCollectionChangeRequest* assetCollectionRequest = nil;
            PHFetchResult* result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PHAssetCollection* collection = (PHAssetCollection*)obj;
                if ([collection isKindOfClass:[PHAssetCollection class]]) {
                    if ([[collection localizedTitle] isEqualToString:album]) {
                        assetCollectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                        [assetCollectionRequest addAssets:assets];
                        *stop = YES;
                    }
                }
            }];
            if (assetCollectionRequest == nil) {
                assetCollectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:album];
                [assetCollectionRequest addAssets:assets];
            }
        }
                                          completionHandler:^(BOOL success, NSError *error) {
                                              if (block) {
                                                  block(error);
                                              }
                                          }];
    }
}
@end
