#import <Foundation/Foundation.h>
#import "HTAutocompleteTextField.h"

typedef enum {
    HTAutocompleteTypeEmail, // Default
    HTAutocompleteTypeColor,
} HTAutocompleteType;

@interface HTAutocompleteManager : NSObject <HTAutocompleteDataSource>

+ (HTAutocompleteManager *)sharedManager;

@end
