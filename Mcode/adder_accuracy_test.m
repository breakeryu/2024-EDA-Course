clc;
clear all;
format long;


r_8_number = [  '0011111110101110100111110011011001001001100110111111011011010011';
                '0011111101111011101101110111000101010101000111111011001111111100';
                '0011111110110100011111100111010111100101100011111110000010011101';
                '0011111110111110010000000011011001011010011101000001101110001100';
                '0011111110011011101011110101011001011100100101010111011101111011';
                '0011111101110101100100011011001001010011101010011100001000011110';
                '0011111110101010011110001000111101001011111011000101110110001011';
             ];
         
hex_src_number = ["";"";"";"";"";""]; 
hex_result_number = ["";"";"";"";"";""]; 
for i= 1:6
    hex_src_number(i,:) = m64bits_to_hex(r_8_number(i,:));
    result_adder(i) =  hex2num(m64bits_to_hex(r_8_number(i,:))) + hex2num(m64bits_to_hex(r_8_number(i+1,:)));
    hex_result_number(i) = m64bits_to_hex(ieee_754_double_to_64bits(result_adder(i)));
end
         

FPGA_hex_result = [     "3FB10B123A1FF6A9";
                        "3FB639ECFAE1DBDC";
                        "3FC95F562001FE14";
                        "3FC29605F8CCBCB5";
                        "3FA089E178BFF401";
                        "3FAD2AC5966195CE";
                    ];

                
x = 1:1:6

for i = 1:6
    result_fpag_double(i) = hex2num(FPGA_hex_result(i));
end

relative_error = 0;

for i = 1:6
    relative_error = abs(result_fpag_double(i)- result_adder(i))/result_adder(i)
end

relative_error = relative_error/6;
    
figure
plot(x,result_fpag_double,'go',x,result_adder,'r*')
title("加法器结果对比")
xlabel("序号")
ylabel("求和结果")
                
    