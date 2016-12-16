function [ rgbim] = luv2rgb( luvim )

if size(luvim,3) ~= 3
    error('not 3 channels');
end
if ~isa(luvim,'float')
    luvim = im2single(luvim);
end
imsiz = size(luvim);
[h,w,~]= size(luvim);
RGB = [ 3.2405, -1.5371, -0.4985 ; -0.9693,  1.8760,  0.0416 ; 0.0556, -0.2040,  1.0573 ];
Yn = 1.00000;
U_p = 0.19784977571475;
V_p = 0.46834507665248;
l = luvim(:,:,1);
u = luvim(:,:,2)./(13*l)+U_p;
v = luvim(:,:,3)./(13*l)+V_p;

y = Yn*l./903.3;
y(l>.8) = (l(l>.8)+16)/116;
y(l>.8) = Yn*(y(l>.8)).^3;
x = 9*u.*y./(4*v);
z = (12-3*u-20*v).*y./(4*v);

rgbim = RGB*reshape(permute(cat(3, x, y, z),[3 1 2]),[3 prod(imsiz(1:2))]);
rgbim = reshape(rgbim',imsiz);

zr = find(l < .1);
rgbim([zr zr+prod(imsiz(1:2)) zr+2*prod(imsiz(1:2))]) = 0;
rgbim = min(rgbim,1);
rgbim = max(rgbim,0);

end

