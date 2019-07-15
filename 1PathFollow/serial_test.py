import serial
import time


print ("Opening serial port...")
arduino = serial.Serial('COM5', 9600, timeout = 1)
print ("initialization complete")


f = open('test_out.txt', 'r+')
s = f.readlines()
print(s)

for i in s:
    arduino.write(i.encode())
    time.sleep(0.1)

arduino.close()
