function varargout = weather(varargin)
%WEATHER MATLAB code file for weather.fig
%      WEATHER, by itself, creates a new WEATHER or raises the existing
%      singleton*.
%
%      H = WEATHER returns the handle to a new WEATHER or the handle to
%      the existing singleton*.
%
%      WEATHER('Property','Value',...) creates a new WEATHER using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to weather_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      WEATHER('CALLBACK') and WEATHER('CALLBACK',hObject,...) call the
%      local function named CALLBACK in WEATHER.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help weather

% Last Modified by GUIDE v2.5 16-Dec-2017 16:47:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @weather_OpeningFcn, ...
                   'gui_OutputFcn',  @weather_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before weather is made visible.
function weather_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for weather
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    global weather_infor;
    global weather_infor_avg;
    global latlon_infor;
    global select_infor;
    global matching_infor;
    global city_name;
    global compare_city;
    
    weather_infor = load('weather_information.mat');
    weather_infor_avg = load('weather_information_avg.mat');
    APIkeys = load('APIkey.mat');
    latlon_infor = load('latlon.mat');
    temp_matching = load('matching.mat');
    matching_infor = temp_matching.matching;
    temp_city_name = load('city_name.mat');
    city_name = temp_city_name.city_name;
    
    select_infor.location = 1;
    select_infor.year = 1;
    select_infor.month = 1;
    select_infor.day = 1;
    select_infor.hour = 1;
    select_infor.type = 1;

    select_infor.lat = latlon_infor.lat(matching_infor(select_infor.location));
    select_infor.lon = latlon_infor.lon(matching_infor(select_infor.location));


    axes(handles.map);
    [xx yy M Mcolor] = get_google_map(select_infor.lat,select_infor.lon,'Zoom',10, ...
            'Marker',sprintf('%4f,%4f',select_infor.lat,select_infor.lon),'MapType','roadmap'); 
    imagesc(xx,yy,M); 
    shading flat;
    colormap(Mcolor);

% --- Outputs from this function are returned to the command line.
function varargout = weather_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;
    
% --- Executes on button press in get_information.
function get_information_Callback(hObject, eventdata, handles)
    global latlon_infor;
    global select_infor;
    global matching_infor;
    global weather_infor;
    global weather_infor_avg;
    global city_name;
    global compare_city;
    global zoom_size;
    
    switch select_infor.location
        case 10
            warndlg('Wrong location!','!! Wrong !!');
            return;
        case 24
            warndlg('Wrong location!','!! Wrong !!');
            return;
        case 36
            warndlg('Wrong location!','!! Wrong !!');
            return;
        case 59
            warndlg('Wrong location!','!! Wrong !!');
            return;
        case 64
            warndlg('Wrong location!','!! Wrong !!');
            return;
        otherwise
            select_infor.lat = latlon_infor.lat(matching_infor(select_infor.location));
            select_infor.lon = latlon_infor.lon(matching_infor(select_infor.location));
    end
    
    temp2 = get(handles.slider4,'Value');
    zoom_size = fix(temp2);
    
    cla(handles.map);
    axes(handles.map);
    [xx yy M Mcolor] = get_google_map(select_infor.lat,select_infor.lon,'Zoom',zoom_size,...
            'Marker',sprintf('%4f,%4f',select_infor.lat,select_infor.lon),'MapType','roadmap');
    imagesc(xx,yy,M); 
    shading flat; 
    colormap(Mcolor);
    alpha(1);
    
    cla(handles.city_degree);
    axes(handles.city_degree);
    exp_tmp1 = ['city_weather = weather_infor.city',num2str(matching_infor(select_infor.location)), ...
                '((select_infor.day-1)*24+1:select_infor.day*24,5,select_infor.month,9-select_infor.year);'];
    eval(exp_tmp1);

    bar([0:23],transpose(city_weather),'w');
    xlim([0 23]);
    hold on;
    
    plot([0:23],transpose(city_weather),'b');
    xlim([0 23]);
    hold on;
    
    make_avg_line([1:24]) = mean(city_weather);
    avg_graph = plot([0:23],make_avg_line,'r');
    xlim([0 23]);
    
    legend([avg_graph],{'Average'},'Location','Best');
    h = text(1,make_avg_line(1)+0.2,num2str(round(make_avg_line(1)*10)/10));
        
    xlabel('Time');
    ylabel('Degree (¡ÆC)');
    
    compare_city.number = [];
    compare_city.degree = [];
    compare_city.text_pos = [];
    cla(handles.compare_degree);
    axes(handles.compare_degree);
    

    compare_city.number(1) = matching_infor(select_infor.location);
    exp_tmp2 = ['compare_city.degree(1) = weather_infor_avg.city_avg',num2str(compare_city.number), ...
                '(select_infor.day,4,select_infor.month,9-select_infor.year);'];
    eval(exp_tmp2);
    
    Hori = 'HorizontalAlignment';
    right = 'right';
    left = 'left';
    bar([1],[compare_city.degree],'w');
    if (compare_city.degree > 0)
        compare_city.text_pos(1) = 0.1;
        exp_tmp3 = ['h1 = text(1,compare_city.text_pos,city_name.city',num2str(compare_city.number),',Hori,left);'];
        exp_tmp4 = ['h2 = text(0.7,compare_city.degree-0.2,num2str(round(compare_city.degree*10)/10));'];
    else
        compare_city.text_pos(1) = -0.1;
        exp_tmp3 = ['h1 = text(1,compare_city.text_pos,city_name.city',num2str(compare_city.number),',Hori,right);'];
        exp_tmp4 = ['h2 = text(0.7,compare_city.degree+0.2,num2str(round(compare_city.degree*10)/10));'];
    end
    
    eval(exp_tmp3);
    eval(exp_tmp4);
    set(h1,'Rotation',90);
    xlim([0 10]);
    xlabel('City');
    ylabel('Degree (¡ÆC)');
    
    cla(handles.range_degree);
    axes(handles.range_degree);
    
    change_range_Callback(hObject, eventdata, handles)
    
    
    


    % --- Executes on selection change in choice_locate.
function choice_locate_Callback(hObject, eventdata, handles)
    global select_infor;
    select_infor.location = get(handles.choice_locate,'Value');


% --- Executes during object creation, after setting all properties.
function choice_locate_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in choice_year.
function choice_year_Callback(hObject, eventdata, handles)
    global select_infor;

    select_infor.year = get(handles.choice_year,'Value');
    
    list28 = [' 1';' 2';' 3';' 4';' 5';' 6';' 7';' 8';' 9';'10';'11';'12';'13';'14';'15'; ...
              '16';'17';'18';'19';'20';'21';'22';'23';'24';'25';'26';'27';'28'];
    list29 = [' 1';' 2';' 3';' 4';' 5';' 6';' 7';' 8';' 9';'10';'11';'12';'13';'14';'15'; ...
              '16';'17';'18';'19';'20';'21';'22';'23';'24';'25';'26';'27';'28';'29'];
    list30 = [' 1';' 2';' 3';' 4';' 5';' 6';' 7';' 8';' 9';'10';'11';'12';'13';'14';'15'; ...
              '16';'17';'18';'19';'20';'21';'22';'23';'24';'25';'26';'27';'28';'29';'30'];
    list31 = [' 1';' 2';' 3';' 4';' 5';' 6';' 7';' 8';' 9';'10';'11';'12';'13';'14';'15'; ...
              '16';'17';'18';'19';'20';'21';'22';'23';'24';'25';'26';'27';'28';'29';'30';'31'];
    list11 = [' 1';' 2';' 3';' 4';' 5';' 6';' 7';' 8';' 9';'10';'11'];
    list12 = [' 1';' 2';' 3';' 4';' 5';' 6';' 7';' 8';' 9';'10';'11';'12'];
    
    switch(select_infor.year)
        case 1
            handles.choice_day.String = list11;
        otherwise
            handles.choice_day.String = list12;
    end

    switch (select_infor.month)
        case 2
            switch (select_infor.year)
                case 1
                    handles.choice_day.String = list28;
                case 3
                    handles.choice_day.String = list28;
                case 4
                    handles.choice_day.String = list28;
                case 5
                    handles.choice_day.String = list28;
                case 7
                    handles.choice_day.String = list28;
                case 8
                    handles.choice_day.String = list28;
                case 6
                    handles.choice_day.String = list29;
                case 2
                    handles.choice_day.String = list29;
            end
        case 4
            handles.choice_day.String = list30;
        case 6
            handles.choice_day.String = list30;
        case 9
            handles.choice_day.String = list30;
        case 11
            handles.choice_day.String = list30;
        case 1
            handles.choice_day.String = list31;
        case 3
            handles.choice_day.String = list31;
        case 5
            handles.choice_day.String = list31;
        case 7
            handles.choice_day.String = list31;
        case 8
            handles.choice_day.String = list31;
        case 10
            handles.choice_day.String = list31;
        case 12
            handles.choice_day.String = list31;
    end
    
% --- Executes during object creation, after setting all properties.
function choice_year_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in choice_day.
function choice_day_Callback(hObject, eventdata, handles)
    global select_infor;
    select_infor.day = get(handles.choice_day,'Value');

% --- Executes during object creation, after setting all properties.
function choice_day_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in choice_hour.
function choice_hour_Callback(hObject, eventdata, handles)
    global select_infor;
    select_infor.hour = get(handles.choice_hour,'Value');

% --- Executes during object creation, after setting all properties.
function choice_hour_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in choice_month.
function choice_month_Callback(hObject, eventdata, handles)
    global select_infor;
    select_infor.month = get(handles.choice_month,'Value');
    
    list28 = [' 1';' 2';' 3';' 4';' 5';' 6';' 7';' 8';' 9';'10';'11';'12';'13';'14';'15'; ...
              '16';'17';'18';'19';'20';'21';'22';'23';'24';'25';'26';'27';'28'];
    list29 = [' 1';' 2';' 3';' 4';' 5';' 6';' 7';' 8';' 9';'10';'11';'12';'13';'14';'15'; ...
              '16';'17';'18';'19';'20';'21';'22';'23';'24';'25';'26';'27';'28';'29'];
    list30 = [' 1';' 2';' 3';' 4';' 5';' 6';' 7';' 8';' 9';'10';'11';'12';'13';'14';'15'; ...
              '16';'17';'18';'19';'20';'21';'22';'23';'24';'25';'26';'27';'28';'29';'30'];
    list31 = [' 1';' 2';' 3';' 4';' 5';' 6';' 7';' 8';' 9';'10';'11';'12';'13';'14';'15'; ...
              '16';'17';'18';'19';'20';'21';'22';'23';'24';'25';'26';'27';'28';'29';'30';'31'];

    switch (select_infor.month)
        case 2
            switch (select_infor.year)
                case 1
                    handles.choice_day.String = list28;
                case 3
                    handles.choice_day.String = list28;
                case 4
                    handles.choice_day.String = list28;
                case 5
                    handles.choice_day.String = list28;
                case 7
                    handles.choice_day.String = list28;
                case 8
                    handles.choice_day.String = list28;
                case 6
                    handles.choice_day.String = list29;
                case 2
                    handles.choice_day.String = list29;
            end
        case 4
            handles.choice_day.String = list30;
        case 6
            handles.choice_day.String = list30;
        case 9
            handles.choice_day.String = list30;
        case 11
            handles.choice_day.String = list30;
        case 1
            handles.choice_day.String = list31;
        case 3
            handles.choice_day.String = list31;
        case 5
            handles.choice_day.String = list31;
        case 7
            handles.choice_day.String = list31;
        case 8
            handles.choice_day.String = list31;
        case 10
            handles.choice_day.String = list31;
        case 12
            handles.choice_day.String = list31;
    end
    
% --- Executes during object creation, after setting all properties.
function choice_month_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in choice_type.
function choice_type_Callback(hObject, eventdata, handles)
    global select_infor;
    select_infor.type = get(handles.choice_type,'Value');
    if (select_infor.type ~= 1)
        handles.choice_hour.Enable = 'off';
    else
        handles.choice_hour.Enable = 'on';
    end


% --- Executes during object creation, after setting all properties.
function choice_type_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in choice_add_locate.
function choice_add_locate_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function choice_add_locate_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in add_locate.
function add_locate_Callback(hObject, eventdata, handles)
    global compare_city;
    global select_infor;
    global city_name;
    global matching_infor;
    global weather_infor_avg;
    
    
    
    add_location = get(handles.choice_add_locate,'Value');
    temp_size = size(compare_city.number);
    city_size = temp_size(2) + 1;
    
    switch add_location
        case 10
            warndlg('Wrong location!','!! Wrong !!');
            return;
        case 24
            warndlg('Wrong location!','!! Wrong !!');
            return;
        case 36
            warndlg('Wrong location!','!! Wrong !!');
            return;
        case 59
            warndlg('Wrong location!','!! Wrong !!');
            return;
        case 64
            warndlg('Wrong location!','!! Wrong !!');
            return;
    end
    
    if (temp_size(2) == 10)
        warndlg('Up to 10','!! Wrong !!')
        return;
    end
        
    for i = 1:temp_size(2)
        if( compare_city.number(i) == matching_infor(add_location))
            warndlg('You select same city','!! Wrong !!')
            return;
        end
    end

    cla(handles.compare_degree);
    axes(handles.compare_degree);
    compare_city.number(city_size) = matching_infor(add_location);
    exp_tmp2 = ['compare_city.degree(city_size) = weather_infor_avg.city_avg',num2str(compare_city.number(city_size)), ...
                '(select_infor.day,4,select_infor.month,9-select_infor.year);'];
    eval(exp_tmp2);
    
    
    Hori = 'HorizontalAlignment';
    right = 'right';
    left = 'left';

    bar([1:city_size],[compare_city.degree],'w');
    
    if (compare_city.degree(city_size) > 0)
        compare_city.text_pos(city_size) = 0.1;
    else
        compare_city.text_pos(city_size) = -0.1;
        
    end
        
    for i = 1: city_size
        if(compare_city.text_pos(i) == 0.1);
            exp_tmp3 = ['h1 = text(i,compare_city.text_pos(i),city_name.city',num2str(compare_city.number(i)),',Hori,left);'];
            exp_tmp4 = ['h2 = text(i-0.3,compare_city.degree(i)-0.2,num2str(round(compare_city.degree(i)*10)/10));'];
        else
            exp_tmp3 = ['h1 = text(i,compare_city.text_pos(i),city_name.city',num2str(compare_city.number(i)),',Hori,right);'];
            exp_tmp4 = ['h2 = text(i-0.3,compare_city.degree(i)+0.2,num2str(round(compare_city.degree(i)*10)/10));'];
        end
        eval(exp_tmp3);
        eval(exp_tmp4);
        set(h1,'Rotation',90);
        hold on;
    end
    
    xlim([0 10]);
    xlabel('City');
    ylabel('Degree (¡ÆC)');
    


% --- Executes on button press in initial_locate.
function initial_locate_Callback(hObject, eventdata, handles)
    global compare_city;
    global select_infor;
    global city_name;
    global matching_infor;
    global weather_infor_avg;

    compare_city.number = [];
    compare_city.degree = [];
    compare_city.text_pos = [];
    
    cla(handles.compare_degree);
    axes(handles.compare_degree);
    

    compare_city.number(1) = matching_infor(select_infor.location);
    exp_tmp2 = ['compare_city.degree(1) = weather_infor_avg.city_avg',num2str(compare_city.number), ...
                '(select_infor.day,4,select_infor.month,9-select_infor.year);'];
    eval(exp_tmp2);
    
    Hori = 'HorizontalAlignment';
    right = 'right';
    left = 'left';
    bar([1],[compare_city.degree],'w');
    if (compare_city.degree > 0)
        compare_city.text_pos(1) = 0.1;
        exp_tmp3 = ['h1 = text(1,compare_city.text_pos,city_name.city',num2str(compare_city.number),',Hori,left);'];
        exp_tmp4 = ['h2 = text(0.7,compare_city.degree-0.2,num2str(round(compare_city.degree*10)/10));'];
    else
        compare_city.text_pos(1) = -0.1;
        exp_tmp3 = ['h1 = text(1,compare_city.text_pos,city_name.city',num2str(compare_city.number),',Hori,right);'];
        exp_tmp4 = ['h2 = text(0.7,compare_city.degree+0.2,num2str(round(compare_city.degree*10)/10));'];
    end
    
    eval(exp_tmp3);
    eval(exp_tmp4);
    set(h1,'Rotation',90);
    xlim([0 10]);
    xlabel('City');
    ylabel('Degree (¡ÆC)');


% --- Executes on slider movement.
function choice_range_Callback(hObject, eventdata, handles)
    global range;
    global select_infor;
    global matching_infor;
    global weather_infor_avg;
    
    
    temp2 = get(handles.choice_range,'Value');
    range_pos = fix(temp2);
    year = fix(range_pos / 12)+1;
    month = rem(range_pos,12);
    
    if(month == 0)
        month = 12;
    end
    
    city_num = matching_infor(select_infor.location);

    long_weather = zeros(range*31,4);

    left = range;
    k=0;
    exp_tmp1 = ['long_weather(k,:) = weather_infor_avg.city_avg',num2str(city_num),'(iii,:,ii,year);'];
    exp_tmp2 = ['check_end = (weather_infor_avg.city_avg',num2str(city_num),'(iii+1,1,ii,year) == 0);'];

    if(left + month > 13)
        while (left + month > 13)
            for ii = month:12
                iii = 1;
                while(1)
                    k = k+1;
                    eval(exp_tmp1);
                    if (iii == 31)
                        break;
                    else
                        eval(exp_tmp2);
                        if (check_end)
                            break;
                        else
                            iii = iii+1;
                        end
                    end
                end
            end
            year = year+1;
            left = left-(12-month+1);
            month = 1;
        end
        if (left >=1);
            for ii = month:left+month-1
                iii = 1;
                while(1)
                    k = k+1;
                    eval(exp_tmp1);
                    if (iii == 31)
                        break;
                    else
                        eval(exp_tmp2);
                        if (check_end)
                            break;
                        else
                            iii = iii+1;
                        end
                    end
                end
            end
        end
    else
        if (left >=1);
            for ii = month:left+month-1
                iii = 1;
                while(1)
                    k = k+1;
                    eval(exp_tmp1);
                    if (iii == 31)
                        break;
                    else
                        eval(exp_tmp2);
                        if (check_end)
                            break;
                        else
                            iii = iii+1;
                        end
                    end
                end
            end
        end
    end
    
    cla(handles.range_degree);
    axes(handles.range_degree);
    plot([1:k],long_weather([1:k],4));
    hold on;
    bar([1:k],long_weather([1:k],4),'w');
    
    year = fix(range_pos / 12)+1;
    month = rem(range_pos,12);
    
    switch (range)
        case 1
            xlim([0 35]);
            set(gca,'xtick',[0 5 10 15 20 25 30 35])
            set(gca,'xticklabel',char(sprintf('%d.%d.%d',year+2009,month,0), sprintf('%d.%d.%d',year+2009,month,5),...
            sprintf('%d.%d.%d',year+2009,month,10), sprintf('%d.%d.%d',year+2009,month,15),sprintf('%d.%d.%d',year+2009,month,20), ...
            sprintf('%d.%d.%d',year+2009,month,25),sprintf('%d.%d.%d',year+2009,month,30),sprintf('%d.%d.%d',year+2009,month,35)));
        case 3
            xlim([0 100]);
            set(gca,'xtick',[0 10 20 30 40 50 60 70 80 90 100])
            if (month == 11)
                year1 = [year+2009 year+2009 year+2010];
                month1 = [11 12 1];
            elseif (month == 12)
                year1 = [year+2009 year+2010 year+2010];
                month1 = [12 1 2];
            else
                year1 = [year+2009 year+2009 year+2009];
                month1 = [month month+1 month+2];
            end;
            set(gca,'xticklabel',char(sprintf('%d.%d',year1(1),month1(1)), sprintf('%d.%d',year1(1),month1(1)),...
            sprintf('%d.%d',year1(1),month1(1)), sprintf('%d.%d',year1(2),month1(2)),sprintf('%d.%d',year1(2),month1(2)), ...
            sprintf('%d.%d',year1(2),month1(2)),sprintf('%d.%d',year1(3),month1(3)),sprintf('%d.%d',year1(3),month1(3)), ...
            sprintf('%d.%d',year1(3),month1(3)),sprintf('%d.%d',year1(3),month1(3))));
        case 6
            xlim([0 200]);
            set(gca,'xtick',[0 20 40 60 80 100 120 140 160 180 200])
            if (month == 8)
                year1 = [year+2009 year+2009 year+2009 year+2009 year+2009 year+2010];
                month1 = [8 9 10 11 12 1];
            elseif (month == 9)
                year1 = [year+2009 year+2009 year+2009 year+2009 year+2010 year+2010];
                month1 = [9 10 11 12 1 2];
            elseif (month == 10)
                year1 = [year+2009 year+2009 year+2009 year+2010 year+2010 year+2010];
                month1 = [10 11 12 1 2 3];
            elseif (month == 11)
                year1 = [year+2009 year+2009 year+2010 year+2010 year+2010 year+2010];
                month1 = [11 12 1 2 3 4];
            elseif (month == 12)
                year1 = [year+2009 year+2010 year+2010 year+2010 year+2010 year+2010];
                month1 = [12 1 2 3 4 5];
            else
                year1 = [year+2009 year+2009 year+2009 year+2009 year+2009 year+2009];
                month1 = [month month+1 month+2 month+3 month+4 month+5];
            end;
            set(gca,'xticklabel',char(sprintf('%d.%d',year1(1),month1(1)), sprintf('%d.%d',year1(1),month1(1)),...
            sprintf('%d.%d',year1(2),month1(2)), sprintf('%d.%d',year1(3),month1(3)),sprintf('%d.%d',year1(3),month1(3)), ...
            sprintf('%d.%d',year1(4),month1(4)),sprintf('%d.%d',year1(5),month1(5)),sprintf('%d.%d',year1(5),month1(5)), ...
            sprintf('%d.%d',year1(6),month1(6)),sprintf('%d.%d',year1(6),month1(6))));
        case 12
            xlim([0 400]);
            set(gca,'xtick',[0 50 100 150 200 250 300 350 400])
            year1 = zeros(1,12);
            month1 = zeros(1,12);
            for i=1:12
                for ii=1:12
                    if (ii+i >13)
                        year1(ii) = year+2010;
                        month1(ii) = ii+i-13;
                    else
                        year1(ii) = year+2009;
                        month1(ii) = ii;
                    end
                end
            end
            set(gca,'xticklabel',char(sprintf('%d.%d',year1(1),month1(1)), sprintf('%d.%d',year1(2),month1(2)),...
            sprintf('%d.%d',year1(4),month1(4)), sprintf('%d.%d',year1(6),month1(6)),sprintf('%d.%d',year1(7),month1(7)), ...
            sprintf('%d.%d',year1(9),month1(9)),sprintf('%d.%d',year1(11),month1(11)),sprintf('%d.%d',year1(12),month1(12)), ...
            sprintf('%d.%d',year1(12),month1(12))));
        case 24
            xlim([0 800]);
            set(gca,'xtick',[0 100 200 300 400 500 600 700 800])
            year1 = zeros(1,24);
            month1 = zeros(1,24);
            for i=1:12
                for ii=1:24
                    if (ii+i > 26)
                        year1(ii) = year+2011;
                        month1(ii) = ii+i-26;
                    elseif (ii+i >13)
                        year1(ii) = year+2010;
                        month1(ii) = ii+i-13;
                    else
                        year1(ii) = year+2009;
                        month1(ii) = ii;
                    end
                end
            end
            set(gca,'xticklabel',char(sprintf('%d.%d',year1(1),month1(1)), sprintf('%d.%d',year1(4),month1(4)),...
            sprintf('%d.%d',year1(7),month1(7)), sprintf('%d.%d',year1(11),month1(11)),sprintf('%d.%d',year1(14),month1(14)), ...
            sprintf('%d.%d',year1(17),month1(17)),sprintf('%d.%d',year1(21),month1(21)),sprintf('%d.%d',year1(24),month1(24)), ...
            sprintf('%d.%d',year1(24),month1(24))));
        case 36
            xlim([0 1200]);
            set(gca,'xtick',[0 200 400 600 800 1000 1200])
            year1 = zeros(1,36);
            month1 = zeros(1,36);
            for i=1:12
                for ii=1:36
                    if (ii+i > 39)
                        year1(ii) = year+2012;
                        month1(ii) = ii+i-39;
                    elseif (ii+i > 26)
                        year1(ii) = year+2011;
                        month1(ii) = ii+i-26;
                    elseif (ii+i >13)
                        year1(ii) = year+2010;
                        month1(ii) = ii+i-13;
                    else
                        year1(ii) = year+2009;
                        month1(ii) = ii;
                    end
                end
            end
            set(gca,'xticklabel',char(sprintf('%d.%d',year1(1),month1(1)), sprintf('%d.%d',year1(7),month1(7)),...
            sprintf('%d.%d',year1(14),month1(14)), sprintf('%d.%d',year1(21),month1(21)),sprintf('%d.%d',year1(27),month1(27)), ...
            sprintf('%d.%d',year1(34),month1(34)),sprintf('%d.%d',year1(36),month1(36))));
    end
    

% --- Executes during object creation, after setting all properties.
function choice_range_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
    global latlon_infor;
    global select_infor;
    global zoom_size;

    temp2 = get(handles.slider4,'Value');
    zoom_size = fix(temp2);

    axes(handles.map);
    [xx yy M Mcolor] = get_google_map(select_infor.lat,select_infor.lon,'Zoom',zoom_size, ...
                    'Marker',sprintf('%4f,%4f',select_infor.lat,select_infor.lon),'MapType','roadmap'); 
    imagesc(xx,yy,M); 
    shading flat;
    colormap(Mcolor);


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


% --- Executes on button press in change_range.
function change_range_Callback(hObject, eventdata, handles)
    global range;

    range = 0;
    if(get(handles.month1,'Value'))
        range = 1;
    elseif(get(handles.month3,'Value'))
        range = 3;
    elseif(get(handles.month6,'Value'))
        range = 6;
    elseif(get(handles.month12,'Value'))
        range = 12;
    elseif(get(handles.month24,'Value'))
        range = 24;
    elseif(get(handles.month36,'Value'))
        range = 36;
    end
    
    handles.choice_range.Max = 95-range;
    handles.choice_range.Value = 95-range;
    
    choice_range_Callback(hObject, eventdata, handles);
