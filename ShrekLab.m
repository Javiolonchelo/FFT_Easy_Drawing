%% Preámbulo
clear all
clc
close all force

global state

state = '';

startMenu();

switch state
    case 'DETAILS'
    case 'CONTOUR'
        prepContour();
        switch state
            case 'CONTOUR_START'
                image = prepImageForContour();
                calcContour(image);
        end
        
end
