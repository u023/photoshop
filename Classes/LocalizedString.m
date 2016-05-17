//
// LocalizedString.m
// RinaPhotoshop
//
// Created by yonglim on 4/20/16.
//

@implementation NSBundle(PlatformLocalization)

BOOL UserLanguageIsUSEnglish()
{
    NSString *language = [[NSLocale preferredLanguages] firstObject];
    
    // Either "en" or "en-US" is expected for US English. The actual value depends on the device's region
    BOOL isEn = (language.length == 2) && [[language substringToIndex:2] isEqualToString:@"en"];
    BOOL isEnUS = (language.length == 5) && [[language substringToIndex:5] isEqualToString:@"en-US"];
    
    return isEn || isEnUS;
}

- (NSString *)LocalizedStringForKey:(NSString *)key
                              language:(NSString*)language
                                 value:(NSString *)value
                                 table:(NSString *)tableName NS_FORMAT_ARGUMENT(1)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];

    return [bundle LocalizedStringForKey:key value:value table:tableName];
}

- (NSString *)LocalizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)table {
    NSString *result;
    if (!table) {
        table = @"Localizable";
    }
    result = [self localizedStringForKey:key value:value table:table];
    
    // If a localized language doesn't have the string we take the english version.
    if ([result isEqualToString:key] && !UserLanguageIsUSEnglish()) {
        static NSBundle *englishBundle = nil;
        if (!englishBundle)
            englishBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"]];
        
        result = [englishBundle localizedStringForKey:key value:value table:table];
    }
    
    return result;
}

@end
