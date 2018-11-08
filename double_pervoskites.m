clear all;clc;

%Import file
[y,x_str] = xlsread("double_perovskites_gap.xlsx","bandgap",'B2:F1307','basic');

%Use all samples or specify a number 
N = length(y);
%N = 200

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

N_train = (N*t_split);
N_test = N-N_train;

x_test = x(N_train+1:end,:);
x_train = x(1:N_train,:);

y_test = y(N_train+1:end,:);
y_train = y(1:N_train,:);


%build gaussian kernel K
KRR_Build_K(x_train);

%build gaussian kernel k
KRR_Build_k(x_train,x_test);

%look for lambda with lowest k-fold cross-validation error
interval = 0.01;
for lambda = interval:interval:1
    
end




     
    