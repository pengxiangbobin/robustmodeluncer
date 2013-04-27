%Concurrent treatment of parametric uncertainty and meta-modeling
%uncertainty in robust design��Section4.1 �����о�

%Evaluating the 95% prediction interval of the response(Two sources of uncertainties)
%����Kriging����ģ�͵Ĳ�ȷ���Ժͱ�����ȷ����
clc
clear

%ʹ�þ�ȷ��ѧģ��Ϊf(x)��ֻ���Ǳ���x�Ĳ�ȷ����
x_pridiction_ori=zeros(1001,1);
y_pridiction_ori=zeros(1001,1);
y_pridiction_ori_variance=zeros(1001,1);
y_pridiction_ori_variance_sqrt=zeros(1001,1);
for i=1:1001
    x_pridiction_ori(i,1)=0.001*(i-1);
    y_pridiction_ori(i,1)=0;
    %�����������x�����������������ʷֲ������������ʷֲ��ֽ�Ϊ��ɢ���ʷֲ�
    w_rand=random('norm',0,0.07,[1000,1]);
    %ÿ����Ƶ㴦��ֵ����
    for j=1:1000;
        zhongjian_bianliang=(6*(x_pridiction_ori(i,1)+w_rand(j,1))-2)^2*sin(12*(x_pridiction_ori(i,1)+w_rand(j,1))-4);
        y_pridiction_ori(i,1)= y_pridiction_ori(i,1)+zhongjian_bianliang;
    end
    y_pridiction_ori(i,1)=y_pridiction_ori(i,1)./1000;
    
    %ÿ����Ƶ㴦�������
    y_pridiction_ori_variance(i,1)=0;
    y_pridiction_ori_variance_test=0;
    for j=1:1000;
        zhongjian_bianliang=((6*(x_pridiction_ori(i,1)+w_rand(j,1))-2)^2*sin(12*(x_pridiction_ori(i,1)+w_rand(j,1))-4))^2;
        y_pridiction_ori_variance_test=y_pridiction_ori_variance_test+zhongjian_bianliang;
    end
    y_pridiction_ori_variance(i,1)=y_pridiction_ori_variance_test./1000- y_pridiction_ori(i,1)^2;
end






%Step 1:����Kriging����ģ��
%Step 1.1    Sample points
x_sample=[0;0.22;0.39;0.63;0.86;1];
y_sample=zeros(6,1);
for i=1:6;
    y_sample(i,1)=(6*x_sample(i,1)-2)^2*sin(12*x_sample(i,1)-4);
end

%Step 1.2     Kriging model based on 6 Sample points
theta=0.5;
lob=1e-1;
upb=1;
[dmodel,perf]=dacefit(x_sample, y_sample,@regpoly1,@corrspline,theta,lob,upb);

%X_kriging = gridsamp([0;1], 1001);
%[YX_kriging MSE_kriging] = predictor(X_kriging, dmodel);

%Step 2:
x_pridiction_krig=zeros(1001,1);
y_pridiction_krig_mean=zeros(1001,1);%��ֵ
y_pridiction_krig_mean_test=zeros(1001,1);%��ֵ
y_pridiction_krig_variance=zeros(1001,1);%����
y_pridiction_krig_variance_sqrt=zeros(1001,1);%
y_pridiction_krig_variance_test=zeros(1001,1);
for i=1:1001
    x_pridiction_krig(i,1)=0.001*(i-1);
    y_pridiction_krig_mean_test(i,1)=0;
    y_pridiction_krig_variance_test(i,1)=0;
    %�����������x�����������������ʷֲ������������ʷֲ��ֽ�Ϊ��ɢ���ʷֲ�
    w_rand=random('norm',0,0.07,[1000,1]);
    xw_rand=zeros(1000,1);
    for j=1:1000
        xw_rand(j,1)=x_pridiction_krig(i,1)+w_rand(j,1);
    end
    %ÿ����Ƶ㴦��ֵ����
    [YX_kriging MSE_kriging] = predictor(xw_rand, dmodel);
    for j=1:1000
        y_pridiction_krig_mean_test(i,1)=y_pridiction_krig_mean_test(i,1)+YX_kriging(j,1);
        y_pridiction_krig_variance_test(i,1)=y_pridiction_krig_variance_test(i,1)+MSE_kriging(j,1);
    end
    
    y_pridiction_krig_mean(i,1)=y_pridiction_krig_mean_test(i,1)./1000;
    y_pridiction_krig_variance(i,1)=y_pridiction_krig_variance_test(i,1)./1000+y_pridiction_ori_variance(i,1);
end

for i=1:1001;
    y_pridiction_krig_variance_sqrt(i,1)=sqrt(y_pridiction_krig_variance(i,1));
end


figure(2)
plot(x_pridiction_krig,y_pridiction_krig_mean,'-','LineWidth',2)
hold all
plot(x_pridiction_krig,y_pridiction_krig_mean+1.96*y_pridiction_krig_variance_sqrt,'--','LineWidth',2)
hold all
plot(x_pridiction_krig,y_pridiction_krig_mean-1.96*y_pridiction_krig_variance_sqrt,'--','LineWidth',2)
hold all
legend('mean(G+w)','95%PI','95%PI')
title('Evaluation the 95% prediction interval of the response(Two sources of uncertainty)');
xlabel('x');
ylabel('y');
axis([0 1 -20 30])

figure(3)
plot(x_pridiction_krig,y_pridiction_krig_variance_sqrt)
legend('Variance(G+w)')
title('Response STDs of different uncertainty situations(Two sources of uncertainty)');
xlabel('x');
ylabel('y');
axis([0 1 0 10])

save prediction_interval_kriging.mat
