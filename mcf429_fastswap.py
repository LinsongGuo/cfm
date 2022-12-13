import os

ratio_ = []
res_ = []

for i in range(1, 21):
    ratio = 0.05 * i
    os.system('./benchmark.py mcf429 {}'.format(ratio))
    with open('tmp.txt', 'r') as f:
        res = f.readline()
    res_.append(res)
    ratio_.append(ratio)
    
with open('result/mcf429-fastswap.csv', 'w') as f:
    f.writelines('ratio,exe_time\n')
    for i in range(len(ratio_)):
        f.writelines('{:.2},{}\n'.format(ratio_[i], res_[i]))
        
    
