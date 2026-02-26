%================================================================
% Controllers for disturbance rejection, designed by loop-shaping
%================================================================

%% System
s=tf('s');
Gd=90/(8*s+1);
G=180/((8*s+1)*((0.04*s+1)^2));
wc=sqrt((90^2-1)/(8^2)); % crossover frequency

K1=0.5;
K2=K1*(s+0.2*wc)/s;
K3=K2*(0.05*s+1)/(0.005*s+1);
omega=logspace(-2,2,41);

disp(sprintf('%6s%6s%6s%6s%6s%6s%11s%13s','','','','','','',...
    'Reference','Disturbance'));
disp(sprintf('%4s%6s%6s%6s%6s%6s%6s%6s%7s%7s','','GM','PM',...
    'Wc','Ms','Mt','tr','Ov','Ymax','Yd(3)'));

%% 1. P controller
K=K1;
sysanaly;
[mag1,pha1]=bode(L,omega);
yd1=yd;
yr1=y;
u1=u;
disp(sprintf('%4s%7.2f%6.1f%6.2f%6.2f%6.2f%6.2f%6.2f%6.2f%7.2f',...
    'K1',Gm,Pm,Wc,MS,MT,tr,Ov,Ymax,Y3));

%% 2. PI controller
K=K2;
sysanaly;
[mag2,pha2]=bode(L,omega);
yd2=yd;
yr2=y;
u2=u;
disp(sprintf('%4s%7.2f%6.1f%6.2f%6.2f%6.2f%6.2f%6.2f%6.2f%7.3f',...
    'K2',Gm,Pm,Wc,MS,MT,tr,Ov,Ymax,Y3));

%% 3. PID controller
K=K3;
sysanaly;
[mag3,pha3]=bode(L,omega);
yd3=yd;
yr3=y;
u3=u;
disp(sprintf('%4s%7.1f%6.1f%6.2f%6.2f%6.2f%6.2f%6.2f%6.2f%7.3f',...
    'K3',Gm,Pm,Wc,MS,MT,tr,Ov,Ymax,Y3));

%% Plots in time domain
figure(2)
clf;

subplot(221)
plot(time,yr1,time,yr2,time,yr3,time,time*0,':')
grid on;
axis([0,3,-0.2,1.5]);
xlabel('Time');
ylabel('y');
legend({'$y_{r,1}$','$y_{r,2}$','$y_{r,3}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('TRACKING RESPONSE');

subplot(222)
plot(time,yd1,time,yd2,time,yd3,time,time*0,':')
grid on;
axis([0,3,-0.2,1.5]);
xlabel('Time');
ylabel('y');
legend({'$y_{d,1}$','$y_{d,2}$','$y_{d,3}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('DISTURBANCE RESPONSE');

subplot(223)
plot(time,u1,time,u2,time,u3,time,time*0,':')
grid on;
axis([0,3,-1,10]);
xlabel('Time');
ylabel('u');
legend({'$u_1$','$u_2$','$u_3$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('TRACKING RESPONSE');

%% Bode
subplot(224)
loglog(omega,mag1(:),omega,mag2(:),omega,mag3(:),omega,omega./omega,':')
grid on;
axis([0.01,100,0.01,10000]);
legend({'$L_1$','$L_2$','$L_3$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('LOOP GAIN');