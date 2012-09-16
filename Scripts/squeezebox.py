#! /usr/bin/python2
  
from telnetlib import Telnet
from urllib import unquote
from time import sleep
  
def query(server, port, player, commands):
    tn = Telnet(server, port)
  
    for command in commands:
        tn.write("%s %s ?\n" % (player, command))
  
    sleep(0.2)
    feedback = tn.read_very_eager().split('\n')
    results = [(cmd,unquote(res)[len(player)+len(cmd)+2:]) \
                 for cmd,res in zip(commands, feedback)]
    return dict(results)
  
if __name__ == "__main__":
    server = "192.168.1.100" # according to your server
    port = 9090
    player = "00:04:20:12:9e:43" # according to your player
    commands = ("artist", "title")
  
    res = query(server, port, player, commands)
    print "%(artist)s - %(title)s" % res
  

