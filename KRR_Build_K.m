%KRR Gaussian Kernel
%Robert Kuramshin
function [K]=KRR_Build_K(x_train)
    N_train = length(x_train);

    K=zeros(N_train,N_train);
    for j=1:N_train
     for i=1:N_train
        K(i,j)=exp(-norm(x_train(j,:)-x_train(i,:)));
     end
    end
end