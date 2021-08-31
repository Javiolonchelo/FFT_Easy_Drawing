function [step, minCoeff, maxCoeff, loop, zoom, CENTERED, videoName, ...
    CREATE_VIDEO] = setParam()
global t_zoom t_videoName state

state = 'CANCEL REPRESENTATION';
videoName = '';

% Creación de una nueva figura
fig = uifigure('Position', ([500 500 450 200]));

% Texto asociado a los parámetros
t_step      = uitextarea(fig, 'Position', [250, 140, 80, 22]);
t_zoom      = uitextarea(fig, 'Position', [250, 110, 80, 22]);
t_minCoeff  = uitextarea(fig, 'Position', [250, 80, 80, 22]);
t_maxCoeff  = uitextarea(fig, 'Position', [250, 50, 80, 22]);
t_loop      = uitextarea(fig, 'Position', [250, 20, 80, 22]);
t_videoName = uitextarea(fig, 'Position', [250, 20, 80, 22]);

t_step.Value      = '0.001';
t_minCoeff.Value  = '45';
t_maxCoeff.Value  = '47';
t_loop.Value      = '2';

t_zoom.Editable       = 'off';
t_zoom.Enable         = 'off';
t_zoom.Value          = '';
t_videoName.Editable  = 'off';
t_videoName.Enable    = 'off';
t_videoName.Value     = '';

% Texto
uilabel(fig, 'Position', [30 100 235 40], 'Text', 'Zoom:');
uilabel(fig, 'Position', [30 130 235 40], 'Text', 'Resolución:');
uilabel(fig, 'Position', [30 70 235 40], 'Text', 'Primer coeficiente representado:');
uilabel(fig, 'Position', [30 40 235 40], 'Text', 'Último coeficiente representado:');
uilabel(fig, 'Position', [30 10 235 40], 'Text', 'Número de vueltas por cada coeficiente:');

% Botones
btn_centered = uibutton(fig, 'state', 'Text', 'Centrado en el pincel', ...
    'Position', [30, 170, 300, 22], ...
    'ValueChangedFcn', @(a, b) btn_centered_irq());
btn_video = uibutton(fig, 'state', 'Text', '¿Generar vídeo?', ...
    'Position', [210, 300, 300, 22], ...
    'ValueChangedFcn', @(a, b) btn_video_irq());
uibutton(fig, 'Text', 'Empezar', 'Position', [350, 20, 75, 22], ...
    'ButtonPushedFcn', @(a, b) btn_start_irq(fig));
uibutton(fig, 'Text', 'Cancelar', 'Position', [350, 45, 75, 22], ...
    'ButtonPushedFcn', @(a, b) btn_cancel_irq(fig));

% Esto no entiendo muy bien por qué ocurre. La ventana UI parece generarse
% de forma paralela a la ejecución del código, de modo que si esperamos a
% que cambie una ventana que no existe con el método 'uiwait()' se
% congelará el programa. Un retraso de 1 segundo parece aliviar el
% problema.
pause(1);

while true
    uiwait(fig);
    switch state
        case 'START REPRESENTATION'
            % Asignación de valores
            step      = str2double(t_step.Value());
            zoom      = str2double(t_zoom.Value());
            minCoeff  = str2double(t_minCoeff.Value());
            maxCoeff  = str2double(t_maxCoeff.Value());
            loop      = str2double(t_loop.Value());
            CENTERED  = ~btn_centered.Value();
            CREATE_VIDEO = btn_video.Value();
            
            close(fig);
            break
            
        case 'CANCEL REPRESENTATION'
            break
    end
end

end

%% IRQs
function btn_centered_irq()
global t_zoom
persistent aux_editable

if isempty(aux_editable)
    aux_editable = false;
end

aux_editable = ~aux_editable;

if aux_editable
    t_zoom.Editable = 'on';
    t_zoom.Enable   = 'on';
    t_zoom.Value    = '5';
else
    t_zoom.Editable = 'off';
    t_zoom.Enable   = 'off';
    t_zoom.Value    = '';
end
end

function btn_video_irq()
global t_videoName
persistent aux_editable

if isempty(aux_editable)
    aux_editable = false;
end

aux_editable = ~aux_editable;

if aux_editable
    t_videoName.Editable = 'on';
    t_videoName.Enable   = 'on';
    t_videoName.Value    = 'Nombre del vídeo';
else
    t_videoName.Editable = 'off';
    t_videoName.Enable   = 'off';
    t_videoName.Value    = '';
end
end

function btn_cancel_irq(fig)
close(fig);
end

function btn_start_irq(fig)
global state
state = 'START REPRESENTATION';
uiresume(fig);
end
