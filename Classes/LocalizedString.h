//
// LocalizedString.h
// RinaPhotoshop
//
// Created by yonglim on 4/20/16.
//

// Deprecated short version:
#define LocalizedString(key, comment) \
    [[NSBundle mainBundle] LocalizedStringForKey:(key) value:@"" table:nil]

// Use this for plural support
#define LocalizedStringWithFormat(key, ...) \
    [[NSBundle mainBundle] LocalizedStringForKeyWithFormat:key, ##__VA_ARGS__]

// Long version. Can be used with genstrings(1) to create strings files. And format variables are checked.
#define LocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) \
    [(bundle ? bundle : [NSBundle mainBundle]) LocalizedStringForKey:(key) value:(val) table:(tbl)]

@interface NSBundle(PlatformLocalization)

- (NSString *)transformToPseudoLanguage:(NSString*)value;

/** @abstract   Returns a localized string from the specified bundle and table.
    @discussion Falls back to english if the key is not localized in the current language,
 
                If enabled, the string is pseudo localized after translation. */
- (NSString *)LocalizedStringForKey:(NSString *)key
                                 value:(NSString *)value
                                 table:(NSString *)tableName NS_FORMAT_ARGUMENT(1);

/** @abstract   Returns a localized string from the specified bundle and table.
    @discussion Falls back to english if the key is not localized in the current language,
 
                If enabled, the string is pseudo localized after translation. */
- (NSString *)LocalizedStringForKey:(NSString *)key
                              language:(NSString*)language
                                 value:(NSString *)value
                                 table:(NSString *)tableName NS_FORMAT_ARGUMENT(1);

/** @abstract   Returns a localized string with plural support.
    @discussion Internally uses NSString methods which rely on plural definitions in .stringsdict files.
 
                Falls back to english if the key is not localized in the current language,
 
                The localized string is pseudo localized if enabled.
 
    @example    LocalizedStringWithFormat(@"CHAT_CALL_EVENT_MISSED_CALL", missedCallCount);

    @note       Only searches the main bundle Localizable files. */
- (NSString*)LocalizedStringForKeyWithFormat:(NSString*)key, ... ;

extern BOOL UserLanguageIsUSEnglish();

@end
