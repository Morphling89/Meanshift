function [nmode,nregionCount,nmodePointCounts,nlabels,RAlist]=minregion(mode,regionCount,modePointCounts,labels, minregion)
%minregion=30; % M can be altered here
loop=1;
minregionCount=0;
    modePointCounts_buffer=zeros(1,regionCount);
    label_buffer=zeros(1,regionCount);
    mode_buffer=zeros(1,regionCount*3);
    distancemat=zeros(regionCount,regionCount);
    RAlist=1:regionCount;
    for i=1:regionCount
        for j=i+1:regionCount
         distancemat(i,j)=((mode(1,3*i-1)-mode(1,3*j-1))^2+(mode(1,3*i-2)-mode(1,3*j-2))^2....
                +(mode(1,3*i)-mode(1,3*j)))^2;
            distancemat(j,i)=distancemat(i,j);
        end
    end
    [mat,idx]=sort(distancemat,'ascend');
    for i=1:regionCount
       
       if(modePointCounts(i)<minregion&&i~=regionCount)
           pruned=0; 
           starti=1;
           while (pruned==0 && starti<=regionCount)
            candidate=idx(starti,i);
            % mat(starti,i)
            if (modePointCounts(candidate)>minregion )
%                 if ( mat(starti,i)>0.5)
%                     break;
%                 else
                    RAlist(i)=candidate;
                    pruned=1;
                    minregionCount=minregionCount+1;
                %end
            else
                starti=starti+1;
            end
           end
       end
    end
        
     for i=1:regionCount
        iCanel=i;
        while(RAlist(iCanel)~=iCanel)
            iCanel=(RAlist(iCanel));
            
        end
        RAlist(i)=iCanel;
    end
    for i=1:regionCount
        
        label_buffer(i)	= -1;
        mode_buffer(i*3-2) = 0;
        mode_buffer(i*3-1) = 0;
        mode_buffer(i*3) = 0;
        
    end
    for i=1:regionCount
        iCanel=RAlist(i);
        modePointCounts_buffer(iCanel)=modePointCounts_buffer(iCanel)+modePointCounts(i);
        for k=1:3
            mode_buffer(3*iCanel-3+k)=mode_buffer(3*iCanel-3+k)+mode(3*i-3+k)*modePointCounts(i);
        end
        
    end
    label=0;
    for i=1:regionCount
        iCanel=RAlist(i);
        if(label_buffer(iCanel)<0)
            label=label+1;
            label_buffer(iCanel)=label;
            
            for k=1:3
                mode(3*label-3+k)=mode_buffer(3*iCanel-3+k)/modePointCounts_buffer(iCanel);
            end
            modePointCounts(label)=modePointCounts_buffer(iCanel);
        end
    end
    regionCount=label;
    for i=1:size(labels,1)
        for j=1:size(labels,2)
            labels(i,j)=label_buffer(RAlist(labels(i,j)));
        end
    end
%     if(minregionCount==0)
%         break;
%     end
%     loop=loop+1;
    display('Regioncount after prune closure is',num2str(loop));
    display('Regioncount after prune closure is',num2str(minregionCount));

display('Regioncount after prune closure is',num2str(regionCount));


nmode=mode;
nregionCount=regionCount;
nmodePointCounts=modePointCounts;
nlabels=labels;


% 
% 
% while(true)
% 
%     
%     RAlist=1:regionCount;
%     minregionCount=0;
%     for i=1:regionCount
%         if(modePointCounts(i)<minregion&&i~=regionCount)
%             minregionCount=minregionCount+1;
%             neighour=i+1;
%             if(neighour==regionCount+1)
%                 neighour=1;
%             end
%             candidate=RAlist(neighour);
%             mini_distance=((mode(1,3*i-1)-mode(1,3*candidate-1))^2+(mode(1,3*i-2)-mode(1,3*candidate-2))^2....
%                 +(mode(1,3*i)-mode(1,3*candidate)))^2;
%             neighour=neighour+1;
%             while(neighour<regionCount+1)
%                 mini_distance2=((mode(1,3*i-1)-mode(1,3*neighour-1))^2+(mode(1,3*i-2)-mode(1,3*neighour-2))^2....
%                     +(mode(1,3*i)-mode(1,3*neighour)))^2;
%                 if(mini_distance2<mini_distance)
%                     mini_distance=mini_distance2;
%                     candidate=RAlist(neighour);
%                 end
%                 neighour=neighour+1;
%             end
%             iCanel=i;
%             neighCanel=candidate;
%             while(RAlist(iCanel)~=iCanel)
%                 iCanel=RAlist(iCanel);
%             end
%             while(RAlist(neighCanel)~=neighCanel)
%                 neighCanel=RAlist(neighCanel);
%             end
%             if(iCanel<neighCanel)
%                 RAlist(neighCanel)=iCanel;
%             else
%                 RAlist(iCanel)=neighCanel;
%             end
%             
%         end
%     end
%     for i=1:regionCount
%         iCanel=i;
%         while(RAlist(iCanel)~=iCanel)
%             iCanel=(RAlist(iCanel));
%             
%         end
%         RAlist(i)=iCanel;
%     end
%     for i=1:regionCount
%         
%         label_buffer(i)	= -1;
%         mode_buffer(i*3-2) = 0;
%         mode_buffer(i*3-1) = 0;
%         mode_buffer(i*3) = 0;
%         
%     end
%     for i=1:regionCount
%         iCanel=RAlist(i);
%         modePointCounts_buffer(iCanel)=modePointCounts_buffer(iCanel)+modePointCounts(i);
%         for k=1:3
%             mode_buffer(3*iCanel-3+k)=mode_buffer(3*iCanel-3+k)+mode(3*i-3+k)*modePointCounts(i);
%         end
%         
%     end
%     label=0;
%     for i=1:regionCount
%         iCanel=RAlist(i);
%         if(label_buffer(iCanel)<0)
%             label=label+1;
%             label_buffer(iCanel)=label;
%             
%             for k=1:3
%                 mode(3*label-3+k)=mode_buffer(3*iCanel-3+k)/modePointCounts_buffer(iCanel);
%             end
%             modePointCounts(label)=modePointCounts_buffer(iCanel);
%         end
%     end
%     regionCount=label;
%     for i=1:size(labels,1)
%         for j=1:size(labels,2)
%             labels(i,j)=label_buffer(RAlist(labels(i,j)));
%         end
%     end
%     if(minregionCount==0)
%         break;
%     end
%     loop=loop+1;
%     display('Regioncount after prune closure is',num2str(loop));
%     display('Regioncount after prune closure is',num2str(minregionCount));
% end
% display('Regioncount after prune closure is',num2str(regionCount));
% 
% 
% nmode=mode;
% nregionCount=regionCount;
% nmodePointCounts=modePointCounts;
% nlabels=labels;
% 


end