clc;

s = tf('s');
G = (1/(10*s+1)) * [1 -0.9; 7 2];
K = ((10*s+1)/(10*s)) * [1 0; 0 0.5];
I = eye(2);
S = inv(I + G*K);

w = logspace(-2,2,1000);

max_sv = zeros(size(w));
for k = 1:length(w)
    Sjw = freqresp(S, w(k)); % S(jω) on ω(k)
    Sjw = squeeze(Sjw);
    Sigma = svd(Sjw);        % Σ
    max_sv(k) = max(Sigma);  % first element of Σ, which is the max singular value
end

[Hinf_norm, f] = max(max_sv);
peak_freq = w(f);

disp(['H-infinity norm: ', num2str(Hinf_norm)]);
disp(['Peak frequency (rad/s): ', num2str(peak_freq)]);

figure;
semilogx(w, max_sv);
xlabel('ω (rad/s)');
ylabel('Magnitude');
grid on;
