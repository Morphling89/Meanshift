function [nmode,nregionCount,nmodePointCounts,nlabels,Ralist]=unionfind(mode,regionCount,modePointCounts,labels,thres)
%thres=2;
Ralist=1:regionCount;
oldregionCount=regionCount;
for count=0:4
    display(count);
    for i=1:regionCount
        neighbour=i+1;
        while(neighbour<regionCount+1)
            if(((mode(1,3*i-1)-mode(1,3*neighbour-1))^2+(mode(1,3*i-2)-mode(1,3*neighbour-2))^2....
                    +(mode(1,3*i)-mode(1,3*neighbour))^2)<thres^2)
                iCanel=i;
                neighCanel=neighbour;
                while(Ralist(iCanel)~=iCanel)
                    iCanel=Ralist(iCanel);
                end
                while(Ralist(neighCanel)~=neighCanel)
                    neighCanel=Ralist(neighCanel);
                end
                %if(modePointCounts(iCanel)>modePointCounts(neighCanel))
                if(iCanel<neighCanel && modePointCounts(iCanel)>5)
                    Ralist(neighCanel)=iCanel;
                elseif (iCanel>neighCanel && modePointCounts(neighCanel)>5)
                    Ralist(iCanel)=neighCanel;
                end
            end
            neighbour=neighbour+1;
        end
    end
    %regionCount=regionCount-1;
    modePointCounts_buffer=zeros(1,regionCount);
    label_buffer=zeros(1,regionCount);
    mode_buffer=zeros(1,regionCount*3);
    for i=1:regionCount
        iCanel=i;
        while(Ralist(iCanel)~=iCanel)
            iCanel=(Ralist(iCanel));
            
        end
        Ralist(i)=iCanel;
    end
    for i=1:regionCount
        
        label_buffer(i)	= -1;
        mode_buffer(i*3-2) = 0;
        mode_buffer(i*3-1) = 0;
        mode_buffer(i*3) = 0;
        
    end
    for i=1:regionCount
        iCanel=Ralist(i);
        modePointCounts_buffer(iCanel)=modePointCounts_buffer(iCanel)+modePointCounts(i);
        for k=1:3
            mode_buffer(3*iCanel-3+k)=mode_buffer(3*iCanel-3+k)+mode(3*i-3+k)*modePointCounts(i);
        end
        
    end
    label=0;
    for i=1:regionCount
        iCanel=Ralist(i);
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
            labels(i,j)=label_buffer(Ralist(labels(i,j)));
        end
    end
    display('Regioncount after transitive closure is',num2str(regionCount));
    deltaRegionCount=oldregionCount-regionCount;
    oldregionCount=regionCount;
    if (deltaRegionCount>0)
        break;
    end
end
nmode=mode(:,1:3*label);
nregionCount=regionCount;
nmodePointCounts=modePointCounts(:,1:label);
nlabels=labels;


end