% Kernel Ridge Regression
% Initailization (Dataset: data2)
clear all;clc;
 
% * Zscore normalization

data=zscore(csvread('GaussianData.csv'));
x=data(:,1:end-1);
y=data(:,end);
% 
% * Total number of data points

N=length(data);
% 
% * Visualization of the Data

figure
scatter3(x(:,1),x(:,2),y,'g')
title('Kernel Ridge Regression')
xlabel({'x_1'})
ylabel({'x_2'})
zlabel('y')
view([-47.1 4.4])
legend('Data Points')
% Various Kernels for above data
% * Linear Kernel
%
K_linear=(x*x');
% 
% * Polynomial Kernel (Poly3)

K_poly3=(x*x').^3;
% 
% * Gaussian Kernel

K_gauss=zeros(N,N);
for j=1:N
 for i=1:N
    K_gauss(i,j)=exp(-norm(x(j,:)-x(i,:)));
 end
end
% Algorithm
% # f_linear : Regression Function due to Linear Kernel
% # f_poly3 : Regression Function due to Poly3 Kernel
% # f_gaussian : Regression Function due to Gaussian Kernel
% 
% * mse : Mean Square Error
% * A\b instead of inv(A)*b for faster computation
%
f_linear=zeros(N,1);
f_poly3=zeros(N,1);
f_gaussian=zeros(N,1);

mse=[];
intvl=0.1;

for lambda=intvl:intvl:1
    
    for i=1:N
        
        f_linear(i,1)= y'*((K_linear+ lambda*eye(N))\K_linear(i,:)');
        
        f_poly3(i,1)= y'*((K_poly3+ lambda*eye(N))\K_poly3(i,:)');
        
        f_gaussian(i,1)= y'*((K_gauss+ lambda*eye(N))\K_gauss(i,:)');
    end
     
    mse=[mse; norm(f_linear-y)^2/N, norm(f_poly3-y)^2/N, norm(f_gaussian-y)^2/N];
end
% Mean square error is the assessment measure for optimal Kernel
%
mse_=min(mse(:,1));
fprintf('Mean square error (Linear Kernel) : %f',mse_)

mse_=min(mse(:,2));
fprintf('Mean square error (Poly3 Kernel) : %f',mse_)

[mse_,gaussain_indx]=min(mse(:,3));
fprintf('"minimum" Mean square error (Gaussian Kernel) : %f',mse_)

% Optimal Langrangian Parameter
%
lambda_optimal=intvl*gaussain_indx
% Prediction Values (due to various Kernels)
%
Predicted=[y,f_linear,f_poly3,f_gaussian]
% Alpha & Dual, calculated as follows :
%
alpha=2*lambda_optimal*inv((K_gauss+lambda_optimal*eye(N)))*y
W_alpha=y'*alpha -(1/4*lambda_optimal)*alpha'*K_gauss*alpha -(1/4)*alpha'*alpha
% Actual Vs Predicted Values
%
figure
hold on

scatter3(x(:,1),x(:,2),y,'g')
scatter3(x(:,1),x(:,2),f_gaussian,'.r')

title('Kernel Ridge Regression')
xlabel({'x_1'})
ylabel({'x_2'})
zlabel('y')
view([-47.1 4.4])
legend('Actual Data','Predicted Data')

hold off
%
% Bhartendu, Machine Learning & Computing