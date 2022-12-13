import os

ratio_ = []
res_ = []

for i in range(1, 32, 2):
    ratio = 
    os.system('./benchmark.py dataframe {}'.format(ratio))
    with open('tmp.txt', 'r') as f:
            tmp = float(f.readline())
        v.append(tmp)
    avg = sum(v)/len(v)
    v.append(avg)
    res_.append(v)
    ratio_.append(ratio)
    
with open('result/dataframe-fastswap-avg.csv', 'w') as f:
    f.writelines('ratio,exe_time\n')
    for i in range(len(ratio_)):
        f.writelines('{:.2},{},{},{},{},{}\n'.format(ratio_[i], res_[i][0], res_[i][1], res_[i][2], res_[i][3], res_[i][4], res_[i][5]))
        
    
