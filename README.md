<view>cmake/stm32cubemx/CMakeLists.txt里面有define的定义，可以看到开发板配置</view>
<view>retarget.c原本是和usart.c配合可以串口通讯方便debug但是弄usart.c,之后要完善别忘记了</view>
<view>build.sh脚本是编译和烧录一气呵成，配合flash.cfg</view>
<view>flash.cfg中烧录的是elf文件，可以更改的，</view>
<view>launch.json文件中debug的文件也是elf，可以换成hex文件，bin应该不行</view>
<view>在遇到cmake问题时可以试着运行</view>
<view>rm -rf ../build.ninja CMakeCache.txt CMakeFiles/</view>
