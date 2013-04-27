%Concurrent treatment of parametric uncertainty and meta-modeling
%uncertainty in robust design中Section4.1 例子研究

%Evaluating the 95% prediction interval of the response(Only parametric uncertainty)
clc
clear

%使用精确数学模型为f(x)，只考虑变量x的不确定性
x_pridiction_ori=zeros(1001,1);
y_pridiction_ori=zeros(1001,1);
y_pridiction_ori_variance=zeros(1001,1);
y_pridiction_ori_variance_sqrt=zeros(1001,1);
for i=1:1001
    x_pridiction_ori(i,1)=0.001*(i-1);
    y_pridiction_ori(i,1)=0;
    %产生随机变量x的随机数，表征其概率分布，将连续概率分布分解为离散概率分布
    w_rand=random('norm',0,0.07,[1000,1]);
    %每个设计点处均值计算
    for j=1:1000;
        zhongjian_bianliang=(6*(x_pridiction_ori(i,1)+w_rand(j,1))-2)^2*sin(12*(x_pridiction_ori(i,1)+w_rand(j,1))-4);
        y_pridiction_ori(i,1)= y_pridiction_ori(i,1)+zhongjian_bianliang;
    end
    y_pridiction_ori(i,1)=y_pridiction_ori(i,1)./1000;
    
    %每个设计点处方差计算
    y_pridiction_ori_variance(i,1)=0;
    y_pridiction_ori_variance_test=0;
    for j=1:1000;
        zhongjian_bianliang=((6*(x_pridiction_ori(i,1)+w_rand(j,1))-2)^2*sin(12*(x_pridiction_ori(i,1)+w_rand(j,1))-4))^2;
        y_pridiction_ori_variance_test=y_pridiction_ori_variance_test+zhongjian_bianliang;
    end
    y_pridiction_ori_variance(i,1)=y_pridiction_ori_variance_test./1000- y_pridiction_ori(i,1)^2;
end
for i=1:1001;
    y_pridiction_ori_variance_sqrt(i,1)=sqrt(y_pridiction_ori_variance(i,1));
end
% %绘制精确数值函数
% x_ori=zeros(1001,1);
% y_ori=zeros(1001,1);
% for i=1:1001;
%     x_ori(i,1)=0.001*(i-1);
%     y_ori(i,1)=(6*x_ori(i,1)-2)^2*sin(12*x_ori(i,1)-4);
% end
% 
% figure(1)
% plot(x_pridiction_ori,y_pridiction_ori,'-','LineWidth',2)
% hold all
% plot(x_ori,y_ori,'--','LineWidth',2)
% hold all
% legend('mean(w)','Original Function')
% title('Original function and Kriging model mean predictor');
% xlabel('x');
% ylabel('y');
% axis([0 1 -8 18])
% hold off
figure(2)
plot(x_pridiction_ori,y_pridiction_ori,'-','LineWidth',2)
hold all
plot(x_pridiction_ori,y_pridiction_ori+1.96*y_pridiction_ori_variance_sqrt,'--','LineWidth',2)
hold all
plot(x_pridiction_ori,y_pridiction_ori-1.96*y_pridiction_ori_variance_sqrt,'--','LineWidth',2)
hold all
legend('mean(w)','95%PI','95%PI')
title('Evaluation the 95% prediction interval of the response(Only parameteric uncertainty)');
xlabel('x');
ylabel('y');
axis([0 1 -20 30])

figure(3)
plot(x_pridiction_ori,y_pridiction_ori_variance_sqrt)
legend('Variance(w)')
title('Response STDs of different uncertainty situations(only parameter uncertainty)');
xlabel('x');
ylabel('y');
axis([0 1 0 10])

save prediction_interval_parametric_uncertainty.mat