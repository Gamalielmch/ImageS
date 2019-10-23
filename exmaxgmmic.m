function [mu, sigma]=exmaxgmmic(X, k,varargin)
%% Inputs
% X   = data 2-d
% k   = numbers of models
% mu  = initial means
% sgm = initial standar desviations
% it  = iterations
% pct = minimum percentage of change in the mean for continue
%%====================================================
%% STEP 1: Choose initial values for the parameters.

X=double(X);
% Set 'm' to the number of data points.
m = size(X,1)*size(X,2);
n = 3;  % The vector lengths.
% Randomly select k data points to serve as the means.
switch nargin
    case 2
        imshow(mat2gray(X));
        mu=zeros(k,3);
        sigma =cell(1,k);
        for j=1:k
            h = imrect;
            wait(h);
            h = round(getPosition(h));
            mu(j,1:3)=mean(mean(X(h(2):h(2)+h(4),h(1):h(1)+h(3),:)));
            lt1=double(X(h(2):h(2)+h(4),h(1):h(1)+h(3),1)); lt1=lt1(:);
            lt2=double(X(h(2):h(2)+h(4),h(1):h(1)+h(3),2)); lt2=lt2(:);
            lt3=double(X(h(2):h(2)+h(4),h(1):h(1)+h(3),3)); lt3=lt3(:);
            sgm=cov([lt1 lt2 lt3]);
            sigma{j}=sgm;
        end
        lt1=X(1:size(X,1)*size(X,2));
        lt2=X(size(X,1)*size(X,2)+1:2*size(X,1)*size(X,2));
        lt3=X(2*size(X,1)*size(X,2)+1:3*size(X,1)*size(X,2));
        it=50;
        pct=1e-7;
    case 3
        mu=varargin{1};
        sigma =cell(1,k);
        sigma_k = zeros(n, n);
        sigma_k(1,1) = 15^2;
        sigma_k(2,2) = 15^2;
        sigma_k(3,3) = 15^2;
        sigma{1}=sigma_k;
        for j = 2 : k
            sigma{j} = sigma{1};
        end
        lt1=X(1:size(X,1)*size(X,2));
        lt2=X(size(X,1)*size(X,2)+1:2*size(X,1)*size(X,2));
        lt3=X(2*size(X,1)*size(X,2)+1:3*size(X,1)*size(X,2));
        %         sigma{1} =  cov([lt1(:) lt2(:) lt3(:)]);
        %         for j = 2 : k
        %             sigma{j} = sigma{1};
        %         end
        it=50;
        pct=1e-7;
    case 4
        mu=varargin{1};
        sigma=varargin{2};
        it=50;
        pct=1e-7;
    case 5
        mu=varargin{1};
        sigma=varargin{2};
        it=varargin{3};
        pct=1e-7;
    case 6
        mu=varargin{1};
        sigma=varargin{2};
        it=varargin{3};
        pct=varargin{4};
    otherwise
        error ('Unexpected inputs')
end

if isempty(mu)
    mu=inimean(X,k,m);
end

if isempty(sigma)
    sigma =cell(1,k);
    for j = 1 : k
        sigma{j} = cov(X);
    end
end

if isempty(it)
    it = 50;
end
mu=double(mu); %sigma=double(sigma);
if size(mu,1)<size(mu,2); mu=mu'; end
disp('initial means:')
disp(num2str(mu))
% disp('initial stds:')
% disp(num2str(sigma))
% Assign equal prior probabilities to each cluster.
phi = ones(1, k) * (1 / k);

W = zeros(m, k);
chg=zeros(1,it);
% Loop until convergence.
for iter = 1:it
    
    fprintf('  EM Iteration %d\n', iter);
    
    %%===============================================
    %% STEP 3a: Expectation
    %
    % Calculate the probability for each data point for each distribution.
    
    % Matrix to hold the pdf value for each every data point for every cluster.
    % One row per data point, one column per cluster.
    pdf = zeros(m, k);
    
    % For each cluster...
    for j = 1 : k
        % Evaluate the Gaussian for all data points for cluster 'j'.
        pdf(:, j) = gaussianND([lt1(:) lt2(:) lt3(:)], mu(j,:), sigma{j});
    end
    
    
    
    % Multiply each pdf value by the prior probability for each cluster.
    %    pdf  [m  x  k]
    %    phi  [1  x  k]
    %  pdf_w  [m  x  k]
    pdf_w = bsxfun(@times, pdf, phi);
    
    % Divide the weighted probabilities by the sum of weighted probabilities for each cluster.
    %   sum(pdf_w, 2) -- sum over the clusters.
    W = bsxfun(@rdivide, pdf_w, sum(pdf_w, 2));
    
    %%===============================================
    %% STEP 3b: Maximization
    %%
    %% Calculate the probability for each data point for each distribution.
    
    % Store the previous means so we can check for convergence.
    prevMu = mu;
    
    % For each of the clusters...
    for j = 1 : k
        
        % Calculate the prior probability for cluster 'j'.
        phi(j) = mean(W(:, j),1);
        
        % Calculate the new mean for cluster 'j' by taking the weighted
        % average of *all* data points.
        mu(j,1) = weightedAverage(W(:, j), lt1(:));
        mu(j,2) = weightedAverage(W(:, j), lt2(:));
        mu(j,3) = weightedAverage(W(:, j), lt3(:));
        sigma_k = zeros(n, n);
        Xm = bsxfun(@minus, [lt1(:) lt2(:) lt3(:)], mu(j, :));
        
        % Calculate the variance for cluster 'j' by taking the weighted
        % average of the squared differences from the mean for all data
        % points.
        %for i = 1 : m  
        sigma_k(1) = sum(W(:, j) .* (Xm(:,1).* Xm(:,1)));
        sigma_k(2) = sum(W(:, j) .* (Xm(:,2).* Xm(:,1)));
        sigma_k(3) = sum(W(:, j) .* (Xm(:,3).* Xm(:,1)));
        sigma_k(4) = sigma_k(2);
        sigma_k(5) = sum(W(:, j) .* (Xm(:,2).* Xm(:,2)));
        sigma_k(6) = sum(W(:, j) .* (Xm(:,3).* Xm(:,2)));
        sigma_k(7) = sigma_k(3);
        sigma_k(8) = sigma_k(6);
        sigma_k(9) = sum(W(:, j) .* (Xm(:,3).* Xm(:,3)));
        %end
        
        % Divide by the sum of weights.
        sigma{j} = sigma_k ./ sum(W(:, j));
    end
    
    borrar=[];
    for j=1:k
        if isnan(mu(j,1))
            borrar=[borrar, j];
        end
    end
    if ~isempty(borrar)
        o=1;
        for i=1:k
            if sum(borrar==i)<1
                sigmat{o}=sigma{i};
                o=o+1;
            end
        end
        sigma=sigmat;
        k=k-length(borrar);
        mu(borrar,:)=[];
        prevMu(borrar,:)=[];
        phi(borrar)=[];
        pdf(:,borrar)=[];
        pdf_w(:,borrar)=[];
        W(:, borrar)=[];
    end
    
    
    
    
    % Check for convergence.
    % Comparing floating point values for equality is generally a bad idea, but
    % it seems to be working fine.
    chg(iter)=max(max(abs((mu-prevMu)./mu)))*100;
    disp(['Change percentual of mean ', num2str(chg(iter)), ' %'])
    if (chg(iter) <= pct)
        break
    end
    
    % End of Expectation Maximization loop.
end
disp('final means:')
disp(num2str(mu))
%%=====================================================
%% STEP 4: Plot the data points and their estimated pdfs.
itc=uint8(X);
[a,b,~]=size(itc);
for j = 1 : m
    [~,mm]=max(pdf(j, :));
    itc(j)=mu(mm,1);
    itc(j+a*b)=mu(mm,2);
    itc(j+2*a*b)=mu(mm,3);
end

figure
imshow(itc)

end

%%%function to initialize mean
function mu=inimean(X,k,m)
indices1=randi([0, 255],k,1);
indices2=randi([0, 255],k,1);
indices3=randi([0, 255],k,1);
mu(:,1)=indices1;
mu(:,2)=indices2;
mu(:,3)=indices3;
for i=1:k-1
    igual=1;
    mut = mu(i,:);
    while igual==1
        for j=1:k
            if j~=i
                if sum(mut==mu(j,:))==3
                    igual=1;
                    indeces = randperm(m);
                    mu(i,:) = X(indeces(i),indeces(i),:);
                    mut = mu(i,:);
                    break
                else
                    igual=0;
                end
            end
        end
    end
end

end
