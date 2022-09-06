function [ch1_1, ch1_2, ch1_3, ch1_4, ch2_1, ch2_2, ch2_3, ch2_4]=Crossover(p1_1,p1_2,p1_3,p1_4,p2_1,p2_2,p2_3,p2_4,Parameter)

    ch1_1=p1_1;
    ch1_2=p1_2;
    ch1_3=p1_3;
    ch1_4=p1_4;
    
    ch2_1=p2_1;
    ch2_2=p2_2;
    ch2_3=p2_3;
    ch2_4=p2_4;
    
    C=cumsum([Parameter.Cross1,Parameter.Cross2,Parameter.Cross3,Parameter.Cross4]);
    i=find(rand<=C,1,'first');
    
    if i==1
        A=randsample(numel(p1_1),2);
        A=sort(A);
        ch1_1=[p1_1(1,1:A(1)),p2_1(1,A(1)+1:A(2)-1),p1_1(1,A(2):end)];
        ch2_1=[p2_1(1,1:A(1)),p1_1(1,A(1)+1:A(2)-1),p2_1(1,A(2):end)];        
        
    elseif i==2
        [m, n]=size(p1_2);
        A=randsample(m*n,2);
        A=sort(A);
        p1_2=reshape(p1_2,1,m*n);
        p2_2=reshape(p2_2,1,m*n);
        ch1_2=[p1_2(1,1:A(1)),p2_2(1,A(1)+1:A(2)-1),p1_2(1,A(2):end)];
        ch2_2=[p2_2(1,1:A(1)),p1_2(1,A(1)+1:A(2)-1),p2_2(1,A(2):end)];        
        ch1_2=reshape(ch1_2,m,n);
        ch2_2=reshape(ch2_2,m,n);
        
    elseif i==3
        [m, n]=size(p1_3);
        A=randsample(m*n,2);
        A=sort(A);
        p1_3=reshape(p1_3,1,m*n);
        p2_3=reshape(p2_3,1,m*n);
        ch1_3=[p1_3(1,1:A(1)),p2_3(1,A(1)+1:A(2)-1),p1_3(1,A(2):end)];
        ch2_3=[p2_3(1,1:A(1)),p1_3(1,A(1)+1:A(2)-1),p2_3(1,A(2):end)];        
        ch1_3=reshape(ch1_3,m,n);
        ch2_3=reshape(ch2_3,m,n);
        
    else
        [m, n]=size(p1_4);
        A=randsample(m*n,2);
        A=sort(A);
        p1_4=reshape(p1_4,1,m*n);
        p2_4=reshape(p2_4,1,m*n);
        ch1_4=[p1_4(1,1:A(1)),p2_4(1,A(1)+1:A(2)-1),p1_4(1,A(2):end)];
        ch2_4=[p2_4(1,1:A(1)),p1_4(1,A(1)+1:A(2)-1),p2_4(1,A(2):end)];        
        ch1_4=reshape(ch1_4,m,n);
        ch2_4=reshape(ch2_4,m,n);
        
    end
    
end