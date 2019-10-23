function  [   T   ]   =   maxFilter(inImg , w)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Computes the maximum 'local' dynamic range
%
%  inImg       : grayscale image
%  [-w, w]^2   : domain of spatial Gaussian
%  T           : maximum local dynamic range 
%
%  Author: Kunal N. Chaudhury
%  Date:   March 1, 2012
%
% Ref: K.N. Chaudhury, "Acceleration of the shiftable O(1) algorithm for
% bilateral filtering and non-local means," arXiv:1203.5128v1. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[m, n]   = size(inImg);
template = inImg;

T = 0;

% scan along row
for ii = 1 : m
    
    L     = zeros(n, 1);
    R     = zeros(n, 1);
    L(1)  = template(ii, 1);
    R(n)  = template(ii, n);
    
    for k = 2 : n
        if  mod(k - 1, w) == 0
            L(k)          = template(ii ,  k);
            R(n - k + 1)  = template(ii , n - k + 1);
        else
            L(k)          = max( L(k-1) , template(ii, k) );
            R(n - k + 1)  = max( R(n - k + 2), template(ii, n - k + 1) );
        end
    end
    
    for k = 1 : n
        p  = max(k - w, 1);
        q  = min(k + w, n);
        template(ii, k) = max( R(p), L(q) );
    end
    
end

% scan along column
for jj = 1 : n
    
    L    = zeros(m, 1);
    R    = zeros(m, 1);
    L(1) = template(1, jj);
    R(m) = template(m, jj);
    
    for k = 2 : m
        if  mod(k - 1, w) == 0
            L(k)          = template(k, jj);
            R(m - k + 1)  = template(m - k + 1, jj);
        else
            L(k)          = max( L(k - 1), template(k, jj) );
            R(n - k + 1)  = max( R(m - k + 2), template(m - k + 1, jj));
        end
    end
    
    for k = 1 : m
        p    = max(k - w, 1);
        q    = min(k + w, m);
        temp = max( R(p), L(q) ) - inImg(k, jj);
        if  temp > T
            T = temp;
        end
    end
    
end
