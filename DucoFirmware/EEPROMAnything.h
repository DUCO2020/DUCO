// Args
//    - int ee: the starting address of the object to be stored in EEPROM
//    - T& value: the obj variable holding the data
// return
//    - i: the size of the obj in byte   
template <class T> int EEPROM_writeAnything(int ee, const T& value)
{
    const byte* p = (const byte*)(const void*)&value;
    unsigned int i;
    for (i = 0; i < sizeof(value); i++)
          // EEPROM operation only supports byte-grained 
          EEPROM.write(ee++, *p++); // copy byte by byte from p to ee
    return i;
}

// Args
//    - int ee: the starting address of the object stored in EEPROM
//    - T& value: the data from EEPROM will be loaded to this obj variable
// return
//    - i: the size of the obj in byte
template <class T> int EEPROM_readAnything(int ee, T& value)
{
    byte* p = (byte*)(void*)&value; // from versatile pointer to a byte*
    unsigned int i;
    for (i = 0; i < sizeof(value); i++)
          *p++ = EEPROM.read(ee++); // p will modify the content storing at value's address
    return i;
}
