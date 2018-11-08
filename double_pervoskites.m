%Robert Kuramshin
%KRR (w. Gaussian Kernel) + k-Fold cross-validation 
clc;

%Import file
[y,x_str] = xlsread("double_perovskites_gap.xlsx","bandgap",'B2:F1307','basic');

%Use all samples or specify a number 
N = length(y);
%N = 200

%Initailze Inputs 
y = y(1:N,:);
x = zeros(N,4);

%Numerize string x_str values
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

%Normalize
[x,x_mean,x_stdev] = zscore(x);
[y,y_mean,y_stdev] = zscore(y);

%Random shuffle
shuffled_indexes = randperm(N);
x = x(shuffled_indexes,:);
y = y(shuffled_indexes,:);

%Train split amount
t_split = 0.9;

%Test/train split

N_train =int32(N*t_split);
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

%Data Visualized
figure
hold on

scatter3(x_test(:,1),x_test(:,2),y_test,'g')
scatter3(x_test(:,1),x_test(:,2),best_prediction,'r')

title('Actual vs Predicted Band-Gap')
xlabel({'x_1'})
ylabel({'x_2'})
zlabel('y')
view([-47.1 4.4])
legend('Actual Band Gap (Normalized)','Predicted Band Gap (Normalized)')

hold off


     
    