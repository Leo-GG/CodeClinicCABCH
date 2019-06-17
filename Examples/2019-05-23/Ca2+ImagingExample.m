%% Set parameters
baseDir='frames\';
nameFormat='*jpg'; % file names to look for
K=5; % How many groups of cells to consider separatedly
noiseLevel=5; % adjust the noise level; more restrictive segmentation when higher
maxTh=7.5; % threshold for local maxima search, increase to limit their number
smootTh=10; % threshold for background subtraction on smoothed image

%% Load all images in the folder for given time (max 999)
z=[];
fileList = dir([baseDir nameFormat]);
fileName=[];
fileIdx=[];
for i=1:length(fileList)
    fileName{i}=fileList(i).name;
    fileIdx=[fileIdx;fileList(i).name(end-8:end-4)];    
    z=cat(3,z,sum(imread([baseDir fileName{i}]),3));
end

% Get the order right
fileIdxN=abs(str2num(fileIdx));
[a,I]=sort(fileIdxN);
x=z(:,:,I);

%% Make difference of intensities
zz=single(diff(x,1,3));

% Show the mean intensity
meanI=mean(x,3);
figure;imagesc(meanI);
set(gca,'FontSize',20);
title('Mean fluorescence Intensity')
colorbar;

%% Threshold to remove noise
nT=abs(mean(zz,3));

% Show the mean difference before thresholding
figure;imagesc(nT);
set(gca,'FontSize',20);
title('Mean Intensity difference')
colorbar;

% Show the intensity minus intensity differences
figure;imagesc((nT./max(max(nT)) )-meanI./max(max(meanI)) );
set(gca,'FontSize',20);
title('Mean Intensity minus Intensity changes')
cbar=colorbar;
colormap jet;
cbar.TickLabels{1}='Permanently ON'
cbar.TickLabels{6}='Large changes'

% Show the distribution of differences values
intData=reshape(nT,[],1);
figure;
hist(intData(intData>1),100);
title('Distribution of fluorescence intensity changes')

%% Smooth image
smoothI=conv2(nT, fspecial('gaussian',20 ,10),'same');
figure;imagesc(smoothI);
set(gca,'FontSize',20);
title('Smoothed Image')
imshowpair(nT, smoothI, 'montage');
set(gca,'FontSize',20);
title('Smoothing');

%% Apply adaptative threshold
thADiff=mat2gray(smoothI);
ws=300; %window size for filter
mIM=imfilter(thADiff,fspecial('average',ws),'replicate');

sIM=(-(mIM-thADiff));
sIM(sIM<0)=0;
sIM=mat2gray(sIM);
figure;imshowpair(thADiff, sIM, 'montage')
set(gca,'FontSize',20);
title('Background substraction');

thresh=graythresh(sIM(sIM>0));
bw=im2bw(sIM,thresh);
figure;imshowpair(sIM,bw, 'montage');
set(gca,'FontSize',20);
title('Binaryzation');


%% Apply binary mask
maskedI=nT.*bw;
figure;imshowpair(nT,maskedI, 'montage');
title('Masked image (binary filter on original)');
set(gca,'FontSize',20);
title('Masked (bit more colorful)');
imagesc(maskedI);colorbar
colormap jet;

%% Local maxima (could skip and cluster on non-null intensities but memory is limited)
intData=reshape(maskedI,[],1);
thresh=0;
[cent cm]=FastPeakFind(maskedI,thresh,(fspecial('gaussian',20 ,10)));
mX=cent(1:2:end);
mY=cent(2:2:end);

% Show maxima
figure;imagesc(nT);
hold on;
scatter(mX,mY,100,'r','filled')
set(gca,'FontSize',20);
title('Local maxima')

%% Cluster maxima
mPos=[mX mY];
Y = squareform(pdist(double(mPos)));

%Using Hierarchical clustering
Z = linkage(Y,'single');
figure;dendrogram(Z,0)
title('Local maxima clustering dendogram');
I = inconsistent(Z)
figure;plot(Z(:,3),'o')
title('Linkage distances at each agglomerative clustering step');
figure;hist(Z(:,3),100);
title('Histogram of linkage distances');
T=cluster(Z,'cutoff',100,'criterion','distance');
idx=T;
K=numel(unique(idx));

%% Alternatively, using K-means 
% Last chance to re-adjust the number of cell groups!!!
% Change K value if needed
% K=floor(numel(mX)/2); % reduce clusters to half, not a proper solution
% idx =kmeans(Y,K);

%% If you want to consider ALL, turn each maxima into its own cluster
% K=numel(mX);
% idx=(1:numel(mX))';


%% Divide image according to cluster centers
% Cluster center coordinates
C=[];
for i=1:K
    if sum(idx==i)>1
        C=[C;mean(mPos(idx==i,:))];
    else
        C=[C;mPos(idx==i,:)];
    end
end

figure;imagesc(nT);hold on;
scatter(mX,mY,50,'r','filled')
scatter(C(:,1),C(:,2),10,'g','filled')
set(gca,'FontSize',20);
title('Clustered maxima')

[actY,actX,vals]=find(maskedI>0); % all points not removed by thresholding
locP=[actX actY];


% Distance to cluster centers
distC=zeros(length(actX),K);
for i=1:K
    d=  sqrt( sum((double(locP)-double(repmat(C(i,:),length(actX),1))).^2,2));
    distC(:,i)=d;
end

% Cluster index for each point
[row,col]=find(distC == repmat(min(distC,[],2),1,K));

% Some distances might generate duplicates, remove them!
for i=1:numel(actX)
    copies=sum(row==row(i));
    if copies>1
        row(i)=[];
        col(i)=[];
    end
end

[rowi,I]=sort(row);
idxP=col(I);

%% Show the clusters above the image
clColor=hsv(K);
figure;
figure;imagesc(nT);hold on;

hold on;
scatter(actX,actY,1,clColor(idxP,:));
set(gca,'FontSize',20);
title('Located cells')

%% Remove clusters with less than sizeTh points (pixels, actually) and remove them from the image
sizeTh=400;
smoothCl=smoothI;
idxPCl=idxP;
for i=1:K
    clSize=sum(idxP==i);
    if clSize<sizeTh
        xCoord=actX(idxP==i);
        yCoord=actY(idxP==i);
        for p=1:length(xCoord)
            smoothCl(yCoord(p),xCoord(p))=0;
        end 
        idxPCl(idxP==i)=0;
    end
end

figure;
imagesc(smoothI);
hold on;
title('Small clusters removed');
scatter(C(:,1),C(:,2),20,'r','filled')
scatter(C(idxPCl(idxPCl>0),1),C(idxPCl(idxPCl>0),2),10,'g','filled')
legend('All clusters','Large clusters')

% Update K, active coordinates and cluster indices
% -> This is unnecessary, removed clusters are already set to zero, no real
% need to modify the vector sizes
actXCl=actX;
actXCl(idxPCl==0)=[];
actYCl=actY;
actYCl(idxPCl==0)=[];
idxPCl(idxPCl==0)=[];
K=numel(unique(idxPCl));

clColorCl=hsv(max(idxPCl));

figure;
imagesc(nT);
hold on;
scatter(actXCl,actYCl,1,clColorCl(idxPCl,:));
set(gca,'FontSize',20);
title('Located cells (small clusters removed)')

%% Compute intensity changes for each cluster
diffI=zeros(K,size(x,3));
cm=hsv(K);
figure;
actMap=zeros(size(x,1),size(x,2));
clIdx=unique(idxP);

for cl=1:K
    hold on;
    i=clIdx(cl);
    % Filter out points not in the cluster
    clFilt=zeros(size(x,1),size(x,2));
    xCoord=actX(idxP==i);
    yCoord=actY(idxP==i);
    for p=1:length(xCoord)
        clFilt(yCoord(p),xCoord(p))=1;
    end
    % Compute total intensity on cluster pixels on each frame
    for f=1:size(x,3)
        frame=double(squeeze(x(:,:,f)));        
        frameTh=frame.*clFilt;        
        diffI(i,f)=sum(sum(frameTh(:,:),2))/length(xCoord);
    end
    rawI=max(diffI(i,:))-min(diffI(i,:));
    for p=1:length(xCoord)
        actMap(yCoord(p),xCoord(p))=rawI;
    end
end

% Clusters intensity changes on map
figure;imagesc(actMap)
set(gca,'Ydir','reverse')
colorbar;
set(gca,'FontSize',20);
title('Total Intensity changes')

% Distribution of max intensity changes
rawI=max(diffI')-min(diffI');
baseline=median(reshape(max(x,[],3)-min(x,[],3),1,[])); % compare to median max intensity change in whole image
figure;plot(rawI,'o');
line([0 length(rawI)],[baseline baseline],'linestyle','--','color','r');
set(gca,'FontSize',20);
title('Max. Intensity change per cluster')
legend('Max. Intensity change','Median max. change')
xlabel('Cluster ID');
ylabel('\Delta Intensity per pixel')

%% Intensity vs frame plot for each cluster
normA=diffI;
for cl=1:size(diffI,1)
    normA(cl,:)=normA(cl,:)-mean(normA(cl,:));
end

figure;
pics=find(rawI>baseline); %Examples with large chages
plot(normA(pics(1:4),:)','linewidth',3);
set(gca,'FontSize',20);
title('Itensity over time, selected clusters')
xlabel('Frame number');
ylabel('Per-pixel cluster intensity (mean substracted)')

%% Show example plots on few clusters
nDisp=4;
clIdx=unique(idxPCl);
for cl=1:nDisp%length(K)
    i=clIdx(cl);
    % Filter out points not in the cluster
    clFilt=zeros(size(zz,1),size(zz,2));
    xCoord=actXCl(idxPCl==i);
    yCoord=actYCl(idxPCl==i);
    for p=1:length(xCoord)
        clFilt(yCoord(p),xCoord(p))=1;
    end    
    % Show cluster area
    subplot(2,nDisp,cl)
    imagesc(meanI.*clFilt);hold on;
    scatter(C(i,1),C(i,2),10,'g','filled')
    title(['Cluster ' num2str(clIdx(cl)) ' location']);

    for f=1:size(zz,3)
        frame=double(squeeze(zz(:,:,f)));        
        frameTh=frame.*clFilt;        
        diffI(i,f)=sum(sum(frameTh(:,:),2));
    end
    subplot(2,nDisp,cl+nDisp)
    plot(diffI(i,:),'color',cm(i,:));
    xlim([0,25]);
    title('Intensity changes on cluster')
    xlabel('Frame');ylabel('Intensity difference (all pixel sum)')
end
    
