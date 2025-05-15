## 项目结构说明

- `cmake/stm32cubemx/CMakeLists.txt` 包含define定义，可查看开发板配置
- `retarget.c` 需要与 `usart.c` 配合使用以实现串口通信调试（待后续完善）
- `build.sh` 脚本用于一键编译和烧录，需要配合 `flash.cfg` 使用
- `flash.cfg` 中配置烧录的是elf文件（可修改）
- `launch.json` 文件中debug配置使用的是elf文件（可替换为hex文件，不支持bin格式）

## 常见问题处理

当遇到CMake问题时，可以尝试运行以下清理命令：
```bash
rm -rf ./build/CMakeCache.txt ./buildCMakeFiles/ build.ninja
