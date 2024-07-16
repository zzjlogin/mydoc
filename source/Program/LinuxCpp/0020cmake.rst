
======================================================================================================================================================
Cmake编译
======================================================================================================================================================




对单个Target

::

    target_compile_options(${TARGET_NAME} PUBLIC $<$<PLATFORM_ID:Linux>:-m32>)
    target_link_options(${TARGET_NAME} PUBLIC $<$<PLATFORM_ID:Linux>:-m32>)

为啥限定是PUBLIC呢？因为Target有可能是动态库或者静态库，使用PUBLIC限定符可以使得这些选项传递到可执行文件上，毕竟32位的库也只能是32位的可执行文件使用。

对整个CMake项目
简单粗暴一点就是：(不知道有没有啥副作用，反正官方是没有给出这种方式，纯属民间科学)

::

    if (Linux)
        # set(CMAKE_CXX_FLAGS -m32)
        add_compile_options(-m32)
        set(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -m32")
        set(CMAKE_SHARED_LINKER_FLAGS  "${CMAKE_SHARED_LINKER_FLAGS} -m32")
        set(CMAKE_MODULE_LINKER_FLAGS  "${CMAKE_MODULE_LINKER_FLAGS} -m32")
    endif()

优雅点就是利用一个Interface Libraries。

::

    add_library(32bits-build INTERFACE)
    target_compile_options(32bits-build INTERFACE $<$<PLATFORM_ID:Linux>:-m32>)
    target_link_options(32bits-build INTERFACE $<$<PLATFORM_ID:Linux>:-m32>)

    add_library(lib SHARED lib.cpp)
    target_link_libraries(lib PUBLIC 32bits-build)

    add_executable(main1 main1.cpp)
    target_link_libraries(main PRIVATE 32bits-build)

    add_executable(main2 main2.cpp)
    target_link_libraries(main PRIVATE lib)
    # ...

启发

Linux上通过设置参数来达到修改对应配置，那么上述的Interface Libraries + cmake-generator-expression则可以应用在譬如设置其他编译选项（譬如-std=c++17，-fPIC等等）、头文件包含目录、库文件包含目录、编译宏定义等等。










