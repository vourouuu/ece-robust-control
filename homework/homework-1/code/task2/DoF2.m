%=====================================================================================
% Controllers for disturbance rejection and command tracking 2DoFs loop-shaping design
%=====================================================================================

%% System
s=tf('s');
Gd=90/(8*s+1);
G=180/((8*s+1)*((0.04*s+1)^2));
wc=sqrt((90^2-1)/(8^2)); % crossover frequency            

K0=(wc/s)*(((8*s+1)*(0.08*s+1))/(180*(0.007*s+1))); % inverse based controller
K1=0.5;                                             % P controller
K2=K1*(s+0.2*wc)/s;                                 % PI controller
K3=K2*(0.05*s+1)/(0.005*s+1);                       % PID controller
Ky = K3;

L=G*Ky;             % transfer function of open-loop system
T=minreal(L/(1+L)); % complementary sensitivity function
S=1-T;              % sensitivity function

%% Transfer Functions
% T(s)
[z,p,k]=zpkdata(T);
fprintf('T(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

% Simplified T(s)
T_simple=(0.4445*s+1)/((0.346*s+1)*(1.587*(0.05478*s)+1));
[z,p,k]=zpkdata(T_simple);
fprintf('Tsimple(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

% Tref(s)
Tref=1/(0.05*s+1);

% Kr(s): Prefilter for the reference
Kr=Tref/T;
[z,p,k]=zpkdata(Kr);
fprintf('Kr(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

% Simplified Kr(s)
Kr_simple=(1+0.346*s)/((1+0.05*s)*(1+0.4445*s));
[z,p,k]=zpkdata(Kr_simple);
fprintf('Kr,simple(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

%% Tracking Responses
T_2DoF=T_simple*Kr_simple;  
time=0:0.01:3;
k=length(time);

ur=step(Ky*S,time);
ur_2DoF=step(Ky*S*Kr_simple,time);

yr=step(T,time);               % without prefilter controller Kr (1 DoF) - with T
yr_simple=step(T_simple,time); % without prefilter controller Kr (1 DoF) - with T_simple
yr_2DoF=step(T_2DoF,time);     %    with prefilter controller Kr (2 DoF) - with T_simple and Kr_simple

Ov=max([yr;1]);
[x,x,x,Tr]=margin(yr(2:k)/0.9,yr(2:k),time(2:k));
Ov_2DoF=max([yr_2DoF;1]);
[x,x,x,Tr_2DoF]=margin(yr_2DoF(2:k)/0.9,yr_2DoF(2:k),time(2:k));

fprintf(sprintf('[Ov tr Ov_2DoF tr_2DoF]=[%5.2f%5.2f%5.2f%5.2f ]',Ov,Tr,Ov_2DoF,Tr_2DoF));

%% Plots in time domain
figure(3);
clf;

subplot(211);
plot(time,[yr,yr_simple,yr_2DoF],[0,3],[1,1],':')
grid on;
axis([0,3,-0.1,1.5]);
xlabel('Time');
ylabel('y');
legend({'$y_{r}$','$y_{r,simple}$','$y_{r,2DoF}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('TRACKING RESPONSE');

subplot(212);
plot(time,[ur,ur_2DoF],[0,3],[0,0],':')
grid on;
axis([0,3,-1,1]);
xlabel('Time');
ylabel('u');
legend({'$u_{r}$','$u_{r,2DoF}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('TRACKING RESPONSE');