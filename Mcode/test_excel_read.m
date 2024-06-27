
clc; 
clear all;
format long;
%读取表格数值和文本数据
filename = 'm_wave_result.xlsx';    %文件名称
sheet = 1;                          %文件的第几个表格
xlRange = 'A1:A1000';                 %表格范围
[num,txt,raw] = xlsread(filename,sheet,xlRange);

mlength = length(txt);

earse_str = '+1 ';

for i=1:mlength
    str = txt(i,1);
    str = erase(str,earse_str);
    cell_str = cell2mat(str);
    
    r_wave(i) = hex2num(m64bits_to_hex(cell_str));
end

real_period_time = 100e-6 ;   %50us
real_single_time = 10e-6 ;   %10us
fs = 10e+6               ;   %10Mhz采样率

%采样时间处理
t_all = 1/fs:1/fs:real_period_time;

plot(t_all,r_wave);
title("FPGA仿真数据的非相参积累波形");
xlabel("Time / S");
ylabel("Amplitude / V");

real_signal_length = length(t_all);
t_single = 1/fs:1/fs:real_single_time;

%信号波形生成
pluse_amplitude = 0.3;   %单位V，范围0~5V
real_pluse_signal = pluse_amplitude * rectpuls(t_single);
real_pluse_signal_length = length(real_pluse_signal);
real_idel_signal = [zeros(1,100),real_pluse_signal(1:real_pluse_signal_length),zeros(1,real_signal_length-real_pluse_signal_length-100)];

snr_fpga_single_period = snr(real_idel_signal,r_wave-real_idel_signal)


function r_hex = m64bits_to_hex(r)
    t_hex = [];
    for divd_time = 1:4
        %将二进制字符划分为4段16位，转换为十六进制
        start_index = (divd_time-1) * 16 + 1;
        stop_index = divd_time * 16;
        dec_r1 = r(start_index : stop_index);
        temp_hex = dec2hex(bin2dec(dec_r1));
        if length(temp_hex) < 4
            temp_hex = ['0',temp_hex];
        end
        t_hex = [t_hex,temp_hex];
    end
    r_hex = t_hex;
end



