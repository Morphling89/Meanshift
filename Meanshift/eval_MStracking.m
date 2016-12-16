clc
clear all
close all
addpath Project;



%%%% read images
imPath = 'cc2'; imExt = 'jpg';

%%%%% load images 
%=======================
% check if directory and files exist
if isdir(imPath) == 0
    error('USER ERROR : The image directory does not exist');
end

filearray = dir([imPath filesep '*.' imExt]); % get all files in the directory
NumImages = size(filearray,1); % get the number of images
if NumImages < 0
    error('No image in the directory');
end

disp('Loading image files from the video sequence, please be patient...');
% Get image parameters
imgname = [imPath filesep filearray(1).name]; % get image name
I = imread(imgname);
VIDEO_WIDTH = size(I,2);
VIDEO_HEIGHT = size(I,1);
ImSeq = zeros(VIDEO_HEIGHT, VIDEO_WIDTH, NumImages);
locations=zeros(4,NumImages);
for i=1:NumImages
    display(i);
    imgname = [imPath filesep filearray(i).name]; % get image name
    if(numel(size(imread(imgname)))==3)
       ImSeq(:,:,i)=rgb2gray(imread(imgname));
       ImSeqrgb(:,:,3*i-2:3*i)=imread(imgname); 
    else
       ImSeq(:,:,i)=imread(imgname); 
    end

end
disp(' ... OK!');

%% 

%%%%% initialize by select a box 
%%%%%%%%%%%%%%%%%%%%%%%%
[patch, rect] = imcrop(ImSeq(:,:,1)./255);

% Get  Parameters
ROI_Center= round([rect(1)+rect(3)/2 , rect(2)+rect(4)/2]); 
ROI_Width = rect(3);
ROI_Height = rect(4);
location(:,1)=[ROI_Center,ROI_Width,ROI_Height];
%  draw a box and show it on the image
rectangle('Position', rect, 'EdgeColor','r','FaceColor','none','Linewidth', 3);

%% mean shift
%=======================

%% color model of the target

% use the center and size of ROI to calculate target object color pdf
imPatch = extract_image_patch_center_size(ImSeq(:,:,1), ROI_Center, ROI_Width, ROI_Height);

Nbins = 8;
TargetModel = color_distribution(imPatch, Nbins);

%%%%%%%%%%%%%%%%% intial meanshift_tracker
figure('name', 'Mean Shift Algorithm', 'units', 'normalized', 'outerposition', [0 0 1 1]);
prev_center = ROI_Center;
xin=floor(ROI_Center(1));
yin=floor(ROI_Center(2));
Widin=floor(ROI_Width/2);
HeiIn=floor(ROI_Height/2);
for n = 2:NumImages
    imgname = [imPath filesep filearray(i).name];
    %get next frame
    I = ImSeq(:,:,n);
    %I=ImSeqrgb(:,:,3*n-2:3*n) ; %to plot color image
    [xi,yi,xout,yout,rho_v]=mean_shift_iter(xin,yin,Widin,HeiIn,I,TargetModel);
    Widout=Widin;
    Heiout=HeiIn;
    display(rho_v);
    new_center=[xout,yout];
    disp(new_center);
    
    subplot(1,1,1); imshow(I, []);
    hold on;
	a=plot(new_center(1), new_center(2) , '+', 'Color', 'r', 'MarkerSize',10);
    rectangle('Position', [xout-Widout,yout-Heiout,2*Widout,2*Heiout], 'EdgeColor','r','FaceColor','none','Linewidth', 3);
%      if( mod(n,1)==0)
%          saveas(a, [num2str(n),'.jpg']);
%      end
    drawnow;
 	xin=xout;
    yin=yout;
end