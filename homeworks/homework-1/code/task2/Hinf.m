%===============================================
% Controllers with Hinf mixed sensitivity design
%===============================================

%% System
s=tf('s');
Gd=90/(8*s+1);
G=180/((8*s+1)*((0.04*s+1)^2));
wc=sqrt((90^2-1)/(8^2)); % crossover frequency 

M=1.5;
wb=wc;
A=1e-4;

%% 1. (2.72)/page 58
Wp1 = (s/M+wb)/(s+wb*A);
Wu1 = 1;

[Kinf1,~,gopt1]=mixsyn(G,Wp1,Wu1);
Kinf1=tf(Kinf1);

[z,p,k]=zpkdata(Kinf1);
fprintf('Kinf1(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

L1=G*Kinf1;
S1=1/(1+L1);
T1=1-S1;
Td1=S1*Gd;

time=0:0.01:3;
yr1=step(T1,time);
yd1=step(S1*Gd,time);
ur1=step(Kinf1*S1,time);
ud1=step(-Kinf1*S1*Gd,time);

%% 2. (2.73)/page 58
Wp2 = (s/sqrt(M)+wb)^2/(s+wb*sqrt(A))^2;
Wu2 = 1;

[Kinf2,~,gopt2]=mixsyn(G,Wp2,Wu2);
Kinf2=tf(Kinf2);

[z,p,k]=zpkdata(Kinf2);
fprintf('Kinf2(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

L2=G*Kinf2;
S2=1/(1+L2);
T2=1-S2;
Td2=S2*Gd;

time=0:0.01:3;
yd2=step(S2*Gd,time);
yr2=step(T2,time);
ud2=step(-Kinf2*S2*Gd,time);
ur2=step(Kinf2*S2,time);

%% Plots in time domain
figure(4);
clf;

subplot(221)
plot(time,yr1,time,yr2,time,ones(size(time)),':')
grid on;
axis([0,3,-0.2,1.5]);
xlabel('Time');
ylabel('y');
legend({'$y_{r,1}$','$y_{r,2}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('TRACKING RESPONSE');

subplot(222)
plot(time,yd1,time,yd2,time,zeros(size(time)),':')
grid on;
axis([0,3,-0.2,1.5]);
xlabel('Time');
ylabel('y');
legend({'$y_{d,1}$','$y_{d,2}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('DISTURBANCE RESPONSE');

subplot(223)
plot(time,ur1,time,ur2,time,zeros(size(time)),':')
grid on;
axis([0,3,-1,1]);
xlabel('Time');
ylabel('u');
legend({'$u_{r,1}$','$u_{r,2}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('TRACKING RESPONSE');

subplot(224)
plot(time,ud1,time,ud2,time,zeros(size(time)),':')
grid on;
axis([0,3,-1,1]);
xlabel('Time');
ylabel('u');
legend({'$u_{d,1}$','$u_{d,2}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('DISTURBANCE RESPONSE');

%% Bode
omega=logspace(-2,2,41);

[magS1,~]=bode(S1,omega);
[magS2,~]=bode(S2,omega);

[magT1,~]=bode(T1,omega);
[magT2,~]=bode(T2,omega);

[magTd1,~] = bode(Td1,omega);
[magTd2,~] = bode(Td2,omega);

[magL1,~]=bode(L1,omega);
[magL2,~]=bode(L2,omega);

[magWp1,~]=bode(1/Wp1,omega);
[magWp2,~]=bode(1/Wp2,omega);

figure(5)
clf;

subplot(211)
loglog(omega,magS1(:),'-',omega,magWp1(:),'--',omega,omega./omega,':')
grid on;
axis([0.01,100,0.01,100]);
xlabel('Frequency');
ylabel('S');
legend({'$S_1$','$1/W_{p,1}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('SENSITIVITY FUNCTION (S)');

subplot(212)
loglog(omega,magS2(:),'-',omega,magWp2(:),'--',omega,omega./omega,':')
grid on;
axis([0.01,100,0.01,100]);
xlabel('Frequency');
ylabel('S');
legend({'$S_2$','$1/W_{p,2}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('SENSITIVITY FUNCTION (S)');

figure(6)
clf;

subplot(221)
loglog(omega,magT1(:),omega,magT2(:),omega,omega./omega,':')
grid on;
axis([0.01,100,0.01,100]);
xlabel('Frequency');
ylabel('T');
legend({'$T_1$','$T_2$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('COMPLEM. SENSITIVITY FUNCTION (T)');

subplot(222)
loglog(omega,magTd1(:),omega,magTd2(:),omega,omega./omega,':')
grid on;
axis([0.01,100,0.01,100]);
xlabel('Frequency');
ylabel('T');
legend({'$T_{d,1}$','$T_{d,2}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('DISTURB. SENSITIVITY FUNCTION (T_d)');

subplot(223)
loglog(omega,magL1(:),omega,magL2(:),omega,omega./omega,':')
grid on;
axis([0.01,100,0.01,100]);
xlabel('Frequency');
ylabel('L');
legend({'$L_1$','$L_2$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('LOOP GAIN (L)');

%% H∞-norm of S
[ninfS1,fpeakS1] = hinfnorm(S1);
fprintf('> H∞-norm of S1: %.4f\n', ninfS1);
fprintf('> Frequency of the peak gain of S1: %.4f rad/sec\n\n', fpeakS1);

[ninfS2,fpeakS2] = hinfnorm(S2);
fprintf('> H∞-norm of S2: %.4f\n', ninfS2);
fprintf('> Frequency of the peak gain of S2: %.4f rad/sec\n\n', fpeakS2);

%% H∞-norm of T
[ninfT1,fpeakT1] = hinfnorm(T1);
fprintf('> H∞-norm of T1: %.4f\n', ninfT1);
fprintf('> Frequency of H∞-norm of T1: %.4f rad/sec\n\n', fpeakT1);

[ninfT2,fpeakT2] = hinfnorm(T2);
fprintf('> H∞-norm of T2: %.4f\n', ninfT2);
fprintf('> Frequency of H∞-norm of T2: %.4f rad/sec\n', fpeakT2);

%% GM and PM
[Gm1, Pm1, Wcg1, Wcp1] = margin(L1);
fprintf('\n> GM (L1): %.2f (%.2f dB) at %.2f rad/s\n', Gm1, 20*log10(Gm1), Wcg1);
fprintf('> PM (L1): %.2f deg at %.2f rad/s\n', Pm1, Wcp1);

[Gm2, Pm2, Wcg2, Wcp2] = margin(L2);
fprintf('\n> GM (L2): %.2f (%.2f dB) at %.2f rad/s\n', Gm2, 20*log10(Gm2), Wcg2);
fprintf('> PM (L2): %.2f deg at %.2f rad/s\n', Pm2, Wcp2);
