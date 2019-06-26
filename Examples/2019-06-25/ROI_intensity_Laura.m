%% Script to load images from Ca2+ imaging and compute the intensity on 
% given regions of interest 

%%Set parameters
%% Set parameters
baseDir='Immagini\'; % Path to the images
nameFormat='*jpg'; % Format of the images


%% Load all images in the folder for given time (max 999)
z=[];
fileList = dir([baseDir nameFormat]);
fileName=[];
fileIdx=[];
for i=1:length(fileList)
    fileName{i}=fileList(i).name;
    fileIdx=[fileIdx;fileList(i).name(end-5:end-4)];    
    z=cat(3,z,sum(imread([baseDir fileName{i}]),3));
end

% Get the order right
fileIdxN=abs(str2num(fileIdx));
[a,I]=sort(fileIdxN);
x=z(:,:,I);

%% Check the average image
meanI=mean(x,3);
figure;imagesc(meanI);

%% Give regions of interest
% Give coordinates in format x1, x2; y1;y2
r1=[500 1000;
     150 650] 
 
% Display region of interest, check it looks OK 
s=x([r1(2,1):r1(2,2)],[r1(1,1):r1(1,2)],:);
figure;imagesc(mean(s,3));

%% Calculate intensity on region 
intV=squeeze(mean(mean(x([r1(1,1):r1(1,2)],[r1(2,1):r1(2,2)],:),1),2));


%% Make a plot of intensity over time

%Time vector: 128ms/frame
t=[0:length(intV)-1].*0.0128

figure;hold on;
plot(t,intV,'--k','linewidth',2) % Make a line between the points
plot(t,intV,'ob','markerfacecolor','b','markersize',20,'markeredgecolor',[0.5 0.2 1]) % Make a point for every data point

xlim([-0.0128 length(intV)*0.0128])
set(gca,'FontSize',32);

xlabel('Time(s)')
ylabel('Fluorescence intensity')

%legend({'Pad1','Pad2','Pad3','Pad4','Pad5','Pad6','Pad7','Pad8'})
%legend('Inkjet printed MEA');
box off;
set(gca,'tickdir','out'); 
