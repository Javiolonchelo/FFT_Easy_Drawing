function prepContour()
global state threshold left aux0 aux1 aux2 aux3 aux4 image inverted

inverted = false;
threshold = 127;
state = 0;

image = pickImage();

left = image;
width = length(image(1, :));
height = length(image(:, 1));
right = image > threshold;
right = imfill(right, 'holes');
aux0 = right;
aux1 = zeros(height, width);
aux2 = zeros(height, width);
aux3 = zeros(height, width);
aux4 = zeros(height, width);

fig_contour = figure('Position', ([200 200 1000 500]));
showImages(fig_contour);

%% UI
h = uifigure('Position', ([700 500 550 250]));

% SLIDERS
% threshold
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

clear threshold left aux0 aux1 aux2 aux3 aux4 image inverted
end

%% IRQs

function sld_irq (sld, fig)
global threshold left aux0 inverted
threshold = sld.Value;

if inverted
    aux0 = left < threshold;
else
    aux0 = left > threshold;
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

function btn_start_irq(fig_contour)
global state
state = 'CONTOUR_START';
close(fig_contour)
end

function btn_inverted_irq(fig)
global inverted aux0
inverted = ~inverted;
aux0 = ~aux0;
showImages(fig);
end
