function showImages(fig)
global left right aux0 aux1 aux2 aux3 aux4
right = aux0 | aux1 | aux2 | aux3 | aux4;
right = imfill(right, 'holes');
clf(fig)
subplot(121)
imshow(left)
title('Imagen original')
subplot(122)
imshow(right)
title('Imagen rellena')
end