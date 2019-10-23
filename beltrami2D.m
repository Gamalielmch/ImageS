function Fim = beltrami2D(Ik, num_iter, delta_t)
% Beltrami Flow is a Non??Linear filter
%   Fim = beltrami2D(im, num_iter, delta_t) perfoms 
%   Beltrami flow  (J.J. Fern??ndez, J. M) upon a gray scale
%   image. A 2D network structure of 8 neighboring nodes is considered for 
%   filtering process.
% 
%       ARGUMENT DESCRIPTION:
%               IM       - gray scale image (MxN).
%               NUM_ITER - number of iterations. 
%               DELTA_T  - the time step, usually for stability set to the receprocal 
%                           of the squared number of dimension.
%               
%       OUTPUT DESCRIPTION:
%                Fim - (Filtered) image.
% 
%   Example
%   -------------
%   s = phantom(512) + randn(512);
%   num_iter = 15;
%   delta_t = 1/4;
%   sf = beltrami2D(s,num_iter,delta_t);
%   figure, subplot 121, imshow(s,[]), subplot 122, imshow(sf,[])
% 
% See also beltrami3D.

% References: 
% J.J. Fern??ndez, J. M. (2010). Three-dimensional feature-preserving noise reduction for real-time
% electron tomography (Bd. 20). Madrid, Spain: Digital Signal Processing .


% 
% Credits:
% Shadi Nabil Albarqouni
% Technical University Munich 
% shadi.albarqouni@in.tum.de
% Apr 2013 original version.

% Convert input image to double.
%

% Gradient contruction
hx=0.5.*[0 0 0; -1 0 1; 0 0 0];
hy=0.5.*[0 -1 0; 0 0 0; 0 1 0];

hxx=[0 0 0; 1 -2 1; 0 0 0];
hyy=[0 1 0; 0 -2 0; 0 1 0];

hxy=[1 0 -1; 0 0 0; -1 0 1];

for i=1:num_iter
    
    Ixx=imfilter(Ik,hxx,'conv');
    Iyy=imfilter(Ik,hyy,'conv');
    Ix=imfilter(Ik,hx,'conv');
    Iy=imfilter(Ik,hy,'conv');
    Ixy=imfilter(Ik,hxy,'conv');
    
    Ikx=Ik+delta_t.*((Ixx.*(ones(size(Iy))+Iy.^2)+Iyy.*(ones(size(Ix))+Ix.^2)-2.*Ix.*Iy.*Ixy)./(ones(size(Ix))+Ix.^2+Iy.^2).^2);
    Fim= Ikx;
    Ik = Ikx;
end