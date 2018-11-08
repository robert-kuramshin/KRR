% Gaussian Example
% Robert Kuramshin
clc;

addpath('../');

data=zscore(csvread('gaussian_data.csv'));
x=data(:,1:end-1);
y=data(:,end);

%Use all samples or specify a number 
N = length(y);
%N = 200

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


%Build gaussian kernel K
K = KRR_Build_K(x_train);

%Build gaussian kernel k
k = KRR_Build_k(x_train,x_test);

%Look for lambda with lowest k-fold cross-validation error
interval = 0.1;

total_intervals = (1/interval);

least_mean_squared_error = realmax;
best_prediction = [N_test,1];

error = zeros(1/interval,1);

for lambda = interval:interval:1
    i = int32(lambda/interval);
    
    fprintf('Testing Lambda Value #: %d of %d\n',i,total_intervals);
            
    y_predicted = KRR_predict(x_train,y_train,x_test,K,k,lambda);
    
    error(i,1) = Mean_Square_Error(y_test,y_predicted);
    
    if error(i,1) < least_mean_squared_error
        least_mean_squared_error = error(i,1);
        best_prediction = y_predicted;
    end
end

%Convert Normalized Data to Original Scale
y_test = y_test*y_stdev + y_mean;
best_prediction = best_prediction*y_stdev + y_mean;

%Data Visualized
figure
hold on

scatter3(x_test(:,1),x_test(:,2),y_test,'g')
scatter3(x_test(:,1),x_test(:,2),best_prediction,'r')

title('Actual vs Predicted')
xlabel({'x_1'})
ylabel({'x_2'})
zlabel('y')
view([-47.1 4.4])
legend('y','predicted')

hold off

%Error Over Lambda
figure
hold on

scatter(interval:interval:1,error,'b')

title('Lambda vs Error')
xlabel({'lambda'})
ylabel({'error'})

hold off


     
    