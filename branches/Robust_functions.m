%Concurrent treatment of parametric uncertainty and meta-modeling
%uncertainty in robust design��Section4.1 �����о�

%Robust objective functions of different scenarios
%f1:Kring ����ģ�ͣ�ֻ���ǲ����Ĳ�ȷ����
%f2��Kring����ģ�ͣ�����ģ�Ͳ�ȷ���Ͳ�����ȷ����
%f3����ʵ��ѧģ�ͣ����ǲ�����ȷ����

clc
clear


load prediction_interval_kriging.mat
load prediction_interval_parametric_uncertainty.mat
load prediction_interval_kring_nopar.mat

[C_kring_nopar,I_kring_nopar] = min(y_pridiction_kring_nopar+3*y_pridiction_kring_nopar_variance_sqrt);
[C_kring,I_kring] = min(y_pridiction_krig_mean+3*y_pridiction_krig_variance_sqrt);
[C_ori,I_ori] = min(y_pridiction_ori+3*y_pridiction_ori_variance_sqrt);

figure(1)
plot(x_pridiction_kring_nopar,y_pridiction_kring_nopar+3*y_pridiction_kring_nopar_variance_sqrt,'-','LineWidth',2)
hold all
plot(x_pridiction_krig,y_pridiction_krig_mean+3*y_pridiction_krig_variance_sqrt,'-','LineWidth',2)
hold all
plot(x_pridiction_ori,y_pridiction_ori+3*y_pridiction_ori_variance_sqrt,'-','LineWidth',2)
hold all

plot(x_pridiction_kring_nopar(I_kring_nopar,1),y_pridiction_kring_nopar(I_kring_nopar,1)+3*y_pridiction_kring_nopar_variance_sqrt(I_kring_nopar,1),'o','LineWidth',2)
hold all
plot(x_pridiction_krig(I_kring,1),y_pridiction_krig_mean(I_kring,1)+3*y_pridiction_krig_variance_sqrt(I_kring,1),'o','LineWidth',2)
hold all
plot(x_pridiction_ori(I_ori,1),y_pridiction_ori(I_ori,1)+3*y_pridiction_ori_variance_sqrt(I_ori,1),'o','LineWidth',2)
hold all
x_pridiction_kring_nopar(I_kring_nopar,1)
x_pridiction_krig(I_kring,1)
x_pridiction_ori(I_ori,1)


legend('f1(kring w)','f2(kring G+w)','f3(Original w)')
title('Robust objective functions of different scenarios');
xlabel('x');
ylabel('y');
axis([0 1 -5 30])
