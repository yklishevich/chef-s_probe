//
//  DecodeUtils.cpp
//  BLEDemo
//
//  Created by Akber Sayani on 11/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#include "DecodeUtils.hpp"
#include <math.h>

/* Combinde 2 bytes to an unsigned 16 bit integer */
UInt16 DecodeUtils::UInt16Decode( byte inbyByteA, byte inbyByteB)
{
    return (UInt16)((UInt16)((255 - inbyByteA) << 8) | inbyByteB);
}

/* Combind 2 unsigned 16 Bit integer to an unsigned 32 bit integer */
UInt32 DecodeUtils::UInt32Decode(UInt16 inui16Payload0, UInt16 inui16Payload1)
{
    return (UInt32)( inui16Payload0<< 16 | inui16Payload1);
}


/* Calculate measuring value from 4 bytes of received data */

Int16 DecodeUtils::DecodeMeasurement32( byte inbyByte3, byte inbyByte4, byte inbyByte6, byte inbyByte7, double& outdblFloatValue, Int16& outi16DecimalPointPosition)
{
    outdblFloatValue = 0;
    outi16DecimalPointPosition = 0;
    
    UInt16 ui16Integer1, ui16Integer2;
    
    ui16Integer1 = UInt16Decode (inbyByte3, inbyByte4);
    ui16Integer2 = UInt16Decode (inbyByte6, inbyByte7);
    
    UInt32 ui32Integer = UInt32Decode (ui16Integer1, ui16Integer2);
    
    byte value = 0xFF;
    value = value - inbyByte3;
    /* Combine bytes, with Exampledata: 0x8DFFFFFC */
    outi16DecimalPointPosition = (Int16)( ( value >> 3 ) - 15 );
    
    /* Get decimal point, with Exampledata: 0x0002*/
    ui32Integer = ui32Integer & 0x07FFFFFF;
    
    /* Decode raw value, with Exampledata: 0x05FFFFFC */
    if ((100000000 + 0x2000000) > ui32Integer)
    {
        /* Data is a valid value */
        if (0x04000000 == (ui32Integer & 0x04000000))
        {
            ui32Integer = (ui32Integer | 0xF8000000);
            
            /* With Exampledata: 0xFDFFFFFC */
        }
        
        ui32Integer = (UInt32)(ui32Integer + 0x02000000);
        /* with Exampledata: 0xFFFFFFFC */
    }
    
    else
    {
        /* Data contains error code, decode error code */
        
        outdblFloatValue = (double)(ui32Integer - 0x02000000 - 16352.0);
        outi16DecimalPointPosition = 0;
        
        return -36; /* Return value is error code */
        
    }
    
    /* Convert to floating point value, with Exampledata: -4f */
    
    outdblFloatValue = (double)(Int32)ui32Integer;
    
    outdblFloatValue = outdblFloatValue / ( pow( 10, (double)outi16DecimalPointPosition) );
    
    return 0; /* Return value is OK, with Exampledata: -0,04 */
    
}

/* Calculate measuring value from 2 bytes of received data */
Int16 DecodeUtils::DecodeMeasurement16( byte inbyByte3, byte inbyByte4, double& outdblFloatValue, Int16& outi16DecimalPointPosition)
{
    Int16 ui16Integer = UInt16Decode(inbyByte3, inbyByte4);
    outi16DecimalPointPosition = (Int16)((ui16Integer& 0xC000) >> 14);
    ui16Integer = (UInt16)(ui16Integer& 0x3FFF);
    if ((ui16Integer >= 0x3FE0) && (ui16Integer <= 0x3FFF))
    {
        outdblFloatValue = (double)ui16Integer - (double)16352.0;
        
        return -36; /* Return value is error code*/
    }
    
    Int32 i32Nenner = (Int32)( pow( 10.0, (double)outi16DecimalPointPosition ) );
    Int32 i32Zaehler = (Int32)( (double)ui16Integer - (double)2048.0 );
    
    outdblFloatValue = (double)((double)i32Zaehler / (double)i32Nenner);
    
    return 0; /* Return value is valid, OK */
}

int readHeader( byte* sampledata) {
    byte address = sampledata[0];
    
    int queryCode = sampledata[1] & 0xF0;
    byte priority = ( sampledata[1] & 0x08 ) >> 3;
    short length = sampledata[1] & 0x006;
    byte direction = ( sampledata[1] & 0x002 ) >> 1;
    
    return length;
}