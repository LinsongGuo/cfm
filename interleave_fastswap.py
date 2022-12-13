import os
import re

ratio_ = []
res_ = []

for i in range(1, 11):
    ratio = 0.1 * i
    os.system("./benchmark.py interleave {} | grep 'Exec time' > tmp.txt".format(ratio))
    with open('tmp.txt', 'r') as f:
        tmp = f.readline()
        t = float(re.findall(r"\d+\.?\d*",tmp)[0])
    res_.append(t/1000/1000)
    ratio_.append(ratio)
    
with open('result/interleave-fastswap.csv', 'w') as f:
    f.writelines('ratio,exe_time\n')
    for i in range(len(ratio_)):
        f.writelines('{:.2},{}\n'.format(ratio_[i], res_[i]))
        
    
