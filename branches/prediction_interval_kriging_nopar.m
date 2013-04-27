%Concurrent treatment of parametric uncertainty and meta-modeling
%uncertainty in robust design��Section4.1 �����о�
clc
clear
%Robust objective functions of different scenarios
%f1:Kring ����ģ�ͣ�ֻ���ǲ����Ĳ�ȷ����

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

%ʹ��Krigingģ�ͣ�ֻ���Ǳ���x�Ĳ�ȷ����
x_pridiction_kring_nopar=zeros(1001,1);
y_pridiction_kring_nopar=zeros(1001,1);%��ֵ
y_pridiction_kring_nopar_variance=zeros(1001,1);%����
y_pridiction_kring_nopar_variance_sqrt=zeros(1001,1);
for i=1:1001
    x_pridiction_kring_nopar(i,1)=0.001*(i-1);
    y_pridiction_kring_nopar(i,1)=0;
    %�����������x�����������������ʷֲ������������ʷֲ��ֽ�Ϊ��ɢ���ʷֲ�
    w_rand=random('norm',0,0.07,[1000,1]);
    %ÿ����Ƶ㴦��ֵ����
    
    xw_rand=zeros(1000,1);
    for j=1:1000;
        xw_rand(j,1)=x_pridiction_kring_nopar(i,1)+ w_rand(j,1);
    end
    
    [YX_kriging_nopar MSE_kriging_nopar] = predictor(xw_rand, dmodel);
    for j=1:1000;
        y_pridiction_kring_nopar(i,1)= y_pridiction_kring_nopar(i,1)+YX_kriging_nopar(j,1);
    end
    y_pridiction_kring_nopar(i,1)=y_pridiction_kring_nopar(i,1)./1000;
    
    %ÿ����Ƶ㴦�������
    y_pridiction_kring_nopar_variance(i,1)=0;
    y_pridiction_kring_nopar_variance_test=0;
    for j=1:1000;
         y_pridiction_kring_nopar_variance_test= y_pridiction_kring_nopar_variance_test+YX_kriging_nopar(j,1)^2;
    end
    y_pridiction_kring_nopar_variance(i,1)=y_pridiction_kring_nopar_variance_test./1000- y_pridiction_kring_nopar(i,1)^2;
end
for i=1:1001;
    y_pridiction_kring_nopar_variance_sqrt(i,1)=sqrt(y_pridiction_kring_nopar_variance(i,1));
end

figure(2)
plot(x_pridiction_kring_nopar,y_pridiction_kring_nopar,'-','LineWidth',2)
hold all
plot(x_pridiction_kring_nopar,y_pridiction_kring_nopar+1.96*y_pridiction_kring_nopar_variance_sqrt,'--','LineWidth',2)
hold all
plot(x_pridiction_kring_nopar,y_pridiction_kring_nopar-1.96*y_pridiction_kring_nopar_variance_sqrt,'--','LineWidth',2)
hold all
legend('mean(w)','95%PI','95%PI')
title('Evaluation the 95% prediction interval of the response(parameter uncertainty under Kringing model)');
xlabel('x');
ylabel('y');
axis([0 1 -20 30])

figure(3)
plot(x_pridiction_kring_nopar,y_pridiction_kring_nopar_variance_sqrt)
legend('Variance(w)')
title('Response STDs of different uncertainty situations(parameter uncertainty under Kringing model)');
xlabel('x');
ylabel('y');
axis([0 1 0 10])

save prediction_interval_kring_nopar.mat