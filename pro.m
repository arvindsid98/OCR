clc, close all, clear all
c=cd;
dos('%SystemRoot%\system32\mspaint.exe inp.jpg'); %target image to be read
imagen = imread(fullfile(c,'inp.jpg'));
%imagen=imread('New Doc 2_1.jpg');
figure
imshow(imagen);
title('image with noise')
imagen=rgb2gray(imagen);
%figure(10)
%imshow(imagen);
%pause(3)
threshold = graythresh(imagen);
imagen =~im2bw(imagen,threshold);
imagen = bwareaopen(imagen,20);
figure(2);
imshow(~imagen);
title('preprocessed image!');
figure(3);
imshow(~imagen);
title('Segmented image');
[L Ne]=bwlabel(imagen);
propied=regionprops(L,'BoundingBox');
hold on
for n=1:size(propied,1)
  rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end
hold off
pause (2) 
word=[ ];
re=imagen;
fid = fopen('text.txt', 'wt');
load templates
global templates
num_letras=size(templates,2);

figure(4);
while 1
    [fl re]=lines(re);
    imgn=fl;
    %imshow(fl);pause(0.5)        
    [L Ne] = bwlabel(imgn);    
    for n=1:Ne
        [r,c] = find(L==n);
        n1=imgn(min(r):max(r),min(c):max(c));  
        img_r=imresize(n1,[42 24]);
        figure();
        imshow(img_r);pause(0.5)
        letter=read_letter(img_r,num_letras);
        word=[word letter];
    end
    fprintf(fid,'%s\n',word);
    word=[ ];
    if isempty(re)  
        break
    end    
end
fclose(fid);
winopen('text.txt') %output file
clear all