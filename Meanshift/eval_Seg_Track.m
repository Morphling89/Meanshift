clc
clear all
close all
addpath Project;



%% read images
imPath = 'cc2'; imExt = 'jpg';

%%%%% LOAD THE IMAGES
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

hr1=10;
hr2=10;
hs=10;
mergethres=2;
prunethres=30;

for i=1:NumImages
    display(i);
    imgname = [imPath filesep filearray(i).name]; % get image name
    
       im=imread(imgname);
   
       
    [ filtered_im,imluv ] = filtering( im,hr1,hs);
    [mode,regionCount,modepointsCounts,labels]=imagecluster(im,imluv,hr2);
       
    [newmode,newregionCount,newmodePointCounts,newlabels]=unionfind(mode,regionCount,modepointsCounts,labels,mergethres); % for merging
    [newmode2,newregionCount2,newmodePointCounts2,newlabels2]=minregion(newmode,newregionCount,newmodePointCounts,newlabels,prunethres);%for pruning
    
   for m=1:size(im,1)
    for j=1:size(im,2) 
        for k=1:size(im,3)
            imluv2(m,j,k)=newmode2(3*newlabels2(m,j)-3+k);
        end
    end
   end

    imrgb=luv2rgb(imluv2);  %%%%%rgb image of segmented image 
    
    figure=imshow(imrgb);
    %figure1=figure;
    if ~exist('CCseg', 'dir')
     mkdir('CCseg');
    end
    saveas(figure,  [pwd '/CCseg/', num2str(i),'.jpg']);
end


