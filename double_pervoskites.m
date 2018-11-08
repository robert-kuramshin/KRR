% Process Sample Dataset
% double_perovskites_gap.csv
clear all;clc;

% import file
[y,x_str] = xlsread("double_perovskites_gap.xlsx","bandgap",'B2:F1307','basic');

%Use all samples or specifu a number 
%N = length(y);
N = 200;

%Initailze Inputs 
y = y(1:N,:);
x = zeros(N,4);

%Numerize string x values
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

%random shuffle
shuffled_indexes = randperm(N);
x = x(shuffled_indexes,:);
y = y(shuffled_indexes,:);

%test/train split
N_test = N-(N*0.9);
N_train = N-N_test;

x_test = x((N*0.9)+1:end,:);
x_train = x(1:(N*0.9),:);

y_test = y((N*0.9)+1:end,:);
y_train = y(1:(N*0.9),:);



%gaussian
K_gauss=zeros(N_train,N_train);
for j=1:N_train
 for i=1:N_train
    K_gauss(i,j)=exp(-norm(x_train(j,:)-x_train(i,:)));
 end
end

%error 
f_gaussian=zeros(N_train,1);

intvl=0.01;
mse=zeros(1/intvl,1);
out_s_e = zeros(1/intvl,1);
res=zeros(N_test,1);

for lambda=intvl:intvl:1
    fprintf('On iteration: %d of %d\n',int32((lambda/intvl)),(1/intvl));
    for i=1:N_train
        if mod(i,50) == 0
            fprintf('Training on Sample: %d of %d\n',i,N_train);
        end
        f_gaussian(i,1)= y_train'*((K_gauss+ lambda*eye(N_train))\K_gauss(i,:)');
    end
    mse(int32(lambda/intvl)) = norm(f_gaussian-y_train)^2/N_train;
    
    for i=1:N_test
        res(i,1)= y_train'*((K_gauss+ lambda*eye(N_train))\(x_train*(x_test(i,:)')));
    end
    out_s_e(int32(lambda/intvl)) = norm(res-y_test)^2/N_test;
    %res = res/10;
     
    
end

mse_=min(mse);
gaussain_indx = 1;
fprintf('"minimum" Mean square error (Gaussian Kernel) : %f',mse_)


% Optimal Langrangian Parameter
%
lambda_optimal=intvl*gaussain_indx;
% Prediction Values (due to various Kernels)
%
Predicted=[y_train,f_gaussian];
% Alpha & Dual, calculated as follows :
%
alpha=2*lambda_optimal*inv((K_gauss+lambda_optimal*eye(N_train)))*y_train;
W_alpha=y_train'*alpha -(1/4*lambda_optimal)*alpha'*K_gauss*alpha -(1/4)*alpha'*alpha;

y_train = y_train*y_stdev+y_mean;
f_gaussian = f_gaussian*y_stdev+y_mean;

figure
hold on

scatter(y_train,f_gaussian)

title('In Saple Results')
xlabel({'y'})
ylabel({'predicted'})

hold off

scatter(y_test,res)

title('Out of Sample Results')
xlabel({'y'})
ylabel({'predicted'})

hold off


     
    