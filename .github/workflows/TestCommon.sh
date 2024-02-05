#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# $1 = r/w, $2 = source file, $3 = dest file
compare_files () {
  if [ ! -e "$3" ]
  then
    echo -e "${RED}$3 does not exist.${NC}"
    exit 1
  fi
  diff "$2" "$3"
  RESULT=$?
  if [ $RESULT -eq 1 ]
  then
    echo -e "${RED}Test failed: [$1] - Detected difference.${NC}"
    echo $RESULT
    exit 1
  else
    echo -e "${GREEN}Test passed: [$1] - Transfer file from $2 to $3 ${NC}"
  fi
}

print_log () {
  echo -e "${BLUE}Printing log: $1${NC}"
  cat "$1"
}

# $1 = r/w, $2 = source dir, $3 = dest dir, $@ filenames to transfer
test_file_transfer () {
  local mode=$1 && shift
  local src_dir=$1 && shift
  local dest_dir=$1 && shift
  local filenames=("$@")
  for filename in "${filenames[@]}"
  do
    echo -e "${BLUE}Test: Transfer $filename from $src_dir to $dest_dir${NC}"
    rm -f "$dest_dir/$filename" # ensure file does not exist before transfer

    ./tftp-server > server.log 2>&1 &
    sleep 2 # ensure server has started and ready

    ./tftp-client "$mode" "$filename" > client.log 2>&1
    kill "$(jobs -p)"

    print_log server.log
    print_log client.log

    compare_files "$mode" "$src_dir/$filename" "$dest_dir/$filename"
    rm "$dest_dir/$filename" # clean up
    sleep 1
  done
}

# $1 = r/w, $2 = source dir, $3 = dest dir, $@ filenames to transfer
test_file_transfer_continuously () {
  local mode=$1 && shift
  local src_dir=$1 && shift
  local dest_dir=$1 && shift
  local filenames=("$@")
  echo -e "${BLUE}Test: Transfer file continuously from $src_dir to $dest_dir${NC}"
  ./tftp-server > server.log 2>&1 &
  sleep 2 # ensure server has started and ready

  for filename in "${filenames[@]}"
  do
    rm -f "$dest_dir/$filename" # ensure file does not exist before transfer
    ./tftp-client "$mode" "$filename" > "client__${filename}.log" 2>&1
  done
  kill "$(jobs -p)"

  print_log server.log

  for filename in "${filenames[@]}"
  do
    print_log "client__${filename}.log"
    compare_files "$mode" "$src_dir/$filename" "$dest_dir/$filename"
    rm "$dest_dir/$filename" # clean up
  done
  sleep 1
}

# $1 = valgrind log file
check_memory_leak () {
  echo "======================================"
  echo -e " ${BLUE}Checking memory leak for $1${NC}"
  echo "======================================"
  cat "$1"

  result1=$(grep -c "definitely lost: 0 bytes in 0 blocks" "$1")
  result2=$(grep -c "indirectly lost: 0 bytes in 0 blocks" "$1")
  if [[ $(grep -c "All heap blocks were freed -- no leaks are possible" "$1") -eq 1 ]]
  then
    echo -e "${GREEN}Memory check passed. All heap blocks were freed: $1"
  elif [[ $result1 -eq 1 && $result2 -eq 1 ]]
  then
    echo -e "${GREEN}Memory check passed: $1"
  else
    echo -e "${RED}Detected memory leak! $1"
    exit 1
  fi
}

# $1 = r/w, $2 = source dir, $3 = dest dir, $@ filenames to transfer
test_memory_leak_continuous () {
  local mode=$1 && shift
  local src_dir=$1 && shift
  local dest_dir=$1 && shift
  local filenames=("$@")
  local valgrind_output_server="valgrind-out-server.txt"
  local valgrind_output_client_prefix="valgrind-out-client__"
  echo -e "${BLUE}Check memory leak: Transfer file continuously from $src_dir to $dest_dir${NC}"
  valgrind --leak-check=full \
           --show-leak-kinds=all \
           --track-origins=yes \
           --verbose \
           --log-file="$valgrind_output_server" \
           ./tftp-server &
  sleep 2 # ensure server has started and ready

  for filename in "${filenames[@]}"
  do
    rm -f "$dest_dir/$filename" # ensure file does not exist before transfer

    valgrind --leak-check=full \
             --show-leak-kinds=all \
             --track-origins=yes \
             --verbose \
             --log-file="${valgrind_output_client_prefix}${filename}" \
             ./tftp-client "$mode" "$filename"
  done
  kill "$(jobs -p)"

  check_memory_leak "$valgrind_output_server"
  for filename in "${filenames[@]}"
  do
    check_memory_leak "${valgrind_output_client_prefix}${filename}"
    rm "$dest_dir/$filename" # clean up
  done
  sleep 1
}
