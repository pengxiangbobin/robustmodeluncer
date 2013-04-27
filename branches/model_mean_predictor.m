%Concurrent treatment of parametric uncertainty and meta-modeling
%uncertainty in robust design中Section4.1 例子研究

%Original function and Kriging model mean prediction
%计算Kriging近似模型的不确定性，不考虑变量不确定性


clc
clear

%Original model
x_ori=zeros(1001,1);
y_ori=zeros(1001,1);
for i=1:1001
    x_ori(i,1)=0.001*(i-1);
    y_ori(i,1)=(6*x_ori(i,1)-2)^2*sin(12*x_ori(i,1)-4);
end

%Sample points
x_sample=[0;0.22;0.39;0.63;0.86;1];
y_sample=zeros(6,1);
for i=1:6;
    y_sample(i,1)=(6*x_sample(i,1)-2)^2*sin(12*x_sample(i,1)-4);
end

%Kriging model based on 6 Sample points
theta=0.5;
lob=1e-1;
upb=1;
[dmodel,perf]=dacefit(x_sample, y_sample,@regpoly1,@corrspline,theta,lob,upb);
X_kriging = gridsamp([0;1], 1001);
[YX_kriging MSE_kriging] = predictor(X_kriging, dmodel);


figure(1)
plot(X_kriging,YX_kriging,'--','LineWidth',2)
hold all
plot(x_ori,y_ori,'-','LineWidth',2)
hold all
plot(x_sample,y_sample,'o','LineWidth',2')
hold all
legend('Kriging model','Original Function','Sample points')
title('Original function and Kriging model mean predictor');
xlabel('x');
ylabel('y');
axis([0 1 -8 18])
hold off
MSE_kriging_sqrt=zeros(1001,1);
for i=1:1001;
    MSE_kriging_sqrt(i,1)=sqrt(MSE_kriging(i,1));
end
figure(2)
plot(X_kriging,MSE_kriging_sqrt)
legend('Variance(G)')
title('Response STDs of different uncertainty situations(Kriging model)');
xlabel('x');
ylabel('y');
axis([0 1 0 10])

save model_mean_predictor.mat