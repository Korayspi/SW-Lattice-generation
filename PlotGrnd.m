function q=PlotGrnd(Nod, Con)
% Plotting points
h=plot3(Nod(:,1),Nod(:,2),Nod(:,3),'.');
v=Nod(Con(:,2),:)-Nod(Con(:,1),:);

% Plotting lines
hold on;
q = quiver3(Nod(Con(:,1),1),Nod(Con(:,1),2),Nod(Con(:,1),3),v(:,1),v(:,2),v(:,3),0);
q.ShowArrowHead = 'off';
hold off;
axis equal
end