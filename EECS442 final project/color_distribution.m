%-------------------------------------
function cd = color_distribution(imPatch, Nbins)

%This kind of method below is slower (but not much), because we do loop for each pixel
b = floor(256/Nbins);
center = size(imPatch)/2;
[row, col] = size(imPatch);
longest_distance = sqrt((row-center(1))^2+(col-center(1))^2);

h=zeros(Nbins,1);
for  i=1:row
    for j=1:col
        my_bin = floor(imPatch(i,j)/b) + 1;
        if(my_bin>8)
            my_bin=8;
        end
        distance = sqrt((i-center(1))^2+(j-center(2))^2);
        normalized_distance = distance/longest_distance;
        k=(2/pi)*(1-normalized_distance^2);
        h(my_bin, 1) = h(my_bin,1) + k;
    end
end

cd = h/sum(h);

