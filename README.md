# Shrek LAB

## Introducción

Desde hace unos años me han fascinado los vídeos de divulgadores de conocimiento en internet, como [QuantumFracture](https://www.youtube.com/user/QuantumFracture), [3Blue1Brown](https://www.youtube.com/c/3blue1brown), [Lemnismath](https://www.youtube.com/channel/UC-ihtKdODqNE7iPISJD3DnA) o incluso [Arremetes](https://www.youtube.com/channel/UCIw1j0fGzLJoOWpIbXihLKw).

Concretamente, el vídeo titulado [_But what is a Fourier series? From heat flow to drawing with circles_](https://www.youtube.com/watch?v=r6sGWTCMz2k&t=372s) es aquel que me motivó a intentar hacer accesible la potencia de la FFT a las personas que aún están adentrándose en este mundillo.

**Shrek LAB** es un entorno de procesado de imágenes basado en MATLAB que permite generar dibujos por medio de la FFT.

## Tabla de contenidos

- [Tabla de contenidos](#tabla-de-contenidos)
- [Dependencias](#dependencias)
- [Introducción](#introducción)
- [Conceptos teóricos](#conceptos-teóricos)
  - [¿Qué es la FFT?](#¿qué-es-la-fft)
  - [¿Cómo se dibuja usando la FFT?](#¿cómo-se-dibuja-usando-la-fft)
- [Implementación en _software_](#implementación-en-software)
  - [Dependencias](#dependencias)

## Conceptos teóricos

### ¿Qué es la FFT?

La FFT (_Fast Fourier Transform_) es un algoritmo que implementa la DFT (_Discrete Fourier Transform_) de manera optimizada para el cálculo computacional. A pesar de tener muchas versiones, la más famosa fue la que desarrollaron James Cooley y John Tukey en 1965, conocida como [algoritmo Cooley-Tukey](https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm). Muchos consideran este algoritmo como uno de los más importantes en el mundo moderno.

### ¿Cómo se dibuja usando la FFT?

El funcionamiento es más sencillo de lo que puede parecer (lo prometo).

Al realizar la FFT, tomamos N muestras complejas y obtenemos otras N muestras complejas. De estos, el **módulo** representa el radio de la circunferencia, su **frecuencia** es la frecuencia de giro (puede ser positiva o negativa, lo que se traduce en sentido horario o antihorario) y su **fase** es la fase inicial del giro.

Si consideramos una línea continua y cerrada (por ejemplo, la silueta de la imagen), sus coordenadas cartesianas (x,y) pueden ser consideradas como las partes real e imaginaria, respectivamente, de un número complejo.

Por lo tanto, para obtener los radios, las frecuencias de giro y las fases iniciales, solo debemos realizar la siguiente operación:

![[z[k] = \text{FFT}^N\Big\lbrace x[n] + i \cdot y[n]\Big\rbrace , , \qquad k = 0, 1, \ldots , N-1]](formula_01.png)

## Implementación en _software_

La implementación de la fórmula anterior reside en las líneas 16 a 34 del fichero `calcContour.m`:

```matlab
% Obtención de las coordenadas y centrado de imagen en el origen.
x = width / 2 - extractedContour(:, 2);
y = height / 2 - extractedContour(:, 1);

% Cálculo de la FFT, resultado entre -pi y pi.
z_k = fftshift(fft(x + 1i * y));

% Número de muestras de la FFT.
L = length(z_k);

% Escalado que implica matemáticamente la FFT.
z_k = z_k / L;

% Generación de índices, depende de si 'fftLength' es par o impar.
if mod(L, 2) == 1
    indexes = (1:L)' - L / 2 - 1/2;
else
    indexes = (1:L)' - L / 2 - 1;
end
```

El resto del código es para leer las imágenes, ajustarlas, crear interfaces de usuario y generar un archivo de vídeo. Todo ello hace que este programa sea relativamente agradable de usar.

### Requisitos

Se aceptan las siguientes extensiones de imagen: `.jpg`, `.png`.

### Dependencias

Para que este script funcione correctamente, es necesario tener instalado [MATLAB](https://es.mathworks.com/products/matlab.html) junto con los siguientes packs de desarrollo:

- [Image Processing Toolbox](https://www.mathworks.com/products/image.html)
- [Curve Fitting Toolbox](https://es.mathworks.com/products/curvefitting.html)
