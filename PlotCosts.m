function PlotCosts(pop)

    Costs=[pop.Cost];
    
    plot3(Costs(1,:),Costs(2,:),Costs(3,:),'r*','MarkerSize',8);
    xlabel('1st Objective');
    ylabel('2nd Objective');
    zlabel('3rd Objective');
    grid on;

end