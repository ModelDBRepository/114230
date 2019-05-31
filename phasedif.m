% variable used: period1, amplitude1, average1, periodavg1, pdifr1, phaseall, phaseall0 
%                ss,ip, data, temp, times, timecount

period1=0;
amplitude1=0;
average1=0;
periodavg1=0;
pdifr1=0;

phaseall=0;
phaseall0=0;
timecount=1000;
for ss=1:nn
    for ip=1:3
        data=outcpg(:,(ss-1)*3+ip);
        maxperiod;
        amplitude1(ip,ss)=m;
        average1(ip,ss)=avg;
        period1(ip,ss)=p;
        area;
        if length(time)<timecount
            timecount=length(time);
        end
        if mod(timecount,2)==1
            timecount=timecount-1;
        end
        phaseall0(ip,ss,1:timecount)=time(1:timecount);
    end
end

phaseall=phaseall0(:,:,1:timecount);

for ip=1:3
    temp=0;
    times=0;
    for i=1:nn
            if period1(ip,i)>(1-rr)*t0(ss)*3/1000
                temp=temp+period1(ip,i);
                times=times+1;
            end
            
    end
    if times~=0
        periodavg1(ip)=temp/times;
    else
        periodavg1(ip)=inf;
    end
    
end

for ip=1:3
    for i=1:nn-1
        pdifr1(ip,i)=0;
        for j=1:length(phaseall(ip,i,:))-1
            pdifr1(ip,i)=pdifr1(ip,i)-(phaseall(ip,i,j)-phaseall(ip,i+1,j))/(period1(ip,i)+period1(ip,i+1))*720;
        end
        pdifr1(ip,i)=pdifr1(ip,i)/(length(phaseall(ip,i,:))-1);
        pdifr1(ip,i)=rem(pdifr1(ip,i),360);
        if pdifr1(ip,i)>180
            pdifr1(ip,i)=pdifr1(ip,i)-360;
        elseif pdifr1(ip,i)<-180
            pdifr1(ip,i)=pdifr1(ip,i)+360;
        end
    end
end
