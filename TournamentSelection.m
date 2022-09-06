function i=TournamentSelection(pop,m)

    if nargin<2
        m=2;
    end

    nPop=numel(pop);
    
    m=round(min(max(m,1),nPop));
    
    jj=randperm(nPop);
    jj=jj(1:m);
    
    Costs=[pop(jj).Cost];
    
    [min_Cost min_Cost_index]=min(Costs); %#ok
    
    i=jj(min_Cost_index);

end