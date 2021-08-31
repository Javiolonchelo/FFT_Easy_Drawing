%% Preámbulo
clear all
clc
close all force

% Constantes
f       = 440;
T       = 1/f;
fs      = 2000;
Ts      = 1/fs;
L       = 1024;

%% Representación en el tiempo de un tono puro.
figure
t = 0:Ts/10:3*T;
y = cos(f*2*pi*t);
plot(t,y)
title('Representación en el tiempo de un tono puro')
xlabel('Tiempo (s)'); ylabel('Amplitud');
legend('$$y(t) = \cos (440 \cdot 2\pi t)$$', 'interpreter', 'latex')
xlim([0, 3*T]); ylim([-1.15, 1.35])

print('FormulasAndImages/001','-dpng')

%% Representación en frecuencia de un tono puro.
figure
t = 0:Ts:1;
y = cos(f*2*pi*t);
Y = fft(y,L);
Y = Y(1:L/2)/Ts;
eje = linspace(0, fs/2, L/2);
freqs = [eje; abs(Y)];
plot(freqs(1,:), freqs(2,:));
[maximum, ind] = max(abs(Y));
text(freqs(1,ind) + freqs(1,ind)/20, freqs(2,ind) - freqs(2,ind)/20, '440 Hz');
xlim([0 fs/2]); ylim([0, maximum*1.2]);
title('Representación en frecuencia de un tono puro');
xlabel('Frecuencia (Hz)'); ylabel('Amplitud');

print('FormulasAndImages/002','-dpng')