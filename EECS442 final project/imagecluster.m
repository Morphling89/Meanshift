function [mode,regionCount,modepointsCounts,labels]=imagecluster(img,result,hr)
   [imh,imw,n]=size(img);
    regionCount=0;
    modepointsCounts=zeros(1,imh*imw);
    mode=zeros(1,3*imh*imw);
    labels=zeros(imh,imw);
    label=0;
    color_radius2=hr^2;
    for i=1:imh
        for j=1:imw
            labels(i,j)=0;
        end
    end
    
    for i=1:imh
        for j=1:imw
            
            if(labels(i,j)<1)
                label=label+1;
                labels(i,j)=label;
                modepointsCounts(label)=modepointsCounts(label)+1;
                display(label);
                L=result(i,j,1);
                U=result(i,j,2);
                V=result(i,j,3);
                mode(label*3-2)=L;
                mode(label*3-1)=U;
                mode(label*3)=V;
%                 mode(label*3-2)=L*100/255;
%                 mode(label*3-1)=354*U/255-134;
%                 mode(label*3)=256*V/255-140;
                neighStack=CStack;
                neighStack.push([i,j]);
                dxdy={[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]};
                while(~neighStack.isempty())
                    p=neighStack.top();
                    neighStack.pop();
                    for k=1:8
                        i2=p(1,1)+dxdy{k}(1,1);
                        j2=p(1,2)+dxdy{k}(1,2);
                        
                        if(i2>0&&j2>0&&i2<=imh&&j2<=imw&&labels(i2,j2)<1&&color_distance(result,i,j,i2,j2)<color_radius2)
                            labels(i2,j2)=label;
                            neighStack.push([i2,j2]);
                            modepointsCounts(label)=modepointsCounts(label)+1;
                            L=result(i2,j2,1);
                            U=result(i2,j2,2);
                            V=result(i2,j2,3);
                            mode(label*3-2)=L+mode(label*3-2);
                            mode(label*3-1)=mode(label*3-1)+U;
                            mode(label*3)=mode(label*3)+V;
%                     mode(label*3-2)=mode(label*3-2)+L*100/255;
%                     mode(label*3-1)=mode(label*3-1)+354*U/255-134;
%                     mode(label*3)=mode(label*3)+256*V/255-140;                           
                            
                        end
                            
                    end
                end

                mode(label*3-2)=mode(label*3-2)/modepointsCounts(label);
                mode(label*3-1)=mode(label*3-1)/modepointsCounts(label);
                mode(label*3)=mode(label*3)/modepointsCounts(label);
            end
            regionCount=label;
        end
    end
    %mode = mode(mode~=0);
    %modepointsCounts= modepointsCounts( modepointsCounts~=0);
    display('Mean Shift(Connect):',num2str(regionCount));

    
   
end