ij=length(data);
m1=0;
m2=0;
p=0;
count=0;
tempp=0;
id=ij;
avg=0;
mm1=0;
mm2=0;
udata=data(ij);
ldata=data(ij);

   for i=ij-1:-1:ij*0.5
        if data(i)>udata
            udata=data(i);
        end
        if data(i)<ldata
            ldata=data(i);
        end
    end

    avg=(udata+ldata)/2;
    amplitude=(udata-ldata)/2;

for id=ij-1:-1:2
    if (data(id+1)-data(id))>0&(data(id-1)-data(id))>0&abs(data(id)-ldata)<abs(udata-ldata)/5
        break
    end
    if id<ij*2/3 
        break;
    end
end
if id<ij*2/3 
    p=0;
    m=0;
    avg=data(ij);
else 
    m2=tout(id);
    m1=tout(id);
    mm1=data(id);
    mm2=data(id);
    
    for i=id-1:-1:ij/2
        if  (data(i+1)-data(i))>0&(data(i-1)-data(i))>0&abs(data(i)-ldata)<abs(udata-ldata)/5
            count=count+1;
            m2=tout(i);
        end
        if mm1<data(i)
            mm1=data(i);
        end
        if mm2>data(i)
            mm2=data(i);
        end
        if count==10
            tempp=-tout(i)+m1;
            break
        end
    end
    p=tempp/10;
    m=mm1-mm2;
    avg=(mm1+mm2)/2;
end

    