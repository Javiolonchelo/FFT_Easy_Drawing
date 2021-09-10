% Teniendo como entrada una matriz de datos 'sheet', ordenamos los valores
% en función del índice que alberga la primera columna.
% El nuevo orden será $k = 0, 1, -1, 2, -2, \ldots$

function sortedSheet = sortCoeff(sheet)

sortedSheet = zeros(size(sheet));

for n = 1:length(sheet(:, 1))
    j = sheet(n, 1);
    
    if j > 0
        j = 2 * j - 1;
    elseif j < 0
        j = 2 * abs(j);
    end
    
    sortedSheet(j + 1, :) = sheet(n, :);
end
end