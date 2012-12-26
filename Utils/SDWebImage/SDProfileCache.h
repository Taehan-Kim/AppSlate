/*
 * This file is part of the SDProfileCache package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>

@interface SDProfileCache : NSObject
{
    NSMutableDictionary *memCache;
    NSString *diskCachePath;
    NSOperationQueue *cacheInQueue, *cacheOutQueue;
}

+ (SDProfileCache *)sharedProfileCache;
- (void)storeData:(NSDictionary *)profileData forKey:(NSString *)key;
- (void)storeData:(NSDictionary *)profileData forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (NSDictionary *)dataFromKey:(NSString *)key;
- (NSDictionary *)dataFromKey:(NSString *)key fromDisk:(BOOL)fromDisk;

- (void)removeDataForKey:(NSString *)key;
- (void)clearMemory;
- (void)clearDisk;
- (void)cleanDisk;

@end
