char* cStringCopy(const char* string)
{
   if (string == NULL)
   {
       return NULL;
   }
   char* res = (char*)malloc(strlen(string) + 1);
   strcpy(res, string);
   return res;
}
extern "C"
{
    // -- we define our external method to be in C.
    char* _getCountryCode()
    {
     // We can use NSString and go to the c string that Unity wants
     // UTF8String method gets us a c string. Then we have to malloc        
     //a copy to give to Unity. I reuse a method below that makes it //easy.
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];

    return cStringCopy([countryCode UTF8String]);
    }
}