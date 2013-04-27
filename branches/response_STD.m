%Concurrent treatment of parametric uncertainty and meta-modeling
%uncertainty in robust design中Section4.1 例子研究

%Response STDs of differents uncertainty situations
clc
clear

load model_mean_predictor.mat

load prediction_interval_kriging.mat
load prediction_interval_parametric_uncertainty.mat

figure(1)
plot(X_kriging,MSE_kriging_sqrt)
hold all
plot(x_pridiction_ori,y_pridiction_ori_variance_sqrt)
hold all
plot(x_pridiction_krig,y_pridiction_krig_variance_sqrt)
legend('Variance(G)','Variance(w)','Variance(G+w)')
title('Response STDs of different uncertainty situations');
xlabel('x');
ylabel('y');
axis([0 1 0 8])



