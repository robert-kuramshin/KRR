% Gaussian Example
% Robert Kuramshin
clear all;clc;

data=zscore(csvread('gaussian_data.csv'));
x=data(:,1:end-1);
y=data(:,end);

N = length(y);

%random shuffle
shuffled_indexes = randperm(N);
x = x(shuffled_indexes,:);
y = y(shuffled_indexes,:);

%train split amount
t_split = 0.6;

%test/train split

N_train = (N*t_split);
N_test = N-N_train;

x_test = x(N_train+1:end,:);
x_train = x(1:N_train,:);

y_test = y(N_train+1:end,:);
y_train = y(1:N_train,:);


%gaussian
K_gauss=zeros(N_train,N_train);
for j=1:N_train
 for i=1:N_train
    K_gauss(i,j)=exp(-norm(x_train(j,:)-x_train(i,:)));
 end
end

y_predicted_sample=zeros(N_train,1);

lambda=0.1;

for i=1:N_train
    if mod(i,10) == 0
        fprintf('Training on Sample: %d of %d\n',i,N_train);
    end
    y_predicted_sample(i,1)= y_train'*((K_gauss+ lambda*eye(N_train))\K_gauss(i,:)');
end

in_sample_error = norm(y_predicted_sample-y_train)^2/N_train

figure
hs(1) = subplot(2,1,1);
%in sample
hold on

scatter3(hs(1),x_train(:,1),x_train(:,2),y_train,'g')
scatter3(hs(1),x_train(:,1),x_train(:,2),y_predicted_sample,'r')

title('TRAIN SET')
xlabel({'x_1'})
ylabel({'x_2'})
zlabel('y')
view([-47.1 4.4])
legend('Train Set','Train Set Prediction')

hold off

k=zeros(N_test,N_train);
for j=1:N_train
 for i=1:N_test
    k(i,j)=exp(-norm(x_train(j,:)-x_test(i,:)));
 end
end

y_predicted=zeros(N_test,1);

for i=1:N_test
    y_predicted(i,1)= y_train'*((K_gauss+ lambda*eye(N_train))\k(i,:)');
end

out_sample_error = norm(y_predicted-y_test)^2/N_test

hs(2) = subplot(2,1,2);
%out of sample
hold on

scatter3(hs(2),x_test(:,1),x_test(:,2),y_test,'g')
scatter3(hs(2),x_test(:,1),x_test(:,2),y_predicted,'r')

title('TEST SET')
xlabel({'x_1'})
ylabel({'x_2'})
zlabel('y')
view([-47.1 4.4])
legend('Test Set','Test Set Prediction')

hold off