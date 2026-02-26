clc; clear;

s = tf('s');
G = (1/(10*s+1)) * [1 -0.9; 7 2];
K = ((10*s+1)/(10*s)) * [1 0; 0 0.5];
I = eye(2);
L = G*K;
S = inv(I+L);
T = I-S;

w = logspace(-2,2,1000);

max_sv = 0;
eigenvector = zeros(2,1);

for k = 1:length(w)
    Sjw = freqresp(S, w(k));
    Sjw = squeeze(Sjw);
    [U, Sigma, V] = svd(Sjw);
    
    if Sigma(1,1) > max_sv
        max_sv = Sigma(1,1);
        eigenvector = V(:,1);
        U_max = U;
        Sigma_max = Sigma;
        V_max = V;
    end
    
end

% SVD analysis
disp('U:')
disp(U_max)
disp('Σ:')
disp(Sigma_max)
disp('V:')
disp(V_max)

[Sinf_norm, index] = max(max_sv);
peak_freq = w(index);
disp(['Max Singular Value:', num2str(Sinf_norm)])
disp(['Peak frequency (rad/s): ', num2str(peak_freq)]);

disp('Eigenvector:')
disp(eigenvector)

t = linspace(0, 20, 1000);
r = real(eigenvector * exp(1j*peak_freq*t)); % r(t) = eigenvector*·e^{jω*t} ---> Nx2
r = r'; % ---> 2xN

[y,~,~] = lsim(T, r, t);                     % y(s)/r(s) = T(s) => y(s) = T(s)*r(s)
e = r-y;                                     % e(t) = r(t) - y(t)

normalized_eigenvector = eigenvector/norm(max(e));
disp('Normalized direction of reference input:');
disp(normalized_eigenvector);

figure;
subplot(3,1,1);
plot(t, r);
xlabel('t (sec)');
ylabel('r');
% title('Reference input: r(t)');
legend('r_1(t)','r_2(t)');
grid on;

subplot(3,1,2);
plot(t, y);
xlabel('t (sec)');
ylabel('y');
% title('System output: y(t)');
legend('y_1(t)','y_2(t)');
grid on;

subplot(3,1,3);
plot(t, e);
xlabel('t (sec)');
ylabel('e');
% title('Tracking error: e(t)');
legend('e_1(t)','e_2(t)');
grid on;
