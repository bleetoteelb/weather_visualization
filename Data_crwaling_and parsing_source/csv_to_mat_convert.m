clc;
clear;
% Make city1~95 hourly degree information in .mat


matching1 = [90,95,98,99,100,101,102,104,105,106,108,112,114,115,119,121,127,129,130,131,133,135,136,137,138,140,146,152,155,156,159,162,165,168,169,170,172,175,184,185,188,189,192,201,202,203,211,212,216,217,221,226,232,235,236,238,243,244,245,247,248,251,252,253,254,255,257,258,259,260,261,262,263,264,271,272,273,276,277,278,279,281,283,284,285,288,289,294,295];
matching2 = [1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,29,30,31,32,33,34,35,36,37,38,39,41,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95];

for k = 1:89
    disp(k);
    file_name = sprintf('Project/data/After%d.csv',matching1(k));
    temp = csvread(file_name);
    exp_tmp2 = ['city',num2str(matching2(k)),' = zeros(31,5,12,8);'];
    eval(exp_tmp2);
    
    exp_tmp3 = ['city',num2str(matching2(k)),'(iiii,:,iii,ii) = temp(i,:);'];

    i=1;
    size_temp = size(temp);
    size_of_matrix = size_temp(1);

    for ii = 1:8
        for iii = 1:12
            iiii = 1;
            while(1)
                eval(exp_tmp3);
                if(i == size_of_matrix)
                    break;
                elseif ( temp(i+1,2) ~= temp(i,2) )
                    i = i+ 1;
                    break;
                else
                    iiii = iiii+1;
                    i = i+ 1;
                end
            end
        end
    end
end
