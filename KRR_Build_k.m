%KRR Gaussian Prediction Kernel
%Robert Kuramshin
function [k]=KRR_Build_k(x_train,x_test)
    N_test = length(x_test);
    N_train = length(x_train);

    k=zeros(N_test,N_train);
    for j=1:N_train
     for i=1:N_test
        k(i,j)=exp(-norm(x_train(j,:)-x_test(i,:)));
     end
    end
end