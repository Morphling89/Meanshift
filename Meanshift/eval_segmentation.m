  clear all 
  close all
  clc
     
im=imread('test3.jpg');
%set the parameters%%%
hr1=10;
hr2=10;
hs=10;
mergethres=2;
prunethres=30;

%%%% filtering %%%%%%
[ filtered_im,imluv ] = filtering( im,hr1,hs);

%%%%%%% clustering %%%%%%%%%%
[mode,regionCount,modepointsCounts,labels]=imagecluster(im,imluv,hr2);
plotcluster( mode,regionCount,labels,im,0,5,'aftercluster');
%%%%%%%% merge clusters %%%%%%%%%%%
[newmode,newregionCount,newmodePointCounts,newlabels]=unionfind(mode,regionCount,modepointsCounts,labels,mergethres); % for merging

plotcluster( newmode,newregionCount,newlabels,im,0,5,'afterunion' );
% %%%%%%%% prune small cluster %%%%%%%%%%%
[newmode2,newregionCount2,newmodePointCounts2,newlabels2]=minregion(newmode,newregionCount,newmodePointCounts,newlabels,prunethres);%for pruning
plotcluster( newmode2,newregionCount2,newlabels2,im,0,10,'afterpruning' );




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
