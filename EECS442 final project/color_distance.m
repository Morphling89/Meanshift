function distance=color_distance(img,i,j,i2,j2)
 distance=(img(i,j,1)-img(i2,j2,1))^2+(img(i,j,2)-img(i2,j2,2))^2+(img(i,j,3)-img(i2,j2,3))^2;
end