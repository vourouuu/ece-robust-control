clc;
close all;

s = tf('s');
z_values = 1:0.1:2;
w = logspace(-1, 3, 500);

figure;
for z = z_values
    % G = 2 * (s + z) / (8 * s + 1);
    G = (2*z-3)/(2*s+3);
    [mag, ~] = bode(G, w);
    mag = squeeze(mag);
    loglog(w, mag, 'DisplayName', sprintf('z = %.1f', z));
    hold on;
end
wI = 1.1/(2*s+3);
[magwI, ~] = bode(wI, w);
magwI = squeeze(magwI);
loglog(w, magwI, ':', 'DisplayName', sprintf('w_I(s)'));
xlabel('Frequency');
ylabel('Magnitude');
grid on;
legend show;