% DATA is a defined signal to calculate area under one period
% variable used: i, oarea, ldata, udata, low, oareas, idido, idid, harea, periods

id=0;
idid=0;
idido=0;
time=0;
ij=length(data);
oareas=0;
% Judge if DATA is constant or periodic
if abs(data(ij)-data(floor(0.9*ij)))<0.001*abs(data(ij))&abs(data(ij)-data(floor(0.85*ij)))<0.001*abs(data(ij))
    oarea=inf;
else
    ldata=data(ij);
    udata=data(ij);
%   To find the upper bound and lower bound of DATA    
    for i=ij-1:-1:ij*0.8
        if data(i)<ldata
            ldata=data(i);
        end
        if data(i)>udata
            udata=data(i);
        end
    end
    low=ldata;
%   To find the first locol minimum
    for i=ij-1:-1:2
        if (data(i+1)-data(i))>0&(data(i-1)-data(i))>0&abs(data(i)-low)<abs(udata-low)/5
            id=i; 
            break
        end
    end
    for i=id-1:-1:2
        if (data(i+2)-data(i))>0&(data(i+1)-data(i))>0&(data(i-2)-data(i))>0&(data(i-1)-data(i))>0&(tout(id)-tout(i))>(1-rr)*t0(1)*3/1000
            id=i; 
            break
        end
    end
    for i=id-1:-1:2
        if (data(i+5)-data(i))>0&(data(i+1)-data(i))>0&(data(i-5)-data(i))>0&(data(i-1)-data(i))>0&(tout(id)-tout(i))>(1-rr)*t0(1)*3/1000
            break
        end
    end
    idido(1)=id;
    id=i;
    idido(2)=id;
    
%   To find the Uni-area series
    count=2;
    oarea=0;
    periods=0;
%    idido(1)=id;
    for i=id-1:-1:id*0.7
        oarea=oarea+(data(i)-low)*(tout(i+1)-tout(i));
        if (data(i+1)-data(i))>0&(data(i+5)-data(i))>0&(data(i-1)-data(i))>0&(data(i-5)-data(i))>0&(tout(idido(count-1))-tout(i))>(1-rr)*t0(1)*6/1000&abs(data(i)-ldata)<abs(udata-ldata)*0.8
            count=count+1;
            oareas(count-2)=oarea;
            oarea=0;
            idido(count)=i;
            periods(count-2)=tout(idido(count-1))-tout(idido(count));    
       end
    end
 %  To find the half-area series
    harea=0;
    count=0;
    idid=0;
    i=id;
    while i>id*0.7-1
        i=i-1;
        harea=harea+(data(i)-low)*(tout(i+1)-tout(i));
        if harea>oareas(count+1)/2
            count=count+1;
            harea=0;
            time(count)=(tout(i-1)+tout(i))/2;
            idid(count)=i;
            i=idido(count+2);
        end
        if count>=length(oareas)-1&mod(count,2)==0
            break
        end
    end
end