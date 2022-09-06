function [Z,Feasible]=ObjectiveFCN(Pop1,Pop2,Pop3,Pop4,Parameter)

TU=Parameter.Tmax*Parameter.Umax;

Demand=Parameter.Demand;
Route=[];

for t=1:Parameter.t
    pop2=Pop2(t,:);
    pop3=Pop3((t-1)*Parameter.v+1:t*Parameter.v,:);
    for j=1:Parameter.j
        X=find(Pop1==j);
        if ~isempty(X)
            V=find(pop2>0);
            for v=V
                Time=TU;
                for r=1:pop2(v)
                    [~,E]=sort(pop3(v,X));
                    X=X(E);
                    D=zeros([1,numel(X)]);
                    for ii=1:numel(X)
                        D(ii)=sum(Demand(X(ii):Parameter.k:Parameter.p*Parameter.k,t).*Parameter.G');
                    end
                    CumSumD=cumsum(D);
                    Tr1=find(CumSumD<Parameter.Capacity,1,'last');
                    XX=[j,X(1:Tr1)+Parameter.j,j];
                    while(numel(XX)>2)
                        TimeDis=CalDistance(XX,Parameter.d);
                        if TimeDis<=Time
                            Time=Time-TimeDis;
                            for ii=1:numel(XX)
                                if (ii==1 || ii==numel(XX))
                                    Route(1,end+1)=t;
                                    Route(2,end)=XX(ii);
                                    Route(3,end)=v;
                                    Route(4,end)=r;
                                else
                                    Route(1,end+1)=t;
                                    Route(2,end)=XX(ii);
                                    Route(3,end)=v;
                                    Route(4,end)=r;
                                    Demand((XX(ii)-Parameter.j):Parameter.k:Parameter.p*Parameter.k,t)=0;
                                    X(1)=[];
                                end
                            end
                            break;
                        else
                            XX(1,end-1)=[];
                        end
                    end                    
                end
                pop2(v)=0;
                if isempty(X)
                    break;
                end
            end
        end
    end
end

TotalDemand=zeros([Parameter.j*Parameter.p,Parameter.t]);
TotalOrder=TotalDemand;

for j=1:Parameter.j
    X=find(Pop1==j);
    if ~isempty(X)
        for p=1:Parameter.p
            if (numel(X)>1)
                TotalDemand(j+(p-1)*Parameter.j,:)=sum(Parameter.Demand(X+(p-1)*Parameter.k,:));
            else
                TotalDemand(j+(p-1)*Parameter.j,:)=Parameter.Demand(X+(p-1)*Parameter.k,:);
            end
        end
    end
end

C=repmat(sum(Parameter.C),Parameter.t,1)';
CA=repmat(Parameter.Ca,Parameter.t,1)';
CCA=CA;
Penalty1=sum(sum(Demand));

A=sum(sum(TotalDemand));

TotalD=TotalDemand;
for p=1:Parameter.p
    for j=1:Parameter.j
        X=TotalDemand(j+(p-1)*Parameter.j,:);
        if sum(X)~=0
            for t=Parameter.t:-1:1
                if (TotalDemand(j+(p-1)*Parameter.j,t)<=C(p,t) && (TotalDemand(j+(p-1)*Parameter.j,t)*Parameter.G(p))<=CA(j,t))
                    TotalOrder(j+(p-1)*Parameter.j,t)=TotalDemand(j+(p-1)*Parameter.j,t);
                    C(p,t)=C(p,t)-TotalDemand(j+(p-1)*Parameter.j,t);
                    CA(j,t)=CA(j,t)-TotalOrder(j+(p-1)*Parameter.j,t)*Parameter.G(p);
                    TotalDemand(j+(p-1)*Parameter.j,t)=0;
                else
                    AA=min(C(p,t),CA(j,t)/Parameter.G(p));
                    TotalOrder(j+(p-1)*Parameter.j,t)=AA;
                    TotalDemand(j+(p-1)*Parameter.j,t)=TotalDemand(j+(p-1)*Parameter.j,t)-AA;
                    CA(j,t)=CA(j,t)-AA*Parameter.G(p);
                    C(p,t)=C(p,t)-AA;
                    if (t>=2)
                        TotalDemand(j+(p-1)*Parameter.j,t-1)=TotalDemand(j+(p-1)*Parameter.j,t-1)+TotalDemand(j+(p-1)*Parameter.j,t);
                    end
                    TotalDemand(j+(p-1)*Parameter.j,t)=0;
                end
            end
        end
    end
end

Penalty1=Penalty1+(A-sum(sum(TotalOrder)));

Empty.TotalSend=zeros([Parameter.i*Parameter.p,Parameter.j]);
Time=repmat(Empty,Parameter.t,1);

for t=1:Parameter.t
    C=Parameter.C;
    Order=TotalOrder(:,t);
    for j=unique(Pop1)
        for p=1:Parameter.p
            T=Pop4(j,:).*(C(:,p)>0)';
            [~,B]=sort(T,'descend');
            B=B(1:sum(C(:,p)>0));
            counter = 1;
            while(Order(j+(p-1)*Parameter.j,1)>0)
                A=min(Order(j+(p-1)*Parameter.j,1),C(B(counter),p));
                Time(t).TotalSend(B(counter)+(p-1)*Parameter.i,j) = A;
                Order(j+(p-1)*Parameter.j,1)=Order(j+(p-1)*Parameter.j,1)-A;
                C(B(counter),p)=C(B(counter),p)-A;
                counter = counter + 1;                
            end
        end
    end
end

TDemand=zeros([Parameter.p,Parameter.t]);
for p=1:Parameter.p
    TDemand(p,:)=sum(Parameter.Demand(1+(p-1)*Parameter.k:p*Parameter.k,:));
    TOrder(p,:)=sum(TotalOrder(1+(p-1)*Parameter.j:p*Parameter.j,:));
end

Income=0;

for p=1:Parameter.p
    Inv=zeros(Parameter.Tomax,Parameter.t);
    TO=TOrder(p,:);
    Inv(1,:)=TO;
    TD=TDemand(p,:);
    for t=1:Parameter.t
        for tp=Parameter.Tomax:-1:1
            A=min(TD(1,t),Inv(tp,t));
            Inv(tp,t)=Inv(tp,t)-A;
            Income=Income+A*Parameter.SC(p,tp);
            TD(1,t)=TD(1,t)-A;
            TO(1,t)=TO(1,t)-A;
            if TD(1,t)==0||TO(1,t)==0
                break;
            end
        end
        if t<Parameter.t
            Inv(2:end,t+1)=Inv(2:end,t+1)+Inv(1:end-1,t);
        end
    end
end

Cost2=sum(Parameter.F(1,unique(Pop1)));

U=[];
for t=1:Parameter.t
    A=find(Route(1,:)==t);
    Vehicle=unique(Route(3,A));
    M1Route=Route(:,A);
    for v=Vehicle
        Dis=0;
        M2Route=M1Route(:,M1Route(3,:)==v);
        A=M2Route(2,:);
        for i=A
            if (Route(2,i)<=Parameter.j && Route(2,i+1)<=Parameter.j)
                % Do nothing
            else        
                Dis=Dis+Parameter.d(Route(2,i),Route(2,i+1));
            end
        end
        U(end+1)=Dis/Parameter.Tmax;
    end
end
u=max(U);

Cost3=0;
Z3=0;
U=[];
Xcounter=0;
for i=1:size(Route,2)-1
    if (Route(2,i)<=Parameter.j && Route(2,i+1)<=Parameter.j)
        % Do nothing
    else        
        Cost3=Cost3+Parameter.d(Route(2,i),Route(2,i+1))*Parameter.tc(Route(2,i),Route(2,i+1));
        Z3=Z3+Parameter.d(Route(2,i),Route(2,i+1))*(1576-17.6*u+0.00117*u^3+36076*(1/(u^2)));
        Xcounter=Xcounter+1;
    end
end
Z2=exp(0.1929169*(u-Parameter.Av)-0.0024244*(u-Parameter.Av)^2)*Xcounter;
Cost4=sum(sum(TOrder.*repmat(Parameter.Ps',1,Parameter.t)));
Cost5=0;
for t=1:Parameter.t
    A=unique(Route(3,Route(1,:)==t));
    Cost5=Cost5+sum(Parameter.VC*numel(A));
end

for t=1:Parameter.t
    Time(t).fixOrder = zeros(Parameter.i,Parameter.j);
    for p=1:Parameter.p
        Time(t).fixOrder = min(1,Time(t).fixOrder+Time(t).TotalSend((p-1)*Parameter.i+1:p*Parameter.i,:)>0);
    end
end

Cost6=0;
for t=1:Parameter.t
    Cost6=Cost6+sum(sum(Parameter.OS.*Time(t).fixOrder));
end

Cost1=0;
Holding=zeros(Parameter.j*Parameter.p,Parameter.t);
for p=1:Parameter.p
    for t=1:Parameter.t
        if t==1
            Holding((p-1)*Parameter.j+1:p*Parameter.j,t)=TotalD((p-1)*Parameter.j+1:p*Parameter.j,t)-TotalOrder((p-1)*Parameter.j+1:p*Parameter.j,t);
        else
            Holding((p-1)*Parameter.j+1:p*Parameter.j,t)=Holding((p-1)*Parameter.j+1:p*Parameter.j,t-1)+TotalD((p-1)*Parameter.j+1:p*Parameter.j,t)-TotalOrder((p-1)*Parameter.j+1:p*Parameter.j,t);
        end
    end
    Cost1=Cost1+sum(sum(Holding((p-1)*Parameter.j+1:p*Parameter.j,t),2).*Parameter.hc(:,p));
end


% Penalty1
% Income
% Cost1
% Cost2
% Cost3
% Cost4
% Cost5
% Cost6

CPenalty=zeros([Parameter.j,Parameter.t]);
for p=1:Parameter.p
    CPenalty=CPenalty+Parameter.G(p).*TotalD((p-1)*Parameter.j+1:p*Parameter.j,:);
end

Penalty2=sum(sum(max(0,CPenalty-CCA)));
Z1=Cost1+Cost2+Cost3+Cost4+Cost5+Cost6-Income;
Feasible=1;
if Penalty1+Penalty2>0
    Feasible=0;
    Z1=Z1+Parameter.FixPenalty+(Penalty1+Penalty2)*Parameter.VarPenalty;
    Z2=Z2+Parameter.FixPenalty+(Penalty1+Penalty2)*Parameter.VarPenalty;
    Z2=Z2+Parameter.FixPenalty+(Penalty1+Penalty2)*Parameter.VarPenalty;
end
Z=[Z1;Z2;Z3];

% Z=Z1;

end