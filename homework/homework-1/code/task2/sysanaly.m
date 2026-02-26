% System analysis for loop-shaping examples

L=G*K;
S=1/(1+L);
T=1-S;

time=0:0.01:3;                  % time
u=step(K*S,time);               % controller response to step input
y=step(T,time);                 % step response (y = Tr)
yd=step(S*Gd,time);             % step disturbance response

Ymax=max(yd);                   % max disturbance response
Y3=yd(length(yd));              % disturbance response at time t = 3sec

k=length(y);                    % length of system response (y)

% Overshoot
Ov=max([y;1]);[x,x,x,tr]=margin(y(2:k)/0.9,y(2:k),time(2:k));

% Infinite Norms
MT=norm(T,inf,1e-4);
MS=norm(S,inf,1e-4);

% Bode Analysis
[Gm,Pm,W180,Wc]=margin(L);
