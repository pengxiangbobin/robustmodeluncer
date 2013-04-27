%Concurrent treatment of parametric uncertainty and meta-modeling
%uncertainty in robust design��Section4.1 �����о�

%Evaluating the 95% prediction interval of the response(Only parametric uncertainty)
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
for i=1:1001;
    y_pridiction_ori_variance_sqrt(i,1)=sqrt(y_pridiction_ori_variance(i,1));
end
% %���ƾ�ȷ��ֵ����
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