# coding: utf8
# script for testing PythonThread 
# Jurassic Pork october 2020
import time
print('Coundown Thread1 :')
time.sleep(1.0)
i = 1
while i < 5:
     print('Thread1 : ',5 - i)
     i += 1
     time.sleep(1.0)
print('Thread1 terminated')
