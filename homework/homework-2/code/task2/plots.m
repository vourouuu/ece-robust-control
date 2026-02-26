clc;

s = tf('s');
z = 1:0.1:2;
G = 2*(s+z)/(8*s+1);
Go = 2*(s+1.5)/(8*s+1);
Wi = 0.5/(s+1.5);

relative_uncertainty = arrayfun(@(zi) ...
    norm((2*(s+zi)/(8*s+1)-Go)/Go, inf), z);

l = max(relative_uncertainty);

% T = Go*inv(1+Go);
% WiT = Wi*T;

omega = logspace(-1, 1, 500);

% [magWi, ~] = bode(Wi, omega);
% magWi = squeeze(magWi);
% 
% [magT, ~] = bode(T, omega);
% magT = squeeze(magT);
% 
% [maginvWi, ~] = bode(1/Wi, omega);
% maginvWi = squeeze(maginvWi);

% figure(1);
% semilogx(omega, magT);
% hold on;
% semilogx(omega, maginvWi, 'r--');
% legend('|T(j\omega)|', '1/|W_I(j\omega)|');
% xlabel('\omega (rad/s)');
% ylabel('Magnitude');
% grid on;
% 
% figure(2);
% semilogx(omega, magWi);
% hold on;
% yline(l, 'r--');
% xlabel('\omega (rad/s)');
% ylabel('Magnitude');
% legend('|W_I(j\omega)|', 'l_I');
% grid on;


figure(3);
hold on;
% semilogx(omega, magWi, 'b');
semilogx(omega, l, 'b');

for zi = z
    Gi = 2*(s + zi)/(8*s + 1);
    [magGi, ~] = bode(Gi, omega);
    magGi = squeeze(magGi);
    semilogx(omega, magGi, 'Color', [0.6 0.6 0.6]);
end

xlabel('\omega (rad/s)');
ylabel('Magnitude');
% legend('|W_I(j\omega)|', '|G(j\omega)| for each z');
legend('l', '|G(j\omega)| for each z');
grid on;