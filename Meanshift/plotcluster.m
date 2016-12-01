function  plotcluster( mode,regionCount,labels,im,plotorigin,dotsize,word )
%PLOTCLUSTER Summary of this function goes here
%   Detailed explanation goes here



temppixel=zeros(1,1,3);
for i=1:regionCount
    temppixel(1,1,1)=mode(3*i-3+1);
    temppixel(1,1,2)=mode(3*i-3+2);
    temppixel(1,1,3)=mode(3*i-3+3);
    rgbcolor=luv2rgb(temppixel);
    rancolor(1,i)=rgbcolor(1,1,1);
    rancolor(2,i)=rgbcolor(1,1,2);
    rancolor(3,i)=rgbcolor(1,1,3);
    
    
end

for i=1:size(im,1)
    for j=1:size(im,2) 
        for k=1:size(im,3)
            imcluster(i,j,k)=rancolor(k,labels(i,j)); %label's rand color
            imluv2(i,j,k)=mode(3*labels(i,j)-3+k);
        end
    end
end

%%%%%%%%%original feature space
if plotorigin
    imreal=rgb2luv(im);
    L=imreal(:,:,1);
    L=L(:);
    U=imreal(:,:,2);
    U=U(:);
    V=imreal(:,:,3);
    V=V(:);

    r=imcluster(:,:,1);
    rbg(:,1)=r(:);
    g=imcluster(:,:,2);
    rbg(:,2)=g(:);
    b=imcluster(:,:,3);
    rbg(:,3)=b(:);

    figure();
    
    scatter3(L,U,V,1,rbg);
    xlim([0 100]);
    ylim([-60 150]);
    zlim([-70 70]);
    xlabel('L'); % x-axis label
    ylabel('U'); % y-axis label
    zlabel('V');
end
%%%%%%%%%%%%%%%%%%%%




%%%%for LUV%%%%
imrgb=luv2rgb(imluv2);  %%%%%rgb image of segmented image 

%%%% for LAB%%%%%%
%imrgb=lab2rgb(imluv2);

figure1=figure;
imshow(imrgb);
title(word)
set(gca,'position',[0 0 1 1],'units','normalized');
%
if( isa(word,'numeric'))
    if ~exist('CCseg', 'dir')
     mkdir('CCseg');
    end
    saveas(figure1,  [pwd '/CCseg/', num2str(word),'.jpg']);
else 
    saveas(figure1,  [word,'.jpg']);     

for i=1:regionCount
    for k=1:3
    clusterpoint(i,k)=mode(3*i-3+k);
    end
end
    
LC=clusterpoint(:,1);
UC=clusterpoint(:,2);
VC=clusterpoint(:,3);
rgb1=rancolor';

figure();
scatter3(LC',UC',VC',dotsize,rgb1,'filled');
xlim([0 100]);
ylim([-60 150]);
zlim([-70 70]);

%%%%%LUV%%%%%%%
 xlabel('L'); % x-axis label
 ylabel('U'); % y-axis label
 zlabel('V');

%%%%LAB%%%%%%
% xlabel('L'); % x-axis label
% ylabel('A'); % y-axis label
% zlabel('B');




end

