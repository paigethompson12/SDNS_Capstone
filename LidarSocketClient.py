import socket
import struct
import math
import matplotlib.pyplot as plt
import time
#server_name = ip address of our turtlebot4
server_name ="192.168.2.242"
server_port = 12000
x=[]
y=[]
conf= []
data = []
timeData = []
#UDP connection
client_socket = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
print('Connected')
lst = ':)'
msg = lst.encode("utf-8")
#send message to turtlebot so they get our ip address and port number to send data back
client_socket.sendto(msg,(server_name,server_port))
print("sent")
while True:
    reply, addr = client_socket.recvfrom(2048)
    #struct sent from turtlebot is lidar data and time stamp
    #iffq = int (confidence), float (angle in degrees), float (distance in mm), long long (time in miliseconds)
    data = struct.unpack('iffq',reply)
    print(data)
    if(data == (0,0.0,0.0,0)):
        break
    conf.append(data[0])
    #need some logic here to subtract turtlebot4 location at time scanned from 0,0 where turtlebot is represented in still captures 
    x.append(math.cos(-math.radians(data[1]))*data[2])
    y.append(math.sin(-math.radians(data[1]))*data[2])
    timeData.append(time.ctime(float(data[3])/1000))
    print(time.ctime(float(data[3])/1000))
#close socket
client_socket.close()
#plot x and y coordinates
plt.scatter(x,y)
plt.ylabel('y(mm)')
plt.xlabel('x(mm)')
plt.show()
