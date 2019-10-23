function [K, m,sgm] = Segmentarg(I,sense, nI, tf)

%% Encuentra la media y la covarianza inicial
%%sense recomendado de 0.05
A2=rgb2gray(I);
[nr,nc]=size(A2);
total=[];
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               Encuentra Media y Matriz de Covarianza                 %
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:4
    [hsa]=imhist(A2);
    hsa=double(hsa);
    hsa=[0 0 0 hsa(1) hsa(1) hsa(1) hsa(1) hsa' hsa(256) hsa(256) hsa(256) hsa(256) 0 0 0];
    [pks,lr]=findpeaks(smooth(hsa,sense,'loess'),'minpeakdistance',3);%%4
    total=[total lr];
end
%quita repetidos
lr=unique(total);
region=max(size(lr));
fprintf('Regiones encontradas: %d \n',region)

mask=false(nr,nc,region);
h=fspecial('gaussian',[tf,tf]);
A2=double(A2);
nI2=5;
mi=[];
for re=1:length(lr)
    mi=[lr(re) 5;mi];
end
tf=3;

[~, ~, K, ~] = Segmenta(A2, mi, nI2, tf);
for reg=1:region
    mask(:,:,reg)=im2bw( K(:,:,reg));
end
clear K
for i=1:region
    temp=mask(:,:,i);
    clear L
    for uu=1:2
        temp2=I(:,:,uu);
        m(uu,i)=mean(double(temp2(temp==1)));
    end
end
sgm(1:2,1:2,1:region)=0;
sgm(1,1,1:region)=3;
sgm(2,2,1:region)=3;
close all
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Inicia Segmentación Guassiana Multivariable               %
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F = zeros([nr,nc]);
nM = size(m,1);
K = zeros(nr,nc,nM);
%% Evalua cada pixel en los modelos Gaussianos

for iter = 1:nI
    for k=1:nM
        for i=1:nr
            for j=1:nc
                p(1:2)=double(I(i,j,1:2));
                K(i,j,k) = mvnpdf(p,m(:,k)',sgm(:,:,k));
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
    m(:,:)=0;
    %% Encuentra las nuevas medias y varianzas
    for k=1:nM
        N = 0;
        lt=[];
        for i=1:nr
            for j=1:nc
                if K(i,j,k) >= 1
                    p(1:2)=double(I(i,j,1:2));
                    lt = [p(1),p(2);lt];
                    N = N + 1;
                end
            end
        end
        if N >= 1
            m(1,k)=mean(lt(:,1));
            m(2,k)=mean(lt(:,2));
            sgm(:,:,k)= cov(lt);
        end
    end
    
end


