//
// Created by B Pan on 12/3/23.
//

//TFTP client program - CSS 432 - Winter 2024

#include <cstdio>
#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <cstdlib>
#include <cstring>
#include <unistd.h>
#include "TftpError.h"
#include "TftpOpcode.h"
#include "TftpCommon.cpp"

#define SERV_UDP_PORT 61125
#define SERV_HOST_ADDR "127.0.0.1"

/* A pointer to the name of this program for error reporting.      */
char *program;

/* The main program sets up the local socket for communication     */
/* and the server's address and port (well-known numbers) before   */
/* calling the processFileTransfer main loop.                      */

int main(int argc, char *argv[]) {
    program = argv[0];

    int sockfd;
    struct sockaddr_in cli_addr, serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    memset(&cli_addr, 0, sizeof(cli_addr));

    /*
     * TODO: initialize server and client address, create socket and bind socket as you did in
     * programming assignment 1
     */

    /*
     * TODO: Verify arguments, parse arguments to see if it is a read request (r) or write request (w),
     * parse the filename to transfer, open the file for read or write
     */

    /*
     * TODO: create the 1st tftp request packet (RRQ or WRQ) and send it to the server via socket.
     * Remember to use htons when filling the opcode in the tftp request packet.
     */

    /*
     * TODO: process the file transfer
     */

    /*
     * TODO: Don't forget to close any file that was opened for read/write, close the socket, free any
     * dynamically allocated memory, and necessary clean up.
     */

    exit(0);
}
