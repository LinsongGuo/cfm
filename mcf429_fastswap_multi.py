import os
import re

ratio_ = []
res_ = []

for i in range(1, 21):
    ratio = i * 0.05
    v = []
    for j in range(5):
        os.system('./benchmark.py mcf429 {}'.format(ratio))
        with open('tmp.txt', 'r') as f:
            tmp = f.readline()
            t = float(re.findall(r"\d+\.?\d*",tmp)[0])
        v.append(t)
    v = sorted(v)
    avg = sum(v[1:4]) / 3
    v.append(avg)
    res_.append(v)
    ratio_.append(ratio)
    print(ratio, avg)

with open('result/mcf429-fastswap.csv', 'w') as f:
    f.writelines('ratio,avg_exe,e1,e2,e3,e4,e5\n')
    for i in range(len(ratio_)):
        f.writelines('{:.2},{},{},{},{},{},{}\n'.format(ratio_[i], res_[i][5], res_[i][0], res_[i][1], res_[i][2], res_[i][3], res_[i][4]))
        
    
