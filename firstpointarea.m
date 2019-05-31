id=0;
ij=length(data);
if oarea==inf
    id=0;
    time=0;
else
    
for i=ij-1:-1:2
    if (data(i+1)-data(i))>0&(data(i-1)-data(i))>0&abs(data(i)-ldata)<abs(udata-ldata)/8
        break
    end
end
id=i;
low=data(id);
temp=0;
for i=id:-1:1
    tempp=temp;
    temp=temp+(data(i)-low)*(tout(i+1)-tout(i));
    if temp>oarea/2
        break
    end
end
end
id=i;
time=tout(id+1)-(tout(id+1)-tout(id))*(oarea/2-tempp)/(temp-tempp);
