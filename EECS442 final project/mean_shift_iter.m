function [xi,yi,xo,yo,rho]=mean_shift_iter(xi,yi,Wx,Hy,I,TargetModel)
    xp=2*Wx+1;
    yp=2*Hy+1;
    PixelNo=floor(xp*yp);
    flag=1;
    Nbins=8;
    MAX_INTERATE_TIMES=20;
    index_weight=zeros(Nbins);
    for i=1:MAX_INTERATE_TIMES
        if(flag==1)
            imPatch = extract_image_patch_center_size(I, [xi,yi], xp, yp);
            ColorModel = color_distribution(imPatch, Nbins);
            rho = compute_bhattacharyya_coefficient(TargetModel, ColorModel);
        else
            rho=rho1;
        end
        w_i=zeros(PixelNo);
        %index_weight = compute_weights_NG(imPatch, TargetModel, ColorModel, Nbins);
        
        for x=1:Nbins
            if(ColorModel(x)>0.00001)
            index_weight(x)=sqrt(TargetModel(x)/ColorModel(x));
            else
                index_weight(x)=0;
            end
            display(index_weight(x));
        end
        x_begin=xi-Wx;
        y_begin=yi-Hy;
        if(x_begin<=0)
            x_begin=1;
        end
        if(y_begin<=0)
            y_begin=1;
        end        
        x_end = xi + Wx;
        y_end = yi + Hy;
        if(x_end>size(I,2))
            x_end=size(I,2);
        end     
        if(y_end>size(I,1))
            y_end=size(I,1);
        end 
        sum_wi=0;
         xo_f=0;
         yo_f=0;
        for y=y_begin:y_end
            for x=x_begin:x_end
                
                indx=floor(I(y,x)/Nbins)+1;
                p_idx=(y-y_begin)*xp+(x-x_begin)+1;
                w_i(p_idx)=index_weight(indx);
                sum_wi=sum_wi+index_weight(indx);
                xo_f=xo_f+x*w_i(p_idx);
                yo_f=yo_f+y*w_i(p_idx);
            end
        end
        
        xo=floor(xo_f/sum_wi+0.5);
        yo=floor(yo_f/sum_wi+0.5);
        imPatch = extract_image_patch_center_size(I, [xo,yo], xp, yp);
        ColorModel = color_distribution(imPatch, Nbins);
        rho1 = compute_bhattacharyya_coefficient(TargetModel, ColorModel);
        
        if ( rho1 < rho )
            xo = floor((xo+xi)/2);
            yo = floor((yo+yi)/2);
            flag = 1;
        else
            flag=0;
        end
        err=abs(xo-xi)+abs(yo-yi);
        if(err<=1)
            rho=rho1;
            break;
        else
            xi=floor(xo);
            yi=floor(yo);
        end

    end
end