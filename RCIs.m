% 3 link nonholonomic MITA snake
% generate theta that satisfies the nonholonomic 
% constraint for given xidot and etadot where
% xidot=x1dot*cos(theta1)+y1dot*sin(theta1)
% etadot=theta1dot+theta2dot+theta3dot

function [sys,x0,str,ts] = leech(t,x,u,flag,nn,pl,td,gain,backgain,mu,t0,ee)
%pl---projection length
%gain, backgain ---strength ratio
%nn---number of joints
%tdp-time deplay per segment
%
switch flag,

  case 0,
    [sys,x0,str,ts]=InitializeSizes(nn,pl);

  case 1,
    sys=Derivatives(t,x,u,nn,pl,td,gain,backgain,mu,t0,ee);

  case 3,
    sys=Outputs(t,x,u,nn);

  case { 2, 4, 9 }
    sys=[]; % Unused flags

  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end

%t

% end sfuntmpl

% hebi model with velocity input
%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=InitializeSizes(nn,pl)

sizes = simsizes;

sizes.NumContStates  = nn*3+nn*pl*3; %[v, v_inter];
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = nn*3; %[v];
sizes.NumInputs      = nn; % [gating neuron input r(nn)] 
sizes.DirFeedthrough = 1; 
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);
%
% initialize the initial conditions
%
x0=[zeros(3*nn,1);zeros(3*nn*pl,1)];
for i=1:nn
    x0((i-1)*3+1)=1;
end

%
% str is always an empty matrix
%
str = [];
%
% initialize the array of sample times
%
ts  = [0 0];

% end mdlInitializeSizes
%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=Derivatives(t,x,u,nn,pl,td,gain,backgain,mu,t0,ee)

r=u;
v=x(1:3*nn);
v1=v(1:3:3*nn);
v2=v(2:3:3*nn);
v3=v(3:3:3*nn);

vtran1=x(3*nn+1:nn*3+nn*pl);
vtran2=x(3*nn+pl*nn+1:3*nn+pl*nn*2);
vtran3=x(3*nn+pl*nn*2+1:3*nn+pl*nn*3);

for k=1:nn
    iintra1(k)=mu*max(v2(k),0);
    iintra2(k)=mu*max(v3(k),0);
    iintra3(k)=mu*max(v1(k),0);
end

for s=1:pl
    tda=td*s;               % time delay of intersegmental synapse connection
         for k=(s-1)*nn+1:s*nn
            vtrandot1(k)=1/tda*(-vtran1(k)+v((k-(s-1)*nn-1)*3+1));
            vtrandot2(k)=1/tda*(-vtran2(k)+v((k-(s-1)*nn-1)*3+2));
            vtrandot3(k)=1/tda*(-vtran3(k)+v((k-(s-1)*nn-1)*3+3));
        end
end

iinter1=zeros(nn,1); iinter2=zeros(nn,1); iinter3=zeros(nn,1);
for s=1:pl
        for k=(s-1)*nn+1:s*nn-s
            iinter1(k-(s-1)*nn+s)=iinter1(k-(s-1)*nn+s)+mu*max(vtran1(k),0)+(1-r(k-(s-1)*nn+s))*t0(k-(s-1)*nn+s)*max(sign(vtran1(k)),0)*mu*vtrandot1(k);
            iinter2(k-(s-1)*nn)=iinter2(k-(s-1)*nn)+mu*max(vtran2(k+s),0)+(1-r(k-(s-1)*nn))*t0(k-(s-1)*nn)*max(sign(vtran2(k+s)),0)*mu*vtrandot2(k+s);
            iinter3(k-(s-1)*nn)=iinter3(k-(s-1)*nn)+mu*max(vtran3(k+s),0)+(1-r(k-(s-1)*nn))*t0(k-(s-1)*nn)*max(sign(vtran3(k+s)),0)*mu*vtrandot3(k+s);
        end
end

for k=1:nn
    vdot(3*(k-1)+1)=1/(1-r(k))/t0(k)*(-v1(k)-(1-r(k))*iintra1(k)+r(k)*ee+gain*backgain*iinter1(k)-gain*iinter2(k));
    vdot(3*(k-1)+2)=1/(1-r(k))/t0(k)*(-v2(k)-(1-r(k))*iintra2(k)+r(k)*ee-gain*iinter3(k));
    vdot(3*(k-1)+3)=1/(1-r(k))/t0(k)*(-v3(k)-(1-r(k))*iintra3(k)+r(k)*ee);
end

sys = [vdot vtrandot1 vtrandot2 vtrandot3];

% end mdlDerivatives

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=Outputs(t,x,u,nn)
v=x(1:3*nn);
sys =[v];