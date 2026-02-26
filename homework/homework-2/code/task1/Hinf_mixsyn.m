%===============================================
% Controllers with Hinf mixed sensitivity design
%===============================================

%% System
s=tf('s');
G=(s-1)/(s+1)^2;

A=1e-10;
Wp=(0.5*s+1)/(s+A);
Wu=1;

[K,~,gopt]=mixsyn(G,Wp,Wu);
K=tf(K);

[z,p,k]=zpkdata(K);
fprintf('K(s)=')
zpk(z,p,k,'DisplayFormat','time constant')

L=G*K;
S=1/(1+L);
WpS = Wp*S;

%% Bode
omega=logspace(-2,2,41);

[magS,~]=bode(S,omega);
[mag1_Wp,~]=bode(1/Wp,omega);
[magWpS,~]=bode(WpS,omega);

figure(1)
clf;

subplot(211)
loglog(omega,magS(:),'-',omega,mag1_Wp(:),'--',omega,omega./omega,':')
grid on;
axis([0.01,100,0.01,100]);
xlabel('Frequency');
ylabel('S,1/W_p');
legend({'$S$','$1/W_{p}$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('SENSITIVITY FUNCTION (S)');

subplot(212)
loglog(omega,magWpS(:),'-',omega,omega./omega,':')
grid on;
axis([0.01,100,0.01,100]);
xlabel('Frequency');
ylabel('W_pS');
legend({'$W_pS$'}, 'Interpreter', 'latex', 'Location', 'northeast');
title('WEIGHTED SENSITIVITY (W_pS)');

%% H∞-norm of S
[ninfS,fpeakS] = hinfnorm(S);
[ninfWpS,fpeakWpS] = hinfnorm(WpS);
fprintf('> H∞-norm of WpS: %.4f\n', ninfWpS);
fprintf('> Frequency of the peak gain of WpS: %.4f rad/sec\n\n', fpeakWpS);
