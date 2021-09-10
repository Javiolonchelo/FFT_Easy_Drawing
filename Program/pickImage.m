function I = pickImage()
global filename
file = ['Images/' uigetfile('Images/*')];
if strcmp(file(end - 2:end), 'png' )
    I = imread(file);
    I = im2gray(I);
elseif strcmp(file(end - 2:end), 'jpg' )
    I = rgb2gray(imread(file));
end
filename = file(1:end - 4);
end