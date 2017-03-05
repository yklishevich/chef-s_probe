#ifndef Prefix_Defines_h
#define Prefix_Defines_h

#if DEBUG || 1
#   define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DebugLog(...)
#endif

#endif
