//
// Created by B Pan on 12/3/23.
//
//for system calls, please refer to the MAN pages help in Linux
//TFTP server program over udp - CSS432 - winter 2024
#include <cstdio>
#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <cstdlib>
#include <cstring>
#include <unistd.h>
#include "TftpCommon.cpp"

#define SERV_UDP_PORT 61125

char *program;

int handleIncomingRequest(int sockfd) {

    struct sockaddr cli_addr;

    /*
     * TODO: define necessary variables needed for handling incoming requests.
     */

    for (;;) {

        /*
         * TODO: Receive the 1st request packet from the client
         */

        /*
         * TODO: Parse the request packet. Based on whether it is RRQ/WRQ, open file for read/write.
         * Create the 1st response packet, send it to the client.
         */

        /*
         * TODO: process the file transfer
         */

        /*
         * TODO: Don't forget to close any file that was opened for read/write, close the socket, free any
         * dynamically allocated memory, and necessary clean up.
         */
    }
}

int main(int argc, char *argv[]) {
    program=argv[0];

    int sockfd;
    struct sockaddr_in serv_addr;

    memset(&serv_addr, 0, sizeof(serv_addr));

    /*
     * TODO: initialize the server address, create socket and bind the socket as you did in programming assignment 1
     */

    handleIncomingRequest(sockfd);

    close(sockfd);
    return 0;
}