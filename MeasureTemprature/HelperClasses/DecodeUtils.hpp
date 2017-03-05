//
//  DecodeUtils.hpp
//  BLEDemo
//
//  Created by Akber Sayani on 11/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#ifndef DecodeUtils_hpp
#define DecodeUtils_hpp

#define byte unsigned char
#define UInt16 unsigned short int
#define UInt32 unsigned int
#define Int16 short int
#define Int32 short int

#include <stdio.h>

class DecodeUtils {
    
public:
    static UInt16 UInt16Decode( byte inbyByteA, byte inbyByteB);
    static UInt32 UInt32Decode(UInt16 inui16Payload0, UInt16 inui16Payload1);
    static Int16 DecodeMeasurement32( byte inbyByte3, byte inbyByte4, byte inbyByte6, byte inbyByte7,
                                     double& outdblFloatValue, Int16& outi16DecimalPointPosition);
    static Int16 DecodeMeasurement16( byte inbyByte3, byte inbyByte4,
                                     double& outdblFloatValue, Int16& outi16DecimalPointPosition);
};

#endif /* DecodeUtils_cpp */
