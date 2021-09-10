function startMenu()

fig_inicio = uifigure('Position', ([810 390 320 90]));

% Texto
lbl = uilabel(fig_inicio, 'Position', [20 50 300 30], ...
    'Text', '¡Bienvenido! Escoge el método que desees aplicar.');
lbl.WordWrap = 'on';

% Botones
btn_details = uibutton(fig_inicio, 'Text', 'Detalles', ...
    'Position', [20, 15, 75, 22], ...
    'ButtonPushedFcn', @(btn, event) btn_details_irq(fig_inicio));
uibutton(fig_inicio, 'Text', 'Contorno', ...
    'Position', [110, 15, 75, 22], ...
    'ButtonPushedFcn', @(btn, event) btn_contour_irq(fig_inicio));
uibutton(fig_inicio, 'Text', 'Salir', ...
    'Position', [220, 15, 75, 22], ...
    'ButtonPushedFcn', @(btn, event) btn_exit_irq(fig_inicio));

btn_details.Editable = 'off';
btn_details.Enable   = 'off';

% Waiting...
waitfor(fig_inicio)

end

function btn_details_irq(fig)
global state
state = 'DETAILS';
close(fig);
end

function btn_contour_irq(fig)
global state
state = 'CONTOUR';
close(fig);
end

function btn_exit_irq(fig)
close(fig);
end
