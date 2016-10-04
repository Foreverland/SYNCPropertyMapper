#import "NSEntityDescription+SYNCPrimaryKey.h"

#import "NSString+HYPNetworking.h"

@implementation NSEntityDescription (SYNCPrimaryKey)

- (nonnull NSAttributeDescription *)sync_primaryKeyAttribute {
    __block NSAttributeDescription *primaryKeyAttribute;

    [self.propertiesByName enumerateKeysAndObjectsUsingBlock:^(NSString *key,
                                                               NSAttributeDescription *attributeDescription,
                                                               BOOL *stop) {
        NSString *isPrimaryKey = attributeDescription.userInfo[SYNCCustomLocalPrimaryKey];
        BOOL hasCustomPrimaryKey = (isPrimaryKey &&
                                    ([isPrimaryKey isEqualToString:SYNCCustomLocalPrimaryKeyValue] || [isPrimaryKey isEqualToString:SYNCCustomLocalPrimaryKeyAlternativeValue]) );
        if (hasCustomPrimaryKey) {
            primaryKeyAttribute = attributeDescription;
            *stop = YES;
        }

        if ([key isEqualToString:SYNCDefaultLocalPrimaryKey] || [key isEqualToString:SYNCDefaultLocalCompatiblePrimaryKey]) {
            primaryKeyAttribute = attributeDescription;
        }
    }];

    return primaryKeyAttribute;
}

- (nonnull NSString *)sync_localPrimaryKey {
    NSAttributeDescription *primaryAttribute = [self sync_primaryKeyAttribute];
    NSString *localKey = primaryAttribute.name;

    return localKey;
}

- (nonnull NSString *)sync_remotePrimaryKey {
    NSAttributeDescription *primaryKeyAttribute = [self sync_primaryKeyAttribute];
    NSString *remoteKey = primaryKeyAttribute.userInfo[SYNCCustomRemoteKey];

    if (!remoteKey) {
        if ([primaryKeyAttribute.name isEqualToString:SYNCDefaultLocalPrimaryKey] || [primaryKeyAttribute.name isEqualToString:SYNCDefaultLocalCompatiblePrimaryKey]) {
            remoteKey = SYNCDefaultRemotePrimaryKey;
        } else {
            remoteKey = [primaryKeyAttribute.name hyp_remoteString];
        }

    }

    return remoteKey;
}

- (nonnull NSString *)sync_localKey {
    return [self sync_localPrimaryKey];
}

- (nonnull NSString *)sync_remoteKey {
    return [self sync_remotePrimaryKey];
}

@end
