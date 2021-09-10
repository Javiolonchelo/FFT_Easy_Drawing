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
Len     = 10;

w1      = 7   * pi;
w2      = 3.5 * pi;
w3      = 6   * pi;
w4      = 5   * pi;

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

%% Ejemplo de la gran sala
figure
t = 0:0.001:Len;
eje = linspace(0,Len,length(t));
y = 3*cos(w1*t) + sin(w2*t) + 2*cos(w3*t + pi/4) + 2*sin(w4*t + pi/3);
plot(eje,y)
xlim([0, Len]), ylim([-8, 9])
title('Suma de señales de diferente frecuencia')
xlabel('Tiempo (s)'); ylabel('Amplitud');
legend('$$y(t) = 3\cos (7\pi t) + \sin(3.5\pi t) + 2\cos \left( 6\pi t + \frac{\pi}{4}\right) + 2\sin \left( 5\pi t + \frac{\pi}{3}\right)$$', 'interpreter', 'latex')

t = 0:0.05:Len;
eje = linspace(0,Len,length(t));
y = 3*cos(w1*t) + sin(w2*t) + 2*cos(w3*t + pi/4) + 2*sin(w4*t + pi/3);

print('FormulasAndImages/004','-dpng')

figure
Y = fft(y,L);
Y = Y(1:L/2)/Ts;
eje = linspace(0, 2*0.05*fs/pi, L/2);
freqs = [eje; abs(Y)];
plot(freqs(1,:), freqs(2,:));

r1 = w1*fs/(2*L);
r2 = w2*fs/(2*L);
r3 = w3*fs/(2*L);
r4 = w4*fs/(2*L);

maximum = max(abs(Y));
text(r1+1, maximum*1.03, '7\pi');
text(r2, maximum/3, '3.5\pi');
text(r3+1, maximum*1.03*2/3, '6\pi');
text(r4+1, maximum*1.03*2/3, '5\pi');
% xlim([0 fs/2]); ylim([0, maximum*1.2]);
title('Representación en frecuencia');
xlabel('Frecuencia (rad/s)'); ylabel('Amplitud');
xlim([0, 35])

print('FormulasAndImages/005','-dpng')

%% Onda cuadradada

syms t y(t) ySum(t)
y(t) = piecewise(0 < mod(t,2*pi) <= pi, pi/4, pi < mod(t,2*pi) <= 2*pi, -pi/4);

figure
fplot(y)
ylim([-0.5 1.5])

f = figure;
filename = 'FormulasAndImages/006.gif';
ySum(t) = 0;

for n = 1:15
    
    subplot(2,1,1)
    fplot(y, 'color', 'blue')
    hold on
    ySum(t) = ySum(t) + sin((2*n-1)*t)./(2*n-1);
    fplot(ySum,'LineWidth',1)
    hold off
    ylim([-1.3, 1.3])
    title(strcat('Número de sinusoides usadas:',string(n)))
    
    subplot(2,1,2)
    fplot(sin((2*n-1)*t)./(2*n-1));
    axis equal
    ylim([-1.3, 1.3])
    title('Sinusoide actual')
    
    frame = frame2im(getframe(f));
    [imind, cm] = rgb2ind(frame, 256);
    
    if n == 1
        imwrite(imind, cm, filename, 'gif', 'DelayTime', 0.4, 'Loopcount', inf);
    else
        imwrite(imind, cm, filename, 'gif', 'DelayTime', 0.4, 'WriteMode', 'append');
    end
    
end

%% Transformada de Laplace y de Fourier

y(t) = mod(t,1) <= 1 * triang(1);

figure
fplot(y(t))

