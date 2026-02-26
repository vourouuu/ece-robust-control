clc;
close all;

s = zpk('s');
G11 = (11*s^3-18*s^2-70*s-50)/(s*(s+10)*(s+1)*(s-5));
G12 = (s+2)/((s+1)*(s-5));
G21 = 5*(s+2)/((s+1)*(s-5));
G22 = 5*(s+2)/((s+1)*(s-5));
G = [G11 G12 ; G21 G22];

% u_z1
% z = -1;
% uz = [0.7071 ; -0.7071];

%u_z2
z = -2;
uz = [0; 1];

disp('Zero direction u_z:');
disp(uz);

t = 0:0.01:5;
u1 = uz * exp(z*t);
u2 = 2*u1;
u3 = 3*u1;

[y1, t_out] = lsim(G, u1, t);
[y2, ~] = lsim(G, u2, t);
[y3, ~] = lsim(G, u3, t);

figure(1);
plot(t, u1, t, u2, t, u3);
xlabel('Time');
ylabel('u');
legend('u_{11}(t)', 'u_{12}(t)', 'u_{21}(t)', 'u_{22}(t)', 'u_{31}(t)', 'u_{32}(t)');
grid on;

figure(2);
plot(t_out, y1, t_out, y2, t_out, y3);
xlabel('Time');
ylabel('y');
legend('y_{11}(t)', 'y_{12}(t)', 'y_{21}(t)', 'y_{22}(t)', 'y_{31}(t)', 'y_{32}(t)');
grid on;

idx = find(abs(t_out - 9.54) < 1e-6);

disp('y11(t=9.54) = ')
disp(y1(idx,1))
disp('y12(t=9.54) = ')
disp(y1(idx,2))

disp('> 2 * y11 = ')
disp(2*y1(idx,1))
disp('> 2 * y12 = ')
disp(2*y1(idx,2))

disp('y21(t=9.54) = ')
disp(y2(idx,1))
disp('y22(t=9.54) = ')
disp(y2(idx,2))

disp('> 3 * y11 = ')
disp(3*y1(idx,1))
disp('> 3 * y12 = ')
disp(3*y1(idx,2))

disp('y31(t=9.54) = ')
disp(y3(idx,1))
disp('y32(t=9.54) = ')
disp(y3(idx,2))
