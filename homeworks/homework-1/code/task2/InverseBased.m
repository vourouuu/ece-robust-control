%============================================================
% Controller for command following (which inverts the plant)
%============================================================

%% System
s=tf('s');
Gd=90/(8*s+1);
G=180/((8*s+1)*((0.04*s+1)^2));
wc=sqrt((90^2-1)/(8^2)); % crossover frequency

K0=(wc/s)*(((8*s+1)*(0.08*s+1))/(180*(0.007*s+1)));

L0=K0*G;
S0=1/(1+L0);
T0=1-S0;
SGd=S0*Gd;

%% Transfer Functions
[z,p,k]=zpkdata(K0);
fprintf('K0(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

[z,p,k]=zpkdata(L0);
fprintf('L0(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

[z,p,k]=zpkdata(S0);
fprintf('S0(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

[z,p,k]=zpkdata(T0);
fprintf('T0(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

[z,p,k]=zpkdata(SGd);
fprintf('S0*Gd(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

%% Tracking and Disturbance Responses
time=0:0.01:3;
u=ones(size(time));
yr=lsim(T0,u,time);
yd=lsim(SGd,u,time);
ur=lsim(K0*S0,u,time);
ud=lsim(-K0*SGd,u,time);

%% Plots in time domain
figure(1);
clf;

subplot(221)
plot(time,yr,time,u,':')
grid on;
axis([0,3,-0.2,1.5]);
xlabel('Time');
ylabel('y');
legend({'$y_{r}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('TRACKING RESPONSE');

subplot(222)
plot(time,yd,time,time*0,':')
grid on;
axis([0,3,-0.2,1.5]);
xlabel('Time');
ylabel('y');
legend({'$y_{d}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('DISTURBANCE RESPONSE');

subplot(223)
plot(time,ur,time,u,':')
grid on;
axis([0,3,-1,10]);
xlabel('Time');
ylabel('u');
legend({'$u_{r}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('TRACKING RESPONSE');

subplot(224)
plot(time,ud,time,time*0,':')
grid on;
axis([0,3,-1,10]);
xlabel('Time');
ylabel('u');
legend({'$u_{d}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('DISTURBANCE RESPONSE');