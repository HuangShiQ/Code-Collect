%Diego Oliva, Erik Cuevas, Gonzalo Pajares, Daniel Zaldivar, Valentín Osuna. 
%A Multilevel Thresholding algorithm using electromagnetism optimization
%Universidad Complutense de Madrid / Universidad de Guadalajara

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The algorithm was published as:
%Diego Oliva, Erik Cuevas, Gonzalo Pajares, Daniel Zaldivar, Valentín Osuna. 
%A Multilevel Thresholding algorithm using electromagnetism optimization, 
%Journal of Neurocomputing, 139, (2014), 357-381.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [fitR, fitBestR, fitG, fitBestG, fitB, fitBestB] = fitnessIMG(I, N, Lmax, level, xR, probR, xG, probG, xB, probB)
%Metodo de Otsu

%Evalua poblaciones xR, xG, xB, en la funcion objetivo para obtener
%fitR, fitG, fitB, dependiendo si la imagen es RGB o escala de grises
for j = 1:N
    if size(I,3) == 1 
        %grayscale image
        fitR(j) = sum(probR(1:xR(j,1))) * (sum((1:xR(j,1)) .* probR(1:xR(j,1)) / sum(probR(1:xR(j,1)))) - sum((1:Lmax) .* probR(1:Lmax)) ) ^ 2;
        for jlevel = 2:level - 1
            fitR(j) = fitR(j) + sum(probR(xR(j,jlevel - 1) + 1:xR(j,jlevel))) * (sum((xR(j,jlevel - 1) + 1:xR(j,jlevel)) .* probR(xR(j,jlevel - 1) + 1:xR(j,jlevel)) / sum(probR(xR(j,jlevel - 1) + 1:xR(j,jlevel)))) - sum((1:Lmax) .* probR(1:Lmax))) ^ 2;
        end
        fitR(j) = fitR(j) + sum(probR(xR(j,level-1) + 1:Lmax)) * (sum((xR(j,level - 1) + 1:Lmax) .* probR(xR(j,level - 1) + 1:Lmax) / sum(probR(xR(j,level - 1) + 1:Lmax))) - sum((1:Lmax) .* probR(1:Lmax))) ^ 2;
%         if isnan(fitR(j))
%             fitR(j)=eps;
%         end
        fitBestR(j) = fitR(j);
       
    elseif size(I,3) == 3 
        %RGB image
        fitR(j) = sum(probR(1:xR(j,1))) * (sum((1:xR(j,1)) .* probR(1:xR(j,1)) / sum(probR(1:xR(j,1)))) - sum((1:Lmax) .* probR(1:Lmax))) ^ 2;
        for jlevel = 2:level - 1
            fitR(j) = fitR(j) + sum(probR(xR(j,jlevel - 1) + 1:xR(j,jlevel))) * (sum((xR(j,jlevel - 1) + 1:xR(j,jlevel)) .* probR(xR(j,jlevel - 1) + 1:xR(j,jlevel)) / sum(probR(xR(j,jlevel - 1) + 1:xR(j,jlevel)))) - sum((1:Lmax) .* probR(1:Lmax))) ^ 2;
        end
        fitR(j) = fitR(j) + sum(probR(xR(j,level-1) + 1:Lmax)) * (sum((xR(j,level - 1) + 1:Lmax) .* probR(xR(j,level - 1) + 1:Lmax) / sum(probR(xR(j,level - 1) + 1:Lmax))) - sum((1:Lmax) .* probR(1:Lmax))) ^ 2;

        fitBestR(j) = fitR(j);
        
        fitG(j) = sum(probG(1:xG(j,1))) * (sum((1:xG(j,1)) .* probG(1:xG(j,1)) / sum(probG(1:xG(j,1)))) - sum((1:Lmax) .* probG(1:Lmax))) ^ 2;
        for jlevel = 2:level - 1
            fitG(j) = fitG(j) + sum(probG(xG(j,jlevel - 1) + 1:xG(j,jlevel))) * (sum((xG(j,jlevel - 1) + 1:xG(j,jlevel)) .* probG(xG(j,jlevel - 1) + 1:xG(j,jlevel)) / sum(probG(xG(j,jlevel - 1) + 1:xG(j,jlevel)))) - sum((1:Lmax) .* probG(1:Lmax))) ^ 2;
        end
        fitG(j) = fitG(j) + sum(probG(xG(j,level - 1) + 1:Lmax)) * (sum((xG(j,level-1) + 1:Lmax) .* probG(xG(j,level - 1) + 1:Lmax) / sum(probG(xG(j,level - 1) + 1:Lmax))) - sum((1:Lmax) .* probG(1:Lmax))) ^ 2;
        fitBestG(j) = fitG(j);
        
        fitB(j) = sum(probB(1:xB(j,1))) * (sum((1:xB(j,1)) .* probB(1:xB(j,1)) / sum(probB(1:xB(j,1)))) - sum((1:Lmax) .* probB(1:Lmax))) ^ 2;
        for jlevel = 2:level - 1
            fitB(j) = fitB(j) + sum(probB(xB(j,jlevel - 1) + 1:xB(j,jlevel))) * (sum((xB(j,jlevel - 1) + 1:xB(j,jlevel)) .* probB(xB(j,jlevel - 1) + 1:xB(j,jlevel)) / sum(probB(xB(j,jlevel - 1) + 1:xB(j,jlevel)))) - sum((1:Lmax) .* probB(1:Lmax))) ^ 2;
        end
        fitB(j) = fitB(j) + sum(probB(xB(j,level - 1) + 1:Lmax)) * (sum((xB(j,level - 1) + 1:Lmax) .* probB(xB(j,level - 1) + 1:Lmax) / sum(probB(xB(j,level - 1) + 1:Lmax))) - sum((1:Lmax) .* probB(1:Lmax))) ^ 2;
        fitBestB(j) = fitB(j);
    end
end
  if size(I,3) == 1 
      %Imagen escala de Grises
        fitR = fitR';
        fitBestR = fitBestR';
  elseif size(I,3) == 3
      % Imagen RGB
        fitR = fitR';
        fitBestR = fitBestR';
        fitG = fitG';
        fitBestG = fitBestG';
        fitB = fitB';
        fitBestB = fitBestB';
  end