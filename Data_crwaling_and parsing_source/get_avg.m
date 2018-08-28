clc;
clear;
% Make city1~95 daily avg degree information in .mat
load('weather_information.mat');
matching2 = [1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,29,30,31,32,33,34,35,36,37,38,39,41,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95];

check = 0;
for k=1:89
    disp(k);
    eval_tmp = ['tmp_city = city',num2str(matching2(k)),';'];
    eval(eval_tmp);
    
    exp_tmp2 = ['city_avg',num2str(matching2(k)),' = zeros(31,4,12,8);'];
    eval(exp_tmp2);
    
    
    exp_tmp3 = ['city_avg',num2str(matching2(k)),'(iii,:,ii,i) = avg_line;'];
    exp_tmp4 = ['tmp_line = city',num2str(matching2(k)),'(iii*24,:,ii,i);'];
    
    for i = 1:8
        for ii = 1:12
            if (tmp_city(673,1,ii,i) == 0)
                day_size = 28;
            elseif (tmp_city(697,1,ii,i) == 0)
                day_size = 29;
            elseif (tmp_city(721,1,ii,i) == 0)
                day_size = 30;
            else
                day_size = 31;
            end
            
            for iii = 1:day_size
                avg = mean(tmp_city(((iii-1)*24+1):iii*24,5,ii,i));
                eval(exp_tmp4);
                
                avg_line = [tmp_line(1),tmp_line(2),tmp_line(3),avg];
                eval(exp_tmp3);
            end
        end
    end

end