clc;

s = tf('s');
G = (1/(10*s+1)) * [1 -0.9; 7 2];
K = ((10*s+1)/(10*s)) * [1 0; 0 0.5];
I = eye(2);
w = logspace(-2,2,1000);

max_sv = zeros(1, length(w));
U_all = cell(1, length(w));
Sigma_all = cell(1, length(w));
V_all = cell(1, length(w));

for k = 1:length(w)
    Gjw = freqresp(G, w(k)); % G(jω) on ω(k)
    Gjw = squeeze(Gjw);

    [U, Sigma, V] = svd(Gjw); % Σ
    
    max_sv(k) = Sigma(1,1);
    
    U_all{k} = U;
    Sigma_all{k} = Sigma;
    V_all{k} = V;
end

[Hinf_norm, i] = max(max_sv);
peak_freq = w(i);

U_max = U_all{i};
Sigma_max = Sigma_all{i};
V_max = V_all{i};

disp(['H-infinity norm: ', num2str(Hinf_norm)]);
disp(['Peak frequency (rad/s): ', num2str(peak_freq)]);

disp('U:');
disp(U_max);
disp('Σ:');
disp(Sigma_max);
disp('V:');
disp(V_max);

figure;
semilogx(w, max_sv);
xlabel('ω (rad/s)');
ylabel('Maximum Singular Value');
grid on;
