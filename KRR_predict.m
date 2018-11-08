%KRR Predict
%Robert Kuramshin
function [predicted]=KRR_predict(x_test,y_train,x_train,lambda)
N_test = length(x_test);
N_train = length(x_train);

K_gauss=zeros(N_train,N_train);
for j=1:N_train
 for i=1:N_train
    K_gauss(i,j)=exp(-norm(x_train(j,:)-x_train(i,:)));
 end
end

k=zeros(N_test,N_train);
for j=1:N_train
 for i=1:N_test
    k(i,j)=exp(-norm(x_train(j,:)-x_test(i,:)));
 end
end

predicted=zeros(N_test,1);

for i=1:N_test
    predicted(i,1)= y_train'*((K_gauss+ lambda*eye(N_train))\k(i,:)');
end
end