% Gaussian Example using KRR_Optimize
% Robert Kuramshin
clc;

addpath('../');
addpath('../data/');

data=zscore(csvread('gaussian_data.csv'));
x=data(:,1:end-1);
y=data(:,end);

%Use all samples or specify a number 
N = length(y);

%Random shuffle
shuffled_indexes = randperm(N);
x = x(shuffled_indexes,:);
y = y(shuffled_indexes,:);

%Train split amount
n_folds = 10;

%Validation splits split

N_train =int32(N*(n_folds-1)/n_folds);
N_test = N-N_train;

x_test = x(N_train+1:end,:);
x_train = x(1:N_train,:);

y_test = y(N_train+1:end,:);
y_train = y(1:N_train,:);

%Easy to use lambda hyperparameter optimization function
lambda = KRR_Optimize(x_train,y_train,10);

%Build gaussian kernel K
K = KRR_Build_K(x_train);

%Build gaussian kernel k
k = KRR_Build_k(x_train,x_test);

y_predicted = KRR_Predict(y_train,x_test,K,k,lambda);

%Data Visualized
figure
hold on

scatter3(x_test(:,1),x_test(:,2),y_test,'g')
scatter3(x_test(:,1),x_test(:,2),y_predicted,'r')

title('Actual vs Predicted')
xlabel({'x_1'})
ylabel({'x_2'})
zlabel('y')
view([-47.1 4.4])
legend('y','predicted')

hold off


     
    