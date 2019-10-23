function [F, K, m] = Segmenta(I, m, nI, tf)
%I es la imagen
% m = [media1 sgm1, media2, sgm2, ..., median sgmn]
%nI =iteraciones
%tf=tamaño del filtro coherencia espacial
[nr,nc] = size(I);
F = zeros(size(I));
nM = size(m,1);
K = zeros(nr,nc,nM);
o=1;
% fig = figure('position',[50 50 850 600]);
% Colores=[0,0,0;1 0 0;0 0 1;0 1 0;0.5,0.5,0.5;0,.2,0;.1,0,.6;...
%          .3,.8,.3;.4,.4,.9;0,.1,.48;.6,.1,.9];
%figure('Renderer','zbuffer');
%% Evalua cada pixel en los modelos Gaussianos

for iter = 1:nI
%     subplot(1,2,1)
%     imshow(mat2gray(F))
%     title(['numero de iteración', ' ' num2str(iter-1)])
%     subplot(1,2,2)
%     hold off
%     for ii=1:nM
%     p1 = pdf('Normal',0:1:256,m(ii,1),m(ii,2));
%     plot(0:1:256,p1,'Color',Colores(ii,:))
%     hold on
%     end
    for k=1:nM
        for i=1:nr
            for j=1:nc
                sigma = m(k,2);
                if sigma <= 1e-2
                    sigma = 0.01;
                end
                K(i,j,k) = 1/sqrt(2*pi*sigma^2)*exp(-(I(i,j)-m(k,1))^2/(2*sigma^2));
            end
        end
    end
 %%   Filtrado (promedio) de los dos modelos Gaussianos
    if tf > 0
        for k =1:nM
             K(:,:,k) = medfilt2(K(:,:,k),[tf tf]);
            h=fspecial('gauss',[tf,tf]);
             K(:,:,k) =imfilter(K(:,:,k),h);
        end
    end
%% compara el valor de cada pixel en los dos modelos y el mayor le asigna un 1 y al otro un 0    
    for i=1:nr
        for j=1:nc
            maximo = 1;
            for k=2:nM
                if K(i,j,k) > K(i,j,maximo)
                    K(i,j,maximo)=0;
                    maximo = k;
                end
            end
            K(i,j,maximo)= 1;
        end
    end
    for i=1:nM
        m(i,1) = 0;
        m(i,2) = 0;
    end
    %% Encuentra las nuevas medias y varianzas
    for k=1:nM
        N = 0;
        for i=1:nr
            for j=1:nc
                if K(i,j,k) >= 1
                    m(k,1) = m(k,1) + I(i,j);
                    N = N + 1;
                end
            end
        end
        if N >= 1
            m(k,1) = m(k,1)/N;
        end
    end
    
    for k=1:nM
        N = 0;
        for i=1:nr
            for j=1:nc
                if K(i,j,k) >= 1
                    m(k,2) = m(k,2) + (I(i,j)-m(k,1))^2;
                    N = N + 1;
                end
            end
        end
        if N >= 1
             m(k,2) = sqrt(m(k,2)/N);
        end
    end
    
    
    for i=1:nr
        for j=1:nc
            for k=1:nM
                if K(i,j,k) == 1
                    F(i,j) = k-1;
                end
            end
        end
    end
end


