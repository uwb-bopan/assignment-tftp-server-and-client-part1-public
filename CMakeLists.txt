cmake_minimum_required(VERSION 3.26)
project(css432_tftp)

set(CMAKE_CXX_STANDARD 17)
enable_testing()

configure_file(.github/workflows/TestCommon.sh TestCommon.sh COPYONLY)
configure_file(.github/workflows/TestSmallFiles.sh TestSmallFiles.sh COPYONLY)
configure_file(.github/workflows/TestLargeFiles.sh TestLargeFiles.sh COPYONLY)

file(COPY .github/workflows/server-files DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
file(COPY .github/workflows/client-files DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")

add_executable(tftp-client TftpClient.cpp
        TftpCommon.cpp
)
add_executable(tftp-server TftpServer.cpp
        TftpCommon.cpp
)
