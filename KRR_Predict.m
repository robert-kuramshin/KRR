%KRR Predict
%Robert Kuramshin
function [y_predicted]=KRR_Predict(y_train,x_test,K,k,lambda)
    N_test = length(x_test);
    N_train = length(y_train);

    y_predicted=zeros(N_test,1);
    for i=1:N_test
        y_predicted(i,1)= y_train'*((K+ lambda*eye(N_train))\k(i,:)');
    end
end