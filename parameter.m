% variable used: nn, r, mu, t0, pl, tdp , gain, backgain

% nn---number of RCIs
% rr ---motor neuron input
% mu --Intrasegmental connection strength
% t0---Intrinsic time constant
% pl---projection length
% tdp--time deplay per segment
% delta, eta ---strength ratio

  

tmax=20;
%   time=linspace(0,tmax,nsmpl)';

nn=17;
rr=0.3*ones(nn,1); 
mu=6;
t0=ones(nn,1)*0.200; 	% intrinsic time constant is 200 ms uniformaly for all segments
ee=30;
pl=5;
td=0.015;		% time delay per segment is 15 ms
delta=0.01;
eta=2;

