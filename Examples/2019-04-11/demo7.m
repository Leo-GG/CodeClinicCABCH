%% Demo 7: Scatter plots

%% Basic plot
figure; hold on;
plot(num(:,1),num(:,2),'o');

%% Modifying the plot

% Change marker/line style
plot(num(:,1),num(:,2)+10,'r--');
plot(num(:,1),num(:,2)+20,'*k');

% Line width/marker size
plot(num(:,1),num(:,2)+30,'r--','linewidth',2);
plot(num(:,1),num(:,2)+40,'*k','markersize',30);

% x and y lims
xlim([-5 50])
ylim([-10 200])


%% Plot elements

% Add labels
figure; hold on;
plot(num(:,1),num(:,2),'o');
xlabel('Label for x')
mylabel='this is the y label';
ylabel(mylabel)
title('THIS IS A PLOT')

% Change labels font size
figure; hold on;
plot(num(:,1),num(:,2),'o');
xlabel('Label for x')
ylabel('Label for y')
title('THIS IS A PLOT')
set(gca,'fontsize',42)   

% Change ticks direction
figure; hold on;
plot(num(:,1),num(:,2),'o');
set(gca,'TickDir','out');

% Legend
figure; hold on;
plot(num(:,1),num(:,2),'o');
plot(num(:,1),num(end:-1:1,2),'*');
legend('Vector','Reversed vector')


%% Using Subplots

figure;
subplot(3,2,1)
plot(num(:,1),num(:,2),'o');

subplot(3,2,2)
plot(num(:,1),num(end:-1:1,2),'o','markerfacecolor','y');
set(gca,'xtick',[])

subplot(3,2,3)
plot(num(:,1),num(randperm(length(num)),2),'*r');
set(gca,'ytick',[])

subplot(3,2,5)
plot(num(:,1),num(randperm(length(num)),2).*num(end:-1:1,2),'xk');
set(gca,'TickDir','out');

subplot(3,2,6)
plot(num(:,1),num(randperm(length(num)),2)+sin(num(:,2)),'.-');
set(gca,'TickDir','out');
set(gca,'box','off')