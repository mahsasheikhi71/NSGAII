function [q1, q2, q3, q4]=Mutate(p1,p2,p3,p4,Parameter)

    
    q1=p1;
    q2=p2;
    q3=p3;
    q4=p4;
    
    C=cumsum([Parameter.Mut1,Parameter.Mut2,Parameter.Mut3,Parameter.Mut4]);
    i=find(rand<=C,1,'first');
    
    if i==1
        A=randsample(numel(p1),Parameter.NumMut(1));
        q1(A)=randi(Parameter.j,[1,numel(A)]);
        
    elseif i==2
        [m, n]=size(p2);
        A1=randsample(m,Parameter.NumMut(2));
        A2=randsample(n,Parameter.NumMut(2));
        for j=1:numel(A1)
            q2(A1(j),A2(j))=randi(Parameter.r);
        end
        
    elseif i==3
        [m, n]=size(p3);
        A1=randsample(m,Parameter.NumMut(3));
        A2=randsample(n,Parameter.NumMut(3));
        for j=1:numel(A1)
            q3(A1(j),A2(j))=rand();
        end
        
    else
        [m, n]=size(p4);
        A1=randsample(m,Parameter.NumMut(4));
        A2=randsample(n,Parameter.NumMut(4));
        for j=1:numel(A1)
            q4(A1(j),A2(j))=rand();
        end
        
    end
    
end