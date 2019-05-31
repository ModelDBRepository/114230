parameter;
sim('CPGmodel');
phasedif;
figure
plot(tout,outcpg(:,1:3:3*nn))
grid on;
axis([18 20 -20 15]);
xlabel('Time [s]')
ylabel('0-group neuron membrane output [mV]');
figure
plot([1.5:nn-0.5],pdifr1(1,:),'o-');
grid on;
axis([0 18 0 20]);
xlabel('Segment index')
ylabel('phase lag between the 0-group neruon along the chain [rad]');
period=periodavg1(1);

