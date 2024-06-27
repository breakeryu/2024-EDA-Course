
double_value = -0.0886883737996969;% bfb6b44801014fa4
% double_value = 0.0672641204000012;% 3fb13838ad4fed19

if( double_value < 0 )
    S = '1';
else
    S= '0';
end

double_value = abs(double_value);
    
i = 0;
while(double_value < 1)
    double_value = double_value * 2;
    i = i+1;
end

j = 0;
while(double_value > 2)
    double_value = double_value/2;
    j = j+1;
end

E = i + j;
if(j == 0)
    E = -E;
end
E = E+1023;
E = dec2bin(E,11);

M52 = dec2bin(floor((double_value-1)*2^52),52);

r = [S,E,M52];  %二进制字符串

r_hex = [];     %十六进制字符串
for divd_time = 1:4
    %将二进制字符划分为4段16位，转换为十六进制
    start_index = (divd_time-1) * 16 + 1;
    stop_index = divd_time * 16;
    dec_r1 = r(start_index : stop_index);
    r_hex = [r_hex,dec2hex(bin2dec(dec_r1))];
end

