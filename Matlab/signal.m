N = 1024;       %采样频率   
n = 0:N-1;      %采样点

fs = 1000;      %有效信号频率
fn1 = 20000;    %噪声频率1
fn2 = 10000;    %噪声频率2
fn3 = 100000;   %噪声频率3

s=fix( ( sin(2*pi*fs*n/N)  +  0.2*sin(2*pi*fn1*n/N)  +  0.5*sin(2*pi*fn2*n/N)  +  0.1*sin(2*pi*fn3*n/N)  )*16383+32767  );   %混合信号

fid = fopen('signal.txt','wt');
fprintf(fid,'%x\n',s);
fclose(fid);                        %存储到*.txt文件

figure;
plot(n,s);                          %查看波形
