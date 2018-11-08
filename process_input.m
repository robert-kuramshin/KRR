% Process Sample Dataset
% double_perovskites_gap.csv
clear all;clc;

% import file
[y,x_str] = xlsread("double_perovskites_gap.xlsx","bandgap",'B2:F1307','basic');
%N = length(y);
N = 1300;
y = y(1:N,:);

%empty x array
x = zeros(N,4);


%convert string values to integers
for j=1:4
    lbls = containers.Map;
    x_ints = 1;
    for i=1:N
        t = x_str(i,j);
        lbl = t{1};
        if lbls.isKey(lbl) == 0
            lbls(lbl) = x_ints;
            x_ints = x_ints + 1;
        end
        x(i,j) = lbls(lbl);
    end
    lbls.keys;
end

%normalize
[x,x_mean,x_stdev] = zscore(x);
[y,y_mean,y_stdev] = zscore(y);


%gaussian
K_gauss=zeros(N,N);
for j=1:N
 for i=1:N
    K_gauss(i,j)=exp(-norm(x(j,:)-x(i,:)));
 end
end

%error 
f_gaussian=zeros(N,1);

mse=[];
intvl=0.1;

for lambda=intvl:intvl:1
    fprintf('On iteration: %d of %d\n',int32((lambda/intvl)),(1/intvl));
    for i=1:N
        if mod(i,50) == 0
            fprintf('Training on Sample: %d of %d\n',i,N);
        end
        f_gaussian(i,1)= y'*((K_gauss+ lambda*eye(N))\K_gauss(i,:)');
    end
    mse=[mse;norm(f_gaussian-y)^2/N];
end

[mse_,gaussain_indx]=min(mse(:,1));
fprintf('"minimum" Mean square error (Gaussian Kernel) : %f',mse_)


% Optimal Langrangian Parameter
%
lambda_optimal=intvl*gaussain_indx
% Prediction Values (due to various Kernels)
%
Predicted=[y,f_gaussian]
% Alpha & Dual, calculated as follows :
%
alpha=2*lambda_optimal*inv((K_gauss+lambda_optimal*eye(N)))*y
W_alpha=y'*alpha -(1/4*lambda_optimal)*alpha'*K_gauss*alpha -(1/4)*alpha'*alpha

figure
hold on
y = y*y_stdev+y_mean;
f_gaussian = f_gaussian*y_stdev+y_mean;

scatter(y,f_gaussian)

title('Kernel Ridge Regression')
xlabel({'y'})
ylabel({'predicted'})

hold off


     
    