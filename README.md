# Shrek LAB

Shrek LAB es un entorno de procesado de imágenes basado en MATLAB que permite generar dibujos por medio de la FFT.

## Tabla de contenidos

- [Tabla de contenidos](#tabla-de-contenidos)
- [Motivaciones](#motivaciones)
- [¿Qué es la FFT?](#-qué-es-la-fft-)

## Motivaciones

Desde hace unos años me han fascinado los vídeos de divulgadores de conocimiento en internet, como [QuantumFracture](https://www.youtube.com/user/QuantumFracture), [3Blue1Brown](https://www.youtube.com/c/3blue1brown), [Lemnismath](https://www.youtube.com/channel/UC-ihtKdODqNE7iPISJD3DnA) o incluso [Arremetes](https://www.youtube.com/channel/UCIw1j0fGzLJoOWpIbXihLKw).

Concretamente, el vídeo titulado [_But what is a Fourier series? From heat flow to drawing with circles_](https://www.youtube.com/watch?v=r6sGWTCMz2k&t=372s) es aquel que me motivó a intentar hacer accesible la potencia de la FFT a las personas que aún están adentrándose en este mundillo.

## ¿Qué es la FFT?

La FFT (_Fast Fourier Transform_) es un algoritmo que implementa la DFT (_Discrete Fourier Transform_) de manera optimizada para el cálculo computacional. A pesar de tener muchas versiones, la más famosa fue la que desarrollaron James Cooley y John Tukey en 1965, conocida como [algoritmo Cooley-Tukey](https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm). Muchos consideran este algoritmo como uno de los más importantes en el mundo moderno.

## ¿Cómo se dibuja usando la FFT?

El funcionamiento es más sencillo de lo que puede parecer (lo prometo).

Al realizar la FFT, tomamos N muestras complejas y obtenemos otras N muestras complejas. De estos, el **módulo** representa el radio de la circunferencia, su **frecuencia** es la frecuencia de giro (puede ser en sentido horario o antihorario) y su **fase** es la fase inicial del giro.

Si consideramos una línea continua y cerrada (por ejemplo, la silueta de la imagen), sus coordenadas cartesianas (x,y) pueden ser consideradas como las partes real e imaginaria, respectivamente, de un número complejo.

Por lo tanto, para obtener los radios, las frecuencias de giro y las fases iniciales, solo debemos realizar la siguiente operación:

![z[k] = \text{FFT}^N\Big\lbrace x[n] + i \cdot y[n]\Big\rbrace , , \qquad k = 0, 1, \ldots , N-1](formula_01.png)

En MATLAB será algo así como:

```matlab
% Obtención de coordenadas a partir de la matriz de coordenadas 'C'
x = C(:,1);
y = C(:,2);

% Cálculo de la FFT, resultado comprendido entre [-pi, pi]
z_k = fftshift(fft(x + 1i*y));
L = length(z_k);

% Obtención de parámetros
radios       = abs(z_k);
frecuencias  = (1:L) - L/2 - 1;
fases        = angle(z_k);
```
