%===============================================
% Controllers with Hinf mixed sensitivity design
%===============================================
% Uses the Mu-toolbox

%% System
s=tf('s');
G=4/((s-1)*(0.02*s+1)^2);
wc=sqrt((4^2-1)/(1^2)); % crossover frequency 

M=1.5;
wb=wc;
A=1e-4;

%% S/SK H∞
K0=[1,1]; % initial guess for Kp, Ki
lower_limit=[0,0];
upper_limit=[100,100];

options=optimoptions('fminimax','Display','iter','TolFun',1e-4);

%% 1. (2.72)/page 58
Wp1=(s/M+wb)/(s+wb*A);
Wu1=1;

objective1=@(K) [
    norm(Wp1*feedback(1,G*(K(1)+K(2)/s)),inf);              % ‖Wp1·S‖∞, S = GK, K = Kp + Ki/s
    norm(Wu1*(K(1)+K(2)/s)*feedback(1,G*(K(1)+K(2)/s)),inf) % ‖Wu1·K·S‖∞
];

[optimal_K1,fval1]=fminimax(objective1,K0,[],[],[],[],lower_limit,upper_limit,[],options);

Kp1=optimal_K1(1);
Ki1=optimal_K1(2);
K1=Kp1+Ki1/s;

[z,p,k]=zpkdata(K1);
fprintf('K1(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

L1=G*K1;
S1=1/(L1+1);
T1=1-S1;

time=0:0.01:6;
yr1=step(T1,time);
ur1=step(K1*S1,time);

%% 2. (2.73)/page 58
Wp2 = (s/sqrt(M)+wb)^2/(s+wb*sqrt(A))^2;
Wu2 = 1;

objective2=@(K) [
    norm(Wp2*feedback(1,G*(K(1)+K(2)/s)),inf);              % ‖Wp2·S‖∞, S = GK, K = Kp + Ki/s
    norm(Wu2*(K(1)+K(2)/s)*feedback(1,G*(K(1)+K(2)/s)),inf) % ‖Wu2·K·S‖∞
];

[optimal_K2,fval2]=fminimax(objective2,K0,[],[],[],[],lower_limit,upper_limit,[],options);

Kp2=optimal_K2(1);
Ki2=optimal_K2(2);
K2=Kp2+Ki2/s;

[z,p,k]=zpkdata(K2);
fprintf('K2(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

L2=G*K2;
S2=1/(1+L2);
T2=1-S2;

time=0:0.01:6;
yr2=step(T2,time);
ur2=step(K2*S2,time);

%% Plots in time domain
figure(1);
clf;

subplot(211)
plot(time,yr1,time,yr2,time,ones(size(time)),':')
grid on;
axis([0,6,-6,6]);
xlabel('Time');
ylabel('y');
legend({'$y_{r,1}$','$y_{r,2}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('TRACKING RESPONSE');

subplot(212)
plot(time,ur1,time,ur2,time,zeros(size(time)),':')
grid on;
axis([0,6,-6,6]);
xlabel('Time');
ylabel('u');
legend({'$u_{r,1}$','$u_{r,2}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('TRACKING RESPONSE');

%% Bode
omega=logspace(-2,2,41);

[magS1,~]=bode(S1,omega);
[magS2,~]=bode(S2,omega);

[magT1,~]=bode(T1,omega);
[magT2,~]=bode(T2,omega);

[magL1,~]=bode(L1,omega);
[magL2,~]=bode(L2,omega);

[magWp1,~]=bode(1/Wp1,omega);
[magWp2,~]=bode(1/Wp2,omega);

figure(2)
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

figure(3)
clf;

subplot(211)
loglog(omega,magT1(:),omega,magT2(:),omega,omega./omega,':')
grid on;
axis([0.01,100,0.01,100]);
xlabel('Frequency');
ylabel('T');
legend({'$T_1$','$T_2$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('COMPLEM. SENSITIVITY FUNCTION (T)');

subplot(212)
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

%% GM, PM, ωc, M_S and M_T
[GM1, PM1, Wcg1, Wcp1] = margin(L1);
fprintf('\n> GM (L1): %.2f (%.2f dB) at %.2f rad/s\n', GM1, 20*log10(GM1), Wcg1);
fprintf('> PM (L1): %.2f deg at %.2f rad/s\n', PM1, Wcp1);
fprintf('> M_S1: %.2f\n', max(magS1(:)));
fprintf('> M_T1: %.2f\n', max(magT1(:)));

[GM2, PM2, Wcg2, Wcp2] = margin(L2);
fprintf('\n> GM (L2): %.2f (%.2f dB) at %.2f rad/s\n', GM2, 20*log10(GM2), Wcg2);
fprintf('> PM (L2): %.2f deg at %.2f rad/s\n', PM2, Wcp2);
fprintf('> M_S2: %.2f\n', max(magS2(:)));
fprintf('> M_T2: %.2f\n', max(magT2(:)));


