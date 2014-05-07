// string.cpp
//

#include <stdafx.h>
#include <iostream.h>

int main(int argc, char* argv[])
{
    cout << "---Use a pointer to traverse an array---\n";
    char aString[] = "This is a string";
    char* pString = aString;   // a pointer to a string   
    cout << aString << endl;    // Show the full string first.
    while(*pString)
    {
        cout << "*pString =" << *pString++ << endl;
    }

    return 0;
}
