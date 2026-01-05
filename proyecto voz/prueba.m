function prueba(testdir, n, code)
% Speaker Recognition: Testing Stage (MODIFICADO PARA PALABRAS)
%
% Input:
%       testdir : Directorio con los audios de prueba
%       n       : Número de archivos de prueba (ej. 5)
%       code    : Los codebooks entrenados


nombres = {'alfa', 'bandida', 'coqueta', 'dinamita', 'expensiva'};


if length(nombres) < n
    error('Error: Tienes más archivos de audio que nombres en la lista. Agrega más nombres.');
end

for k=1:n                       
    file = sprintf('%ss%d.wav', testdir, k);
    
    % Intentar leer el archivo
    try
        [s, fs] = audioread(file);      
    catch
        warning('No se pudo leer el archivo %s. Verifica la ruta.', file);
        continue;
    end
        
    v = mfcc(s, fs);            % Calcular MFCCs
   
    distmin = inf;
    k1 = 0;
   
    % Comparar contra cada modelo entrenado
    for l = 1:length(code)      
        d = distance(v, code{l}); 
        dist = sum(min(d,[],2)) / size(d,1);
      
        if dist < distmin
            distmin = dist;
            k1 = l;
        end      
    end
   


    
    if k1 > 0
        palabra_detectada = nombres{k1}; % Lo que el modelo predijo
    else
        palabra_detectada = 'Desconocido';
    end
    
    palabra_real = nombres{k};       % Lo que debería ser
    
    if k == k1
        resultado = 'CORRECTO';
    else
        resultado = 'FALLO';
    end

    % Imprimir el resultado
    fprintf('Audio: %s (%s) -> Detectado: %s [%s]\n', ...
        file, palabra_real, palabra_detectada, resultado);
end
end