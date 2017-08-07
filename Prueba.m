%Variables

photo_Path1='C:\Users\tinaf\OneDrive\Documentos\Departamento\Epithelia3D\Prueba\50epib_2_z008_c002.tif';
nameNew1='C:\Users\tinaf\OneDrive\Documentos\Departamento\Epithelia3D\Prueba\50epib_2_z008_c002_centroid';

photo_Path2='C:\Users\tinaf\OneDrive\Documentos\Departamento\Epithelia3D\Prueba\50epib_2_z009_c002.tif';
nameNew2='C:\Users\tinaf\OneDrive\Documentos\Departamento\Epithelia3D\Prueba\50epib_2_z009_c002_centroid';



[centroids1, pixel1]=Centroid(photo_Path1, nameNew1);
[centroids2, pixel2]=Centroid(photo_Path2, nameNew2);

xPixel1=pixel1(:, 1);
yPixel1=pixel1(:, 2);


xQuery=centroids2(:, 1);
yQuery=centroids2(:, 2);

[k]=boundary(xPixel1,yPixel1);

[in,on] = inpolygon(xQuery,yQuery,xPixel1(k),yPixel1(k));


%in= in | on; Para cuando hago el bucle poner esto para que el contorno
%se cuente como inLayer
   

figure
imshow(photo_Path2);
hold on
plot(xPixel1(k),yPixel1(k),'LineWidth',2) % polygon
axis equal
plot(xPixel1,yPixel1,'w*') % PostPoints 
plot(xQuery(in),yQuery(in),'g+') % points inside
plot(xQuery(~in),yQuery(~in),'bo') % points outside
hold off

numel(xQuery(in))% points inside
numel(xQuery(on))% points lying on the edge
numel(xQuery(~in))% points outside


%  if in==1 & [in_i]~=[in_(i-1)]
%  end

