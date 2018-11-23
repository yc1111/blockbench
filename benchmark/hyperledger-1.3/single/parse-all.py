import sys                                                                      
import re                                                                       
                                                                                
if len(sys.argv) != 3:                                                          
    print "python parse-result.py <NThread> <TXRATE>"
    exit()                    
                                                                                
T = sys.argv[1]                                                                 
R = sys.argv[2]                                                                 
                                                                                
count = 0                                                                       
notx = 0                                                                        
tps = 0                                                                                
filename = "logs/hl_exp_{}_threads_{}_rates/client_0_{}".format(T, R, T)
with open(filename, "r") as fp:                                               
  for line in fp:                                                             
    res = re.search('tx count = ([0-9]*) latency = ([0-9]*)', line, re.IGNORECASE)
    if res:                                                                   
      count += 1                                                              
    elif line.startswith("polled block"):                                        
      idx = line.index(":")                                                   
      notx += int(line[idx+2:-6])
if count > 0 :                                                                
  tps = float(notx)/(count*2)                                                 
                                                                                
print '{}\n'.format(tps)
