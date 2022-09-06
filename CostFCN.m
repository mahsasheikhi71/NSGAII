function Z=CostFCN()
clc
Parameter.NumberOfSupplier=2;
Parameter.NumberOfWareHouse=3;
Parameter.NumberOfCustomer=5;
Parameter.NumberOfVehicle=4;
Parameter.NumberOfPeriod=3;
Parameter.TMax=10;
TM=ones([1,Parameter.NumberOfVehicle]).*Parameter.TMax.*120;

Pop1=[1 3 3 1 1];

Pop2=[0.12 0.63 0.34 0.83 0.72
      0.12 0.63 0.34 0.83 0.72
      0.12 0.63 0.34 0.83 0.72];

Pop3=[0.12 0.63 0.34
      0.31 0.30 0.12
      0.95 0.43 0.53
      0.54 0.74 0.68
      0.12 0.63 0.34
      0.31 0.30 0.32
      0.95 0.43 0.53
      0.54 0.74 0.68
      0.12 0.63 0.34
      0.31 0.30 0.12
      0.95 0.43 0.53
      0.54 0.74 0.68];
  
Pop4=[0.81,0.63,0.95,0.95,0.42
      0.90,0.09,0.96,0.48,0.91
      0.12,0.27,0.15,0.80,0.79
      0.91,0.54,0.97,0.14,0.95
      0.81,0.63,0.95,0.95,0.42
      0.90,0.09,0.96,0.48,0.91
      0.12,0.27,0.15,0.80,0.79
      0.91,0.54,0.97,0.14,0.95
      0.81,0.63,0.95,0.95,0.42
      0.90,0.09,0.96,0.48,0.91
      0.12,0.27,0.15,0.80,0.79
      0.91,0.54,0.97,0.14,0.95];

A=setdiff(1:Parameter.NumberOfWareHouse,unique(Pop1));
for i=A
    Pop3(:,i)=0;
end
X=zeros(size(Pop3));
for i=1:size(Pop3,1)
    A=find(Pop3(i,:)==max(Pop3(i,:)));
    X(i,A(1))=1;
end
Pop3=X;
c=1;
for i=Pop1
    Pop4(:,c)=Pop3(:,i).*Pop4(:,c);
    c=c+1;
end

for t=1:Parameter.NumberOfPeriod
    pop2=Pop2(t,:);
    pop3=Pop3((t-1)*Parameter.NumberOfVehicle+1:t*Parameter.NumberOfVehicle,:);
    pop4=Pop4((t-1)*Parameter.NumberOfVehicle+1:t*Parameter.NumberOfVehicle,:);
    pop2
    pop3
    pop4
    for i=unique(Pop1)
            
    end
end



end