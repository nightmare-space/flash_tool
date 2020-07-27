#include <stdlib.h>
int main()
{
    system("open /Users/nightmare/Desktop/nightmare-space/flash_tool/example/build/macos/Build/Products/Release/example.app");
    system("kill -9 $(ps -p $(ps -p $PPID -o ppid=) -o ppid=) ");

    return 0;
}