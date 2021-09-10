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
        image = prepContour();
        switch state
            case 'CONTOUR_START'
                calcContour(image);
        end        
end
