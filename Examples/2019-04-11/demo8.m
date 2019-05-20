%% Demo 8: Making Histograms

%Generate data
dataG=randn(1000,1);

figure;
hist(dataG)

%Change number of bins
figure
hist(dataG,100)

% Get the values for the bin locations and sizes
[bins,locs]=hist(dataG,100);
figure;
plot(locs,bins,'*r')

% Use the data to plot a moving average
rAv=movmean(bins,10);
hold on;
plot(locs,rAv,'--','linewidth',2)