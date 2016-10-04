@import CoreData;

static NSString * _Nonnull const SYNCDefaultLocalPrimaryKey = @"id";
static NSString * _Nonnull const SYNCDefaultLocalCompatiblePrimaryKey = @"remoteID";

static NSString * _Nonnull const SYNCDefaultRemotePrimaryKey = @"id";

static NSString * _Nonnull const SYNCCustomLocalPrimaryKey = @"hyper.isPrimaryKey";
static NSString * _Nonnull const SYNCCustomLocalPrimaryKeyValue = @"YES";
static NSString * _Nonnull const SYNCCustomLocalPrimaryKeyAlternativeValue = @"true";

static NSString * _Nonnull const SYNCCustomRemoteKey = @"hyper.remoteKey";

@interface NSEntityDescription (SYNCPrimaryKey)

/**
 Returns the Core Data attribute used as the primary key. By default it will look for the attribute named `id`.
 You can mark any attribute as primary key by adding `hyper.isPrimaryKey` and the value `YES` to the Core Data model userInfo.
 */
- (nonnull NSAttributeDescription *)sync_primaryKeyAttribute;

/**
 Returns the local primary key for the entity.
 */
- (nonnull NSString *)sync_localPrimaryKey;

/**
 Returns the remote primary key for the entity.
 */
- (nonnull NSString *)sync_remotePrimaryKey;

/**
 Returns the local primary key for the entity.
 */
- (nonnull NSString *)sync_localKey __attribute__((deprecated("Use sync_localPrimaryKey instead")));

/**
 Returns the remote primary key for the entity.
 */
- (nonnull NSString *)sync_remoteKey __attribute__((deprecated("Use sync_remotePrimaryKey instead")));

@end
