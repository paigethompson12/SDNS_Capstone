import socket
from rplidar import RPLidar,RPLidarException
import math
import time
import struct
run = True
conf = []
angle=[]
distance=[]
while run:
  serverSocket = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
  serverSocket.bind(('192.168.2.242',12000))
  try:
    reply,server_address = serverSocket.recvfrom(2048)
    lidar = RPLidar('/dev/RPLIDAR')
    lidar.clean_input()
    info = lidar.get_info()
    print(info)
    health = lidar.get_health()
    print(health)
    lidar.clean_input()
    for i,scan in enumerate(lidar.iter_scans()):
      if (i> len(scan)-8):
        break
 #struct is ifff (int float float) with confidence, angle (degrees), distance(mm), time (miliseconds)
        data = struct.pack('iffq',scan[i][0],scan[i][1],scan[i][2],round(time.time()*1000))
    serverSocket.sendto(data,server_address)
  except RPLidarException:
    print("LidarFailure")
  except KeyboardInterrupt:
    pass
    run = False
  finally:
    lidar.stop()
    lidar.stop_motor()
    lidar.disconnect()
    #code to say we are done sending data
    exitCode = struct.pack('iffq',0,0.0,0.0,0)
    serverSocket.sendto(exitCode,server_address)
    serverSocket.close()
