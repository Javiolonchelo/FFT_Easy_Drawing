%% Preamble
clear all
clc
close all force

global STATE TH LEFT RIGHT aux0 aux1 aux2 aux3 aux4 I INVERTED filename

%% Menú de inicio
fig_inicio = uifigure('Position', ([810 390 320 90]));

% TEXT
lbl = uilabel(fig_inicio, 'Position', [20 50 300 30], ...
    'Text', '¡Bienvenido! Escoge el método que desees aplicar.');
lbl.WordWrap = 'on';

% BUTTONS
btn_details = uibutton(fig_inicio, 'Text', 'Detalles', ...
    'Position', [20, 15, 75, 22], ...
    'ButtonPushedFcn', @(btn, event) btn_details_irq(fig_inicio));
btn_contour = uibutton(fig_inicio, 'Text', 'Contorno', ...
    'Position', [110, 15, 75, 22], ...
    'ButtonPushedFcn', @(btn, event) btn_contour_irq(fig_inicio));
btn_exit = uibutton(fig_inicio, 'Text', 'Salir', ...
    'Position', [220, 15, 75, 22], ...
    'ButtonPushedFcn', @(btn, event) btn_exit_irq(fig_inicio));

% Waiting...
waitfor(fig_inicio)

%% Escoger acción principal

switch STATE
    case 'DETAILS'
    case 'CONTOUR'
        INVERTED = false;
        TH = 127;
        STATE = 0;
        
        I = pickImage();
        
        LEFT = I;
        width = length(I(1, :));
        height = length(I(:, 1));
        RIGHT = I > TH;
        RIGHT = imfill(RIGHT, 'holes');
        aux0 = RIGHT;
        aux1 = zeros(height, width);
        aux2 = zeros(height, width);
        aux3 = zeros(height, width);
        aux4 = zeros(height, width);
        
        fig_contour = figure('Position', ([200 200 1000 500]));
        showImages(fig_contour);
        
        %% UI
        h = uifigure('Position', ([700 500 550 250]));
        
        % SLIDERS
        % TH
        sld = uislider(h, 'Position', [15, 45, 200, 3], ...
            'ValueChangingFcn', @(sld, event) sld_irq(event, fig_contour));
        sld.Limits = [0 255];
        sld.Value = 127;
        % White Bars
        sld_1 = uislider(h, 'Position', [200, 200, 300, 3], ...
            'ValueChangingFcn', @(sld, event) sld_1_irq(event, height, fig_contour));
        sld_2 = uislider(h, 'Position', [200, 170, 300, 3], ...
            'ValueChangingFcn', @(sld, event) sld_2_irq(event, height, fig_contour));
        sld_3 = uislider(h, 'Position', [200, 140, 300, 3], ...
            'ValueChangingFcn', @(sld, event) sld_3_irq(event, width, fig_contour));
        sld_4 = uislider(h, 'Position', [200, 110, 300, 3], ...
            'ValueChangingFcn', @(sld, event) sld_4_irq(event, width, fig_contour));
        
        sld_1.Value = 0; sld_1.Limits = [0 100];
        sld_2.Value = 0; sld_2.Limits = [0 100];
        sld_3.Value = 0; sld_3.Limits = [0 100];
        sld_4.Value = 0; sld_4.Limits = [0 100];
        
        % TEXT
        lbl = uilabel(h, 'Position', [245 25 180 30], ...
            'Text', 'La imagen rellena no debe tener huecos de color negro');
        lbl.WordWrap = 'on';
        
        % BUTTONS
        btn_start = uibutton(h, 'Text', 'Empezar', ...
            'Position', [435, 30, 100, 22], ...
            'ButtonPushedFcn', @(btn, event) btn_start_irq(fig_contour));
        btn_inverted = uibutton(h, 'Text', 'Invertir', ...
            'Position', [30, 150, 100, 22], ...
            'ButtonPushedFcn', @(btn, event) btn_inverted_irq(fig_contour));
        
        % Waiting...
        waitfor(fig_contour)
        close(h)
        
        clear TH LEFT aux0 aux1 aux2 aux3 aux4 I INVERTED
        
        % Second Switch Statement
        switch STATE
            case 'CONTOUR_START'
                calcContour(RIGHT)
        end
        
end

%% IRQs

% Sliders

function sld_irq (sld, fig)
global TH LEFT aux0 INVERTED
TH = sld.Value;

if INVERTED
    aux0 = LEFT < TH;
else
    aux0 = LEFT > TH;
end

aux0 = imfill(aux0, 'holes');
showImages(fig);
end

function sld_1_irq(sld, height, fig)
global aux1
resetImages();
aux1(:) = 0;

if (sld.Value ~= height)
    aux1(round(height * (1 - sld.Value / 100)) + 1:height, :) = 1;
end

showImages(fig);
end

function sld_2_irq(sld, height, fig)
global aux2
resetImages();
aux2(:) = 0;

if (sld.Value ~= height)
    aux2(1:round(height * sld.Value / 100), :) = 1;
end

showImages(fig);
end

function sld_3_irq(sld, width, fig)
global aux3
resetImages();
aux3(:) = 0;

if (sld.Value ~= width)
    aux3(:, 1:round(width * sld.Value / 100)) = 1;
end

showImages(fig);
end

function sld_4_irq(sld, width, fig)
global aux4
resetImages();
aux4(:) = 0;

if (sld.Value ~= width)
    aux4(:, round(width * (1 - sld.Value / 100)) + 1:width) = 1;
end

showImages(fig);
end

% Buttons

function btn_details_irq(fig)
global STATE
STATE = 'DETAILS';
close(fig);
end

function btn_contour_irq(fig)
global STATE
STATE = 'CONTOUR';
close(fig);
end

function btn_exit_irq(fig)
close(fig);
end

function btn_start_irq(fig_contour)
global STATE
STATE = 'CONTOUR_START';
close(fig_contour)
end

function btn_inverted_irq(fig)
global INVERTED aux0
INVERTED = ~INVERTED;
aux0 = ~aux0;
showImages(fig);
end

%% Other functions
function showImages(fig)
global LEFT RIGHT aux0 aux1 aux2 aux3 aux4
RIGHT = aux0 | aux1 | aux2 | aux3 | aux4;
RIGHT = imfill(RIGHT, 'holes');
clf(fig)
subplot(121)
imshow(LEFT)
title('Imagen original')
subplot(122)
imshow(RIGHT)
title('Imagen rellena')
end

function resetImages()
global I LEFT RIGHT
LEFT = I .* uint8((I | RIGHT));
end

function I = pickImage()
global filename
file = ['Images/' uigetfile('Images/*')];
if strcmp(file(end - 2:end), 'png' )
    [I,~,~] = imread(file);
    I = rgb2gray(I);
elseif strcmp(file(end - 2:end), 'jpg' )
    I = rgb2gray(imread(file));
end
filename = file(1:end - 4);
end
