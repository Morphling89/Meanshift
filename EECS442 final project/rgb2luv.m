function [ luvim ] = rgb2luv( im )

%  XYZ
if size(im,3) ~= 3
    error('im must have three color channels');
end
if ~isa(im,'float')
    im = im2single(im);
end
if (max(im(:)) > 1)
    im = im./255;
end

XYZ = [.4125 .3576 .1804; .2125 .7154 .0721; .0193 .1192 .9502];

% if (max(rgbim(:)) > 1)
%     im = rgbim./255;
% end
% 
% XYZ = [0.412453 0.35758 0.180423; 0.212671 0.71516 0.072169; 0.019334 0.119193 0.950227];

[h,w,~]= size(im);
imsiz = size(im);
im = permute(im,[3 1 2]);
im = reshape(im,[3 prod(imsiz(1:2))]);
xyz = reshape((XYZ*im)',imsiz);
% tempsize=h*w;
% rgb = permute(im,[3 1 2]);
% rgb= reshape(rgb,[3 tempsize]);% R;G;B vectors
% xyz = XYZ * rgb;
% xyz = reshape(xyz',size(im)); %convert to XYZ
x = xyz(:,:,1);
y = xyz(:,:,2);
z = xyz(:,:,3);

Lt = 0.008856;
Un = 0.19784977571475;
Vn = 0.46834507665248;


l = y;
l(y>Lt) = 116.*(y(y>Lt).^(1/3)) - 16;
l(y<=Lt) = 903.3*y(y<=Lt);

constant = x + 15 * y + 3 * z;
upr = 4+zeros(h,w);
vpr = (9/15)+zeros(h,w);
upr(constant~=0) = 4*x(constant~=0)./constant(constant~=0);
vpr(constant~=0) = 9*y(constant~=0)./constant(constant~=0);

u = 13 * l .* (upr - Un);
v = 13 * l .* (vpr - Vn);

luvim = cat(3,l,u,v);

