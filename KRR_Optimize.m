%KRR Train Model
%Robert Kuramshin
function [best_lambda]=KRR_Optimize(x,y,intervals)
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


    %Build gaussian kernel K
    K = KRR_Build_K(x_train);

    %Build gaussian kernel k
    k = KRR_Build_k(x_train,x_test);

    %Look for lambda with lowest k-fold cross-validation error
    interval = 1/intervals;

    total_intervals = (1/interval);

    least_mean_squared_error = realmax;
    best_lambda = interval;

    for lambda = interval:interval:1
        i = int32(lambda/interval);

        fprintf('Testing Lambda Value #: %d of %d\n',i,total_intervals);

        y_predicted = KRR_Predict(y_train,x_test,K,k,lambda);

        error = Mean_Square_Error(y_test,y_predicted);

        if error < least_mean_squared_error
            least_mean_squared_error = error;
            best_lambda = lambda;
        end
    end
end