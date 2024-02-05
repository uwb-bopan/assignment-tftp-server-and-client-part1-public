#!/bin/bash

source ./TestCommon.sh

SERVER_DIR="server-files"
CLIENT_DIR="client-files"

declare -a s2c_filenames=(
            "server-to-client-medium.txt"
            "server-to-client-medium-512.txt"
            "server-to-client-large.txt"
            "server-to-client-large-512.txt"
          )

declare -a c2s_filenames=(
            "client-to-server-medium.txt"
            "client-to-server-medium-512.txt"
            "client-to-server-large.txt"
            "client-to-server-large-512.txt"
          )

if [ "$1" == "single" ]; then
  test_file_transfer 'r' "$SERVER_DIR" "$CLIENT_DIR" "${s2c_filenames[@]}"
  test_file_transfer 'w' "$CLIENT_DIR" "$SERVER_DIR" "${c2s_filenames[@]}"
fi

if [ "$1" == "continuous" ]; then
  test_file_transfer_continuously 'r' "$SERVER_DIR" "$CLIENT_DIR" "${s2c_filenames[@]}"
  test_file_transfer_continuously 'w' "$CLIENT_DIR" "$SERVER_DIR" "${c2s_filenames[@]}"
fi

if [ "$1" == "memcheck" ]; then
  sudo apt-get update
  sudo apt install valgrind

  test_memory_leak_continuous 'r' "$SERVER_DIR" "$CLIENT_DIR" "${s2c_filenames[@]}"
  test_memory_leak_continuous 'w' "$CLIENT_DIR" "$SERVER_DIR" "${c2s_filenames[@]}"
fi

if [ "$1" == "binary" ]; then
  test_file_transfer 'r' "$SERVER_DIR" "$CLIENT_DIR" "server-to-client-random.bin"
  test_file_transfer 'w' "$CLIENT_DIR" "$SERVER_DIR" "client-to-server-random.bin"
fi
