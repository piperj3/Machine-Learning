utilpath = fullfile(matlabroot, 'toolbox', 'imaq', 'imaqdemos', ...
    'html', 'KinectForWindows');
addpath(utilpath);

colorVid=videoinput('kinect',1);
%preview(colorVid);
depthVid=videoinput('kinect',2);
%preview(depthVid);
depthimage=getsnapshot(depthVid);
imshow(depthimage,[0 4000]);%mapeo de la imagen
maxdist= max(max(depthimage));

%%
%%Skeleton info
triggerconfig(depthVid,'manual');
depthVid.FramesPerTrigger=1;
depthVid.Triggerrepeat=inf;
set(getselectedsource(depthVid),'TrackingMode','Skeleton')%obtiene datos del skeleto
%%
%get data function
start(depthVid); figure; %inicializamos el objeto para poder usar trigger
%tomamos 100 cuadros
for i=1:100
    trigger(depthVid);
    [depthMap,~,depthMetaData]=getdata(depthVid);
    imshow(depthMap,[0 4000]);
end
%imshow(depthMetaData.SegmentationData);
%%
%%Pulling out joint coordinates for active Skeleton
skeletonJoint=depthMetaData.JointImageIndices(:,:,depthMetaData.IsSkeletonTracked);
imshow(depthMap,[0 4000]);
hold on; plot(skeletonJoint(:,1),skeletonJoint(:,2),'*');
%%
stop(depthVid);
 %%
%%Draw and track skeleton

triggerconfig(colorVid,'manual');
colorVid.FramesPerTrigger=1;
colorVid.Triggerrepeat=inf;

start(depthVid);
start(colorVid);

himg=figure;
while ishandle(himg)
    trigger(colorVid);
    trigger(depthVid);
    image=getdata(colorVid);
    %image2=getdata(depthVid);
    
    [depthMap,~,depthMetaData]=getdata(depthVid);
   
    if sum(depthMetaData.IsSkeletonTracked)>0
        skeletonJoints=depthMetaData.JointImageIndices(:,:,depthMetaData.IsSkeletonTracked);
        %im2=int8(image);
        util_skeletonViewer(skeletonJoints,image,1);
    else
       imshow(image);
%        subplot(2,2,2);imshow(image2);
    end
end
stop(colorVid);
stop(depthVid);
