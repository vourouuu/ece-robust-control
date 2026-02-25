clc;
close all;

s = zpk('s');
G11 =    1 * (1/(10*s+1));
G12 = -0.9 * (1/(10*s+1));
G21 =    7 * (1/(10*s+1));
G22 =    2 * (1/(10*s+1));
G = [G11 G12 ; G21 G22];

detG = (G11*G22) - (G12*G21);

p = -83/290;
up = [-0.9657 ; -0.2597];

disp('Pole direction u_p:');
disp(up);

t = 0:0.01:10;
u = up * exp(p*t);
[y, t_out] = lsim(G, u, t);

figure;
subplot(211);
plot(t, u);
title('Input u(t)');
xlabel('Time');
ylabel('u');
legend('u_1(t)', 'u_2(t)');
grid on;

subplot(212);
plot(t_out, y);
title('Output y(t)');
xlabel('Time');
ylabel('y');
legend('y_1(t)', 'y_2(t)');
grid on;