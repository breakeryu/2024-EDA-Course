
function  r = ieee_754_double_to_64bits(double_value)
    %  V = (-1)^s *（1+M）* 2^(E-1023)（双精度）

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
end