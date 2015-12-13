// http://wiki.secondlife.com/wiki/XTEA_Strong_Encryption_Implementation

//XTEA Strong Encryption Implementation - Linden Scripting Language (LSL)
//Version 1.0a Alpha
//Copyright (C) 2007 by Strife Onizuka (blindwandererATgmail.com)
//
//Version 1.0
//Copyright (C) 2007 by Morse Dillon (morseATmorsedillon.com)
//
//This program is free software; you can redistribute it and/or
//modify it under the terms of the GNU General Public License
//as published by the Free Software Foundation; either version 2
//of the License, or (at your option) any later version.
//
//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with this program; if not, write to the Free Software
//Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
//02110-1301, USA.
//========================================================================
//
//Included at the end of this source listing is a small bit of example 
//code that shows the usage.  If you wish to include this implementation 
//in your own work, just replace the example code with your own.  Also, 
//please do not reuse or redistribute this work without including the 
//above text attributing this code to its author Morse Dillon, the above
//GPL statement, and this documentation.
//
//This is an implentation of the XTEA (eXtended Tiny Encryption Algorithm) 
//block cypher.  (X)TEA is a very good choice of cipher when security
//is important but computational power is limited.  Although I did a
//lot of work on this implementation, enormous amounts of credit must
//be given to the creators of the algorithm and those who came before
//me to implement it in other languages and computing environments.
//
//***If you do decide to use this code in a project, I'd appreciate 
//hearing about it.  You can reach me by e-mail at:  
//morseATmorsedillon.com
//
//
//ABOUT TEA AND XTEA
//------------------
//TEA was originally designed by David Wheeler and Roger Needham 
//of the Cambridge Computer Laboratory.  The algorithm itself is not
//subject to any patents.  While the original TEA was found to have
//some minor weaknesses, XTEA (implemented herein) addresses these.  
//
//TEA and its derivatives consist of 64-bit block Feistel network 
//with a 128-bit key.  This implementation uses six cycles, or rounds,
//which is less than one would like but still provides a reasonable
//level of security (16 is sufficient while 8 is enough for most 
//applications).  Six is said to achieve theoretically good dispersion, 
//but should more security be desired the number of cycles can easily be 
//modified by changing the CYCLES global variable.  Due to the low 
//execution speed of LSL scripts, it's suggested to make this as low as 
//your comfort level allows.  Encryption time scales linearly with the 
//number of cycles.
//
//For more information about XTEA, see the following:
//
//Original Paper by Walker and Needham
//http://www.ftp.cl.cam.ac.uk/ftp/papers/djw-rmn/djw-rmn-tea.html
//
//Wikipedia on TEA
//http://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm
//
//
//ABOUT THIS IMPLEMENTATION
//-------------------------
//This is a barebones implementation, and is meant to be included in
//the body of the script needing encryption facilities or wrapped
//in a link message handler.  If the latter approach is desired, care
//should be taken to only send link messages to the prim containing
//this implementation.  If ALL_PRIMS is used as the destination,
//one could link a link message listener to the object and intercept
//cleartext communications.  
//
//If you plan to place this code into the same script as that needing
//encryption facilities, you need only call the following functions:
//
//string Encrypt(string cleartext)
//string Decrypt(string cyphertext)
//
//Simple as that.
//
//This implementation does not provide any secure key exchange, so in
//terms of key generation and exchange you're on your own.
//
//The 128-bit key is contained in four LSL integers:  KEY1, KEY2, KEY3,
//and KEY4.  These are global variables at the beginning of the source
//and can be set using a method that works for you.
//
//
//CHANGES
//-------
//
//1.0a - Alpha
//*General optimization to run faster and use less bytecode.
//*Encrypt: Pad works differently, no longer extra characters appended to the output.
//*TEAEncrypt: Changed the return type
//*ord: Added null support.
//
//1.0
//*Initial Release
//
//
//FUTURE CHANGES
//--------------
//
//It would be nice if it supported UTF-8; but adding that would be alot
//of work. The main issue is the decoding, the bytes would have to be
//reassembled into characters. It would be time consuming. Another possibility
//would be to implement XTEA to output to BASE64 instead of hex strings (also
//time consuming to implement).
//
//
//**************IF YOU READ ONE THING IN HERE, READ THIS*******************
//It is VERY important to remember that there is no such thing as
//'cookbook cryptography'!  Simply using this cypher does not guarantee
//security.  Security is an end-to-end concern and responsibility lies
//with you to thoroughly examine your project from all possible angles
//if valuable data is at risk.  If you doubt this, ask any thief how they'd
//rather break into your house - futzing about with picking a high-security
//deadbolt on the front door or walking in through the back door that you 
//left open.
 
//******************USER-CONFIGURABLE GLOBALS BEGIN HERE*******************
 
//ENCRYPTION KEYS KEY[1-4]
//These together make up the 128-bit XTEA encryption key.  See the above 
//documentation for details.  Whatever you do, don't leave them as the default.
//Don't be stupid and make it obvious like your av's key.
integer KEY1 = 0x00000000;
integer KEY2 = 0x00000000;
integer KEY3 = 0x00000000;
integer KEY4 = 0x00000000;

integer DEBUG_FLAG =FALSE;
//COMM_CHANNEL
//Specifies which channel should be used for debug and test harness communication.
integer COMM_CHANNEL = 0;
 
//CYCLES
//Specifies the number of rounds to be used.  See the above documentation for
//details.
integer CYCLES = 32;//was 6;
integer rounds = 32;
 
//******************USER-CONFIGURABLE GLOBALS END HERE*********************
 
//Other Globals
list cypherkey = [];


integer ENCRYPTOR_EMAIL_OBJECT = 1000080;
integer ENCRYPTOR_SAY_REGION = 1000081;
integer ENCRYPTOR_SET_PASSWORD = 1000082;
integer ENCRYPTOR_SET_CHANNEL = 1000083;
integer ENCRYPTOR_SET_PROTOCOL = 1000084;
integer ENCRYPTOR_SET_VERSION = 1000085;
string ProtocolSignature = "ENC"; // your own signature
float ProtocolVersion = 1.1; // can range from 0.0 to 255.255
string Password = "P@ssw0rd"; // change this to your own password
integer communicationsChannel = PUBLIC_CHANNEL;


debug(string text)
{
    llSay(DEBUG_CHANNEL, text);
}
init()
{
        string hash = llMD5String((string)llGetOwner() + Password, 0);
        
//        KEY1 = (integer)("0x" + llGetSubString(hash, 0, 7));
//        KEY2 = (integer)("0x" + llGetSubString(hash, 9, 15));
//        KEY3 = (integer)("0x" + llGetSubString(hash, 16, 23));
//        KEY4 = (integer)("0x" + llGetSubString(hash, 24, 31));
            
        cypherkey = [KEY1,KEY2,KEY3,KEY4];

    
    // setup defaults to have a little better security
    
}
list readBase64Integers(string base64, integer byteIndex, integer limit)
{
    debug("readBase64Integers(\"" + base64 + "\", " + (string)byteIndex + ", " + (string)limit + ");");

    // returns a list of integers starting at the specified byte index
    // each integer is 32 bits / 4 bytes
    // if base64 string is not long enough, 
    // less integers are returned then specified in the limit
    
    integer i;
    list values = [];
    integer offset;
    integer value;
    integer byte;
    
    // loop through each value
    for(i = 0; i < limit; i++)
    {
        value = 0;
        // get byte at specific index
        byte = readBase64Byte(base64, byteIndex + (i * 4));
        
        // if first byte of integer was not found
        if(byte == -1)
        {
            debug("return [" + llList2CSV(values) + "]");
            
            // return integers that we already have 
            return values;
        }
        
        // Loop through integers bytes
        for(offset = 0; byte != -1 && offset < 4; offset++)
        {
            // shift the bytes bits so they can be applied to the integer
            // in the correct position
            value += byte << (24 - (offset * 8));
            
            // read the next byte represented for the integer
            if(offset != 3)
                byte = readBase64Byte(base64, byteIndex + (i * 4) + offset + 1);
        }
        
        // append the final value of the integer 
        // to the list of values to be returned
        values += [value];
        
    }
    
    debug("return [" + llList2CSV(values) + "]");
    
    // return the integers that were requested
    return values;
}
string writeBase64Integers(string base64, integer byteIndex, list values)
{
    debug("writeBase64Integers(\"" + base64 + "\", " + (string)byteIndex + ", [" + llList2CSV(values) + "]);");

    // returns a list of integers starting at the specified byte index
    // each integer is 32 bits / 4 bytes
    // if base64 string is not long enough, 
    // less integers are returned then specified in the limit
    
    integer i;
    integer offset;
    integer value;
    integer byte;
    
    integer count = llGetListLength(values);
    
    // loop through each value
    for(i = 0; i < count; i++)
    {
        integer value = llList2Integer(values, i);
        
        integer b1 = (value >> 24) & 0x000000FF;
        integer b2 = (value >> 16) & 0x000000FF;
        integer b3 = (value >> 8) & 0x000000FF;
        integer b4 = (value >> 0) & 0x000000FF;
        
        if(b1 > 255 || b2 > 255 || b3 > 255 || 24 > 255)
            debug("writing byte > 255! " + llList2CSV([b1,b2,b3,b4]));
            
        base64 = writeBase64Byte(base64, byteIndex + (i * 4) + 0, b1);
        base64 = writeBase64Byte(base64, byteIndex + (i * 4) + 1, b2);
        base64 = writeBase64Byte(base64, byteIndex + (i * 4) + 2, b3);
        base64 = writeBase64Byte(base64, byteIndex + (i * 4) + 3, b4);
    }
    
    debug("return " + base64);
    // return the new base64
    return base64;
}

integer readBase64Byte(string base64, integer byteIndex)
{
    debug("readBase64Byte(\"" + base64 + "\", " + (string)byteIndex + ");");
    
    integer byteIndex3 = byteIndex << 3;
    
    // determine where first part of byte begins
    integer startIndex = byteIndex3 / 6;
    
    // grab two characters from base64 string
    string chunk = llGetSubString(base64, startIndex, ++startIndex);
    
    if(chunk == "")
    {
        debug("return -1");
        return -1;
    }

    // make sure chunk has a byte
    if(llListFindList(["", "==", "A=", "Q=", "g=", "w="], [chunk]) != -1)
    {
//        llSay(DEBUG_CHANNEL, "Byte does not exist in specified location. [" + (string)byteIndex + "]");
        debug("return -1");
        return -1;
    }
    
    // if chunk ends with one equal sign
    if(llGetSubString(chunk, 1, -1) == "=")
    
        // strip last character
        chunk = llGetSubString(chunk, 0, 0);
        
    // padd chunk with A's (zero values)
    chunk += "AAAAAA";
    
    // make sure chunk six characters (4 bytes = 6 characters in base64)
    chunk = llGetSubString(chunk, 0, 5);
    
    // get integer value
    integer int32 = llBase64ToInteger(chunk);
    
    // determine how many bits to drop off
    integer shift = 24; // 3 bytes worth
    
    // allow up to two or four more bits from being dropped
    // depending on byte position
    // (20, 22, 24)
    shift -= byteIndex3 % 6;
    
    // shift bits to drop unnecessary bits on the right
    integer byte = int32 >> shift;
    
    // grab last eight bits
    byte = byte & 0XFF;
    
    debug("return " + (string)byte);
    return byte;
}
string writeBase64Byte(string base64, integer byteIndex, integer value)
{
    // this method replaces an existing byte with a new value
    // if the base64 string does not contain any data at the
    // byte index, then it extends the length of the base64 
    // string with null values to support the additional byte
    
    debug("writeBase64Byte(\"" + base64 + "\", " + (string)byteIndex + ", " + (string)value + ");");

    // find out what block that the byte exists in
    // each block of 4 characters represents 3 bytes
    
    integer blockIndex = llFloor(byteIndex / 3.0) * 4;
    
    integer bytes = 0;
    string block;
    integer terminator = -1;
    
    // if base64 doesn't contain position for byte
    if(blockIndex < llStringLength(base64))
    {
    
        block = llGetSubString(base64, blockIndex, blockIndex + 3);
        
        // remember empty bytes
        terminator = llSubStringIndex(block, "=");
        if(terminator != -1)
        {
            block = llGetSubString(block, 0, terminator -1);
            
            if(terminator == 2)
                block += "AA";
            else if(terminator == 3)
                block += "A";
        }
        
        bytes = llBase64ToInteger(block + "AA==");
    }
    
    
    integer b1 = (bytes >> 24) & 0x000000FF;
    integer b2 = (bytes >> 16) & 0x000000FF;
    integer b3 = (bytes >> 8) & 0x000000FF;
    
    // determine what byte to change
    if(byteIndex % 3 == 0)
        b1 = value;
    else if(byteIndex % 1)
        b2 = value;
    else
        b3 = value;
    
    // determine new integer for block
    bytes = (b1 << 24) + (b2 << 16) + (b3 << 8);
    
    // parse new block
    block = llGetSubString(llIntegerToBase64(bytes), 0, 3);

    // replace base64 with new block value
    base64 = llDeleteSubString(base64, blockIndex, blockIndex + 3);
    base64 = llInsertString(base64, blockIndex, block);
    
    debug("return " + base64);
    
    return base64;
}

integer base64ByteCount(string base64)
{
    debug("base64ByteCount(\"" + base64 + "\");");
    integer charCount = llStringLength(base64);
    integer byteCount = 3 * (charCount / 4);
    string chunk = llGetSubString(base64, -2, -1);
    
    // if final quantum is exactly 8 bits
    if(chunk == "==") 
        // ignore assumed bytes
        byteCount -= 2;
    
    // if final quantum is exactly 16 bits
    else if(llGetSubString(chunk, -1, -1) == "=")
        // ignore assumed byte
        byteCount--;

    debug("return " + (string)byteCount);
    return byteCount;    
}
//Function: Encrypt
//Takes cleartext string, pads and bitpacks it, then encrypts it using TEAEncrypt().
string Encrypt(string message)
{
    debug("Encrypt(\"" + message + "\");");
    
    // encode message to base64
    message = llStringToBase64(message);
    
    // UTF-8 may have added some extra bytes
    // let's determine length of message from
    // base64
    integer length = base64ByteCount(message);
    
    integer i = 0;
    
    //Step through cleartext string, encrypting it in 64-bit (8 character) blocks.
    for(i = 0; i < length; i += 8)
    {
        // retrieve next block
        list block = readBase64Integers(message, i, 2);
        
        // Encrypt the block of data
        block = XTEA(block, cypherkey, rounds);
        
        // replace original block with encrypted block
        message = writeBase64Integers(message, i, block);
    }
    
    // prefix message with byte length
    message = llIntegerToBase64(length) + message;
    
    debug("return " + message);
    return message;
}   
 
//Function: Decrypt
//Takes cyphertext, decrypts it with TEADecrypt(), and unpacks it into a string.
string Decrypt(string message)
{
    debug("\n------------------------\nDecrypt(\"" + message + "\");\n------------------------");
    
    // get length of message
    integer length = llBase64ToInteger(llGetSubString(message, 0, 7));
    
    debug("Length is " + (string)length);
    
    // remove length from message
    message = llDeleteSubString(message, 0, 7);
    
    //Initialize variables.
    integer i = 0;
    
    //Step through cyphertext string, descrypting it block by block.
    for(i = 0; i < length; i += 8)
    {
        // Read next block
        list block = readBase64Integers(message, i, 2);
        
        // Decrypt the block of data
        block = XTEA(block, cypherkey, -rounds);

        // Replace encrypted block with decrypted block
        message = writeBase64Integers(message, i, block);
    }
    
    // decode message
    message = llBase64ToString(message);
    
    debug("return " + message);
    
    return message;
}

// XTEA is a version of slightly improved TEA
// The plain or cypher text is in v[0], v[1]
// The key is in k[n], where n = 0 - 3
// The number of coding cycles is given by N and
// the number of decoding cycles is given by -N

list XTEA(list v, list k, integer N) // Replaces TEA's Code and Decode
{
    debug("XTEA([" + llList2CSV(v) + "], [" + llList2CSV(k) + "], " + (string)N + ");");
    
    integer y = llList2Integer(v, 0);
    integer z = llList2Integer(v, 1);
    integer DELTA = 0x9E3779B9;
    integer limit;
    integer sum;
    
    if(N > 0) // encrypt
    {
        limit = DELTA * N;
        sum = 0;
        while(sum != limit)
        {
            y   += (z << 4 ^ ((z >> 5) & ~((~z) >> 5))) + z ^ sum + llList2Integer(k, sum & 3);
            sum += DELTA;
            z   += (y << 4 ^ ((y >> 5) & ~((~y) >> 5))) + y ^ sum + llList2Integer(k, ((sum >> 11) & ~((~sum) >> 11)) & 3);                  }
    }
    else // decrypt
    {
        sum = DELTA * (-N);

         while (sum)
         {   z   -= (y << 4 ^ ((y >> 5) & ~((~y) >> 5))) + y ^ sum + llList2Integer(k, ((sum >> 11) & ~((~sum) >> 11)) & 3);
             sum -= DELTA;
             y   -= (z << 4 ^ ((z >> 5) & ~((~z) >> 5))) + z ^ sum + llList2Integer(k, sum & 3);
         }
    }
    
    debug("return [" + llList2CSV([y,z]) + "]");
    return [y,z];
}

 
default
{
    state_entry()
    {
        init();
        
        llSay(DEBUG_CHANNEL, "=================================");
        llSay(DEBUG_CHANNEL, "New Test");
        llSay(DEBUG_CHANNEL, "=================================");
        
        
        
        //string s = writeBase64Byte("MTIzNDU2Nzg5YWJjZGVmMA==", 15, 45);
        //integer i = readBase64Byte(s, 15);
        //llOwnerSay("got back: " + (string)i);

        string s = Encrypt("123456789abcdef0");
        llOwnerSay(Decrypt(s));
        //llOwnerSay(Decrypt(s));
        //llOwnerSay(Decrypt(Encrypt("123456789abcdef012345678")));
        //llOwnerSay(Decrypt(Encrypt("123456789abcdef0123456789")));
    }
    
}