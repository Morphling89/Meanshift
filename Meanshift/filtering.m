function [ filtered_im,imluv ] = filtering( image,hr,hs)
%FILTERING Summary of this function goes here
%   Detailed explanation goes here
    %%%%%%parameters%%%%%%%%%
    spatial_radius=hs;
    color_radius = hr;

    [h,w,n]=size(image);
    imlab = rgb2lab(image);
    
    
%     L2 = L2*100/255;
% 	U2 = U2-128;
% 	V2 = V2-128;

    %imluv = rgb2luv(image);
    imluv=rgb2luv(image);
%     l=256/100.*l;
%     u=256/354.*(u+134);
%     v=256/262.*(v+140);
    
    for i=1:h
		for j=1:w
            ic=i;
            jc=j;
            l=imluv(i,j,1);
            u=imluv(i,j,2); 
            v=imluv(i,j,3);
            for iters=1:100
			
				icOld = ic;
				jcOld = jc;
				LOld = l;
				UOld = u;
				VOld = v;

				mi = 0;
				mj = 0;
				mL = 0;
				mU = 0;
				mV = 0;
				num=0;
				i2from = max(1,i-spatial_radius); 
                i2to = min(h, i+spatial_radius);
				j2from = max(1,j-spatial_radius); 
                j2to = min(w, j+spatial_radius);
				for i2=i2from: i2to
					for  j2=j2from: j2to
						l2=imluv(i2,j2,1);
                        u2=imluv(i2,j2,2);
                        v2=imluv(i2,j2,3);
                        dL = l2 - l;
						dU = u2 - u;
						dV = v2 - v;
						if (dL*dL+dU*dU+dV*dV <= color_radius^2) 
							mi = mi+i2;
							mj =mj + j2;
							mL =mL + l2;
							mU =mU + u2;
							mV =mV + v2;
							num=num+1;
                        end
                    end
                end
                num_ = 1/num;
				l = mL*num_;
				u = mU*num_;
				v = mV*num_;
				ic = floor(mi*num_+0.5);
				jc = floor (mj*num_+0.5);
				di = ic-icOld;
				dj = jc-jcOld;
				dL = l-LOld;
				dU = u-UOld;
				dV = v-VOld;

				shift = di*di+dj*dj+dL*dL+dU*dU+dV*dV ;
                if shift<3
                   break;
                end
            end
            
						
		imluv(i,j,1)=l;
        imluv(i,j,2)=u;
        imluv(i,j,3)=v;
        end
    end
filtered_im = luv2rgb( imluv)    ;
                    
% imshow(filtered_im);
% title('filtered image');
end

