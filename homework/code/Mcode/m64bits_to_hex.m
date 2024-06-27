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