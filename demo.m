%%
% When using the whole or part of this code, please cite the following paper:
% Q. Liu, X.P. Li, "Efficient Low-Rank Matrix Factorization based on l_{1,\epsilon}-norm for Online Background Subtraction", 
% IEEE Transactions on Circuits and Systems for Video Technology, 2021.

clear
close all hidden
%% Select dataset
items = ["car", "crossroad","pets","people"];
item = items(2);
%% data preparation
video = [];
dir = pwd;
if item == "car"
    pic = 255*im2double(imread (strcat(dir,'\data\Car\1.bmp')));
    wid = floor(1*size(pic,2));
    hei = floor(1*size(pic,1));
    virtual_camera_speed = 10; % the camera moves one pixel per x frames.
    frame_cnt=0;
    frame_begin = 1;
    frame_len = 98;
    for fold_iter = 1 : 1
        fold_dir = strcat(dir,'\data\Car\');
        for file_iter = frame_begin: frame_begin+frame_len
            pic = 255*im2double(imread ([fold_dir num2str(file_iter,'%d') '.bmp']));
            virtual_camera_start = 0 + 1;
            virtual_camera_end = virtual_camera_start + wid - 1;
            frame_cnt = frame_cnt + 1;
            temp = pic(1:hei, virtual_camera_start:virtual_camera_end);
            video = [video reshape(temp', [], 1)];
        end
    end
elseif item == "people"
    pic = 255*im2double(imread (strcat(dir,'\data\People\in000261.jpg')));
    wid = floor(1*size(pic,2));
    hei = floor(1*size(pic,1));
    virtual_camera_speed = 10; % the camera moves one pixel per x frames.
    frame_cnt=0;
    frame_begin = 261;
    frame_len = 199;
    for fold_iter = 1 : 1
        fold_dir = strcat(dir,'\data\People\');
        for file_iter = frame_begin: 2 : frame_begin+frame_len
            pic = 255*im2double(imread ([fold_dir 'in000' num2str(file_iter,'%d') '.jpg']));
            virtual_camera_start = 100+1;
            virtual_camera_end = 320;
            frame_cnt = frame_cnt + 1;
            temp = pic(1:hei-24, virtual_camera_start:virtual_camera_end);
            video = [video reshape(temp', [], 1)];
        end
    end
elseif item == "crossroad"
    pic = 255*im2double(imread (strcat(dir,'\data\Crossroad\in000001.jpg')));
    wid = floor(1*size(pic,2));
    hei = floor(0.5*size(pic,1));
    virtual_camera_speed = 10; % the camera moves one pixel per x frames.
    frame_cnt=0;
    frame_begin = 1;
    frame_len = 99;
    for fold_iter = 1 : 1
        fold_dir = strcat(dir,'\data\Crossroad\');
        for file_iter = frame_begin: 1 : frame_begin+frame_len
            pic = 255*im2double(imread ([fold_dir 'in' num2str(file_iter,'%06d') '.jpg']));
            virtual_camera_start = 400+1;
            virtual_camera_end = 600;
            frame_cnt = frame_cnt + 1;
            temp = pic(hei-24: 2*hei, virtual_camera_start:virtual_camera_end);
            video = [video reshape(temp', [], 1)];
        end
    end
elseif item == "pets"
    pic = 255*im2double(imread (strcat(dir,'\data\PETS\in000001.jpg')));
    wid = floor(1*size(pic,2));
    hei = floor(0.5*size(pic,1));
    virtual_camera_speed = 10; % the camera moves one pixel per x frames.
    frame_cnt=0;
    frame_begin = 1;
    frame_len = 99;
    for fold_iter = 1 : 1
        fold_dir = strcat(dir,'\data\PETS\');
        for file_iter = frame_begin: 1 : frame_begin+frame_len
            pic = 255*im2double(imread ([fold_dir 'in' num2str(file_iter,'%06d') '.jpg']));
            virtual_camera_start = 400+1;
            virtual_camera_end = 600;
            frame_cnt = frame_cnt + 1;
            temp = pic(49: hei, virtual_camera_start:virtual_camera_end);
            video = [video reshape(temp', [], 1)];
        end
    end
end
%% Compute result
rak = 1;
tic
[X] = OBC(video, rak); 
toc
%% Show result
Lhat_cp = X;
Shat_cp = video - X;
hei = size(temp,1);
figure(1);
hold on
for iter= 1:size(X,2)
    img=[];
    temp=reshape((video(:,iter)),[],hei);
    minT=min(video(:,iter));
    maxT=max(video(:,iter));
    temp=(temp-minT)*(1)/(maxT-minT);
    img=[img temp];

    temp=[reshape((Lhat_cp(:,iter)),[],hei)];
    minT=min(Lhat_cp(:,iter));
    maxT=max(Lhat_cp(:,iter));
    temp=(temp-minT)*(1)/(maxT-minT);
    img=[img temp];

    temp=[reshape((Shat_cp(:,iter)),[],hei)];
    minT=min(Shat_cp(:,iter));
    maxT=max(Shat_cp(:,iter));
    temp=(temp-minT)*(1)/(maxT-minT);
    img=[img temp*0.5];

    imshow(img',[]);
    pause(0.05)
end
