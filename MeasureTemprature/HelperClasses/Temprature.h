//
//  Temprature.h
//  BLEDemo
//
//  Created by Akber Sayani on 09/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#ifndef Temprature_h
#define Temprature_h

#define byte unsigned char
#define UInt16 unsigned short int
#define UInt32 unsigned int
#define Int16 short int
#define Int32 short int

#include <stdio.h>
#include <string>

using namespace std;

namespace test {
    class HelloTest
    {
    public:
        static Int16 DecodeMeasurement32( byte inbyByte3, byte inbyByte4, byte inbyByte6, byte inbyByte7, double& outdblFloatValue, Int16& outi16DecimalPointPosition);
    };
}


#endif /* Temprature_h */
