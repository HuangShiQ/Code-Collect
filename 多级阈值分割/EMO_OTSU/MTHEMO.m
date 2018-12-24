%Diego Oliva, Erik Cuevas, Gonzalo Pajares, Daniel Zaldivar, Valentín Osuna. 
%A Multilevel Thresholding algorithm using electromagnetism optimization
%Universidad Complutense de Madrid / Universidad de Guadalajara

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The algorithm was published as:
%Diego Oliva, Erik Cuevas, Gonzalo Pajares, Daniel Zaldivar, Valentín Osuna. 
%A Multilevel Thresholding algorithm using electromagnetism optimization, 
%Journal of Neurocomputing, 139, (2014), 357-381.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Intructions:
% I -> Original Image, could be RGB or Gray Scale
% level -> Number of threshold to find
% This version works with OTSU as fitness function.

%Example 
%>> I = imread('test1.jpg');
%>> [Iout] = MTHEMO(I,2);


function [Iout] = MTHEMO(I,level)

% Se obtienen los histogramas si la imagen es RGB uno por cada canal si es
% en escala de grises solamente un historgrama.
if size(I,3) == 1 %grayscale image
    [n_countR, x_valueR] = imhist(I(:,:,1));
elseif size(I,3) == 3 %RGB image
    %histograma para cada canal RGB
    [n_countR, x_valueR] = imhist(I(:,:,1));
    [n_countG, x_valueG] = imhist(I(:,:,2));
    [n_countB, x_valueB] = imhist(I(:,:,3));
end
Nt = size(I,1) * size(I,2); %Cantidad total de pixeles en la imagen RENG X COL
%Lmax niveles de color a segmentar 0 - 256
Lmax = 256;   %256 different maximum levels are considered in an image (i.e., 0 to 255)

% Distribucion de probabilidades de cada nivel de intensidad del histograma 0 - 256 
for i = 1:Lmax
    if size(I,3) == 1 
        %grayscale image
        probR(i) = n_countR(i) / Nt;
    elseif size(I,3) == 3 
        %RGB image    
        probR(i) = n_countR(i) / Nt;
        probG(i) = n_countG(i) / Nt;
        probB(i) = n_countB(i) / Nt;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parametros del problema de segmentacion
N_PAR = level  - 1; %number of thresholds (number of levels-1) (dimensiones)
dim = N_PAR;  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parametros de la poblacion
%maximo de iteraciones
MAXITER = 200;
%m cantidad de puntos, n dimensiones en las cuales se trabaja
m = 50; %cantidad de miembros de la poblacion
n = dim; %dimensiones del problema
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1:1%35  % for para pruebas estadisticas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parametros del espacio de busqueda
%Crea el espacio de busqueda
%u -> vector de limites superiores de cada dimension
%l -> vector de limites inferiores de cada dimension
%xR, xG, xB -> poblaciones inicializadas en cero

if size(I,3) == 1
    % Imagen en escala de grises
    u = ones(1,dim) * Lmax;
    l = ones(1,dim);
    xR = zeros(m,n);

elseif size(I,3) == 3
    % Imagen RGB
    u = ones(1,dim) * Lmax;
    l = ones(1,dim);
    %uR = ones(1,dim) * Lmax;
    %lR = ones(1,dim);
    xR = zeros(m,n);

    %uG = ones(1,dim) * Lmax;
    %lG = ones(1,dim);
    xG = zeros(m,n);
    
    %uB = ones(1,dim) * Lmax;
    %lB = ones(1,dim);
    xB = zeros(m,n);
end

    
      

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %EMO Original               %%Version 4%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Generar y evaluar la poblacion que sera evolucionada durante la optimizacion
    %se generan m valores aleatorios y se evaluan en la funcion de fitness Ec. 4       
    if size(I,3) == 1
        % Imagen en escala de grises
        % Inicializacion aleatoria
        xR = incializa(m,n,u,l,xR);
        for si=1:length(xR)
           xR(si,:)=sort(xR(si,:)); 
        end
        % Evaluar poblacion en la funcion de fitness
        [fitR, fitBestR] = fitnessIMG(I, m, Lmax, level, xR, probR);
        
        % Elige el mejor elemento de la poblacion en base al fitness
        [aR, bR] = max(fitR); %Maximiza
        xBestR = xR(bR, :);
        fxBestR = fitR(bR);
        
    elseif size(I,3) == 3
        % Imagen RGB
        % Inicializacion aleatoria para cada canal R, G, B
        xR = incializa(m,n,u,l,xR);
        xG = incializa(m,n,u,l,xG);
        xB = incializa(m,n,u,l,xB);
        % Evalua la poblacion de cada canal en la funcion de fitness
        [fitR, fitBestR, fitG, fitBestG, fitB, fitBestB] = fitnessIMG(I, m, Lmax, level, xR, probR, xG, probG, xB, probB);
        
        % Se elige el mejor elemento de cada poblacion en base al fitness 
        [aR,bR] = max(fitR); %maximiza
        xBestR = xR(bR, :);
        fxBestR = fitR(bR);
        
        [aG,bG] = max(fitG); % maximiza
        xBestG = xG(bG, :);
        fxBestG = fitG(bG);
        
        [aB,bB] = max(fitB); % maximiza
        xBestB = xB(bR, :);
        fxBestB = fitR(bR);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %delta -> valor de vecindad de busqueda
    %LSITER -> valor  maximo de iteraciones para la busqueda
    delta = 0.025;
    LSITER = 4;
    cc = 0;
    it = 0;

    while it < MAXITER
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if size(I,3) == 1
            % Imagen escala de grises
            [bR,xR,fitR,xBestR,fxBestR] = local(I,Lmax,level,LSITER,delta,m,n,l,u,xR,fitR, probR);
            FxR = calcFO(m,n,xR,fitR,xBestR,fxBestR);
            xR = moveO(FxR,xR,m,n,bR,l,u);
            for si=1:length(xR)
                xR(si,:)=sort(xR(si,:)); 
            end
            
            [fitR, fitBestR] = fitnessIMG(I, m, Lmax, level, xR, probR);
            BestvalR_fit(it + 1) = fxBestR;
        elseif size(I,3) == 3
            % Imagen RGB
                      
            [bR,xR,fitR,xBestR,fxBestR] = local(I,Lmax,level,LSITER,delta,m,n,l,u,xR,fitR,probR);
            FxR = calcFO(m,n,xR,fitR,xBestR,fxBestR);
            xR = moveO(FxR,xR,m,n,bR,l,u);
            
            [bG,xG,fitG,xBestG,fxBestG] = local(I,Lmax,level,LSITER,delta,m,n,l,u,xG,fitG,probG);
            FxG = calcFO(m,n,xG,fitG,xBestG,fxBestG);
            xG = moveO(FxG,xG,m,n,bR,l,u);
            
            [bB,xB,fitB,xBestB,fxBestB] = local(I,Lmax,level,LSITER,delta,m,n,l,u,xB,fitB,probB);
            FxB = calcFO(m,n,xB,fitB,xBestB,fxBestB);
            xB = moveO(FxB,xB,m,n,bB,l,u);
            
            [fitR, fitBestR, fitG, fitBestG, fitB, fitBestB] = fitnessIMG(I, m, Lmax, level, xR, probR, xG, probG, xB, probB);
            
        end     
        
        it = it + 1;
        
    end
    
    if size(I,3) == 1
            BestvalR(ii) = fxBestR;
    elseif size(I,3) == 3    
            BestvalR(ii,:) = xBestR;
            BestvalG(ii,:) = xBestG;
            BestvalB(ii,:) = xBestB;
    end
    
 end
    

        
%Show and plot Results   
    
if size(I,3) == 1 %grayscale image
    gBestR = sort(xBestR);
    Iout = imageGRAY(I,gBestR);
    Iout2 = mat2gray(Iout);
    %show results
    intensity = gBestR %intensity  value of the best elemento (TH)
    STDR =  std(BestvalR)  %Standar deviation of fitness
    MEANR = mean(BestvalR) %Mean of fitness
    PSNRV = PSNR(I, Iout)  %PSNR between original image I and the segmented image Iout
    fxBestR                %Best fitness
    %Show results on images
    figure
    imshow(Iout)
    figure
    imshow(I)
    
    %plot the threslhol over the histogram
    figure 
    plot(probR)
    hold on
    vmax = max(probR);
    for i = 1:n
        line([intensity(i), intensity(i)],[0 vmax],[1 1],'Color','r','Marker','.','LineStyle','-');
        %plot(lineas(i,:))
        hold on
    end
    hold off
    figure
    plot(BestvalR_fit)

    
elseif size(I,3) == 3 %RGB image
    gBestR = sort(xBestR);
    gBestG = sort(xBestG);
    gBestB = sort(xBestB);
    Iout = imageRGB(I,gBestR,gBestG,gBestB);
    intensity = [gBestR,gBestG,gBestB]
    STDR =  std(BestvalR)
    STDG =  std(BestvalG)
    STDB =  std(BestvalB)
  
end