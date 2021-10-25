clear;
close all;
tic;

%% Variables
% 
load('Image_labels_CK_plus_last_3_of_each_folder.mat');
load('CK_plus_Boundaries_of_check_region.mat');
load('knn_model.mat');
%load('Feature_Histograms.mat');
region_x=10;
region_y=10;
[file,path] = uigetfile('*.*');
if isequal(file,0)
   disp('User selected Cancel');
   return;
else
   disp(['User selected ', fullfile(path,file)]);
   
end
%% Feature Vector Generation
fprintf('Accessing Image# %s..\n',file);
img=imread(fullfile(path,file));
[r,c,ch]=size(img);
if(r<380 || c<320)
    str='Image size cannot be less than 380x320. Try again';
    disp(str); 
    imshow(insertText(zeros(200,600),[50 70],str,'BoxCOlor','c','BoxOpacity',0.05,'FontSize',20,'TextColor','r'));
    return;
end
 if(ch>1)
    img=rgb2gray(img); 
 end
img=imresize(img,[380 320]);
boundary=FindCheek(img);
left_eyebrow=boundary(1);
right_eyebrow=boundary(2);
lower_eye=boundary(3);
upper_lip=boundary(4);
Feature_Histogram=PTP(img,left_eyebrow,right_eyebrow,lower_eye,upper_lip,region_x,region_y);


%% Classification

   disp('KNN Testing...');
   experiment_result = predict(knn_model, Feature_Histogram);
   figure;
   hold on;
   subplot(1,2,1);
   imshow(img);title('Input Image');
   if experiment_result==1
       fprintf('Expression: Angry\n');
       subplot(1,2,2);
       imshow(insertText(zeros(700,600),[140 250],'Angry','BoxCOlor','c','BoxOpacity',0.05,'FontSize',80,'TextColor','g'));
   elseif  experiment_result==2
       fprintf('Expression: Contempt\n');
       subplot(1,2,2);
       imshow(insertText(zeros(700,600),[100 250],'Contempt','BoxCOlor','c','BoxOpacity',0.05,'FontSize',80,'TextColor','g'));
   elseif  experiment_result==3
       fprintf('Expression: Disgust\n');
       subplot(1,2,2);
       imshow(insertText(zeros(700,600),[100 250],'Disgust','BoxCOlor','c','BoxOpacity',0.05,'FontSize',80,'TextColor','g'));
   elseif  experiment_result==4
       fprintf('Expression: Fear\n');
       subplot(1,2,2);
       imshow(insertText(zeros(700,600),[180 250],'Fear','BoxCOlor','c','BoxOpacity',0.05,'FontSize',80,'TextColor','g'));
   elseif  experiment_result==5
       fprintf('Expression: Happy\n');
       subplot(1,2,2);
       imshow(insertText(zeros(700,600),[110 250],'Happy','BoxCOlor','c','BoxOpacity',0.05,'FontSize',80,'TextColor','g'));
   elseif  experiment_result==6
       fprintf('Expression: Sad\n');
       subplot(1,2,2);
       imshow(insertText(zeros(700,600),[180 250],'Sad','BoxCOlor','c','BoxOpacity',0.05,'FontSize',80,'TextColor','g'));
   elseif  experiment_result==7
       fprintf('Expression: Surprise\n');
       subplot(1,2,2);
       imshow(insertText(zeros(700,600),[100 250],'Surprise','BoxCOlor','c','BoxOpacity',0.05,'FontSize',80,'TextColor','g'));    
   end
   title('Expression');
    %% Call SVM with LIBSVM TOOL
%     fprintf('SVM calling...\n');
%     model=svmtrain(Image_labels_CK_plus_last_3_of_each_folder(train_indices),Feature_Histograms(train_indices,:),'-t 0'); %'-t 1 -r -1.2 -b 1'
%     experiment_result=svmpredict(Image_labels_CK_plus_last_3_of_each_folder(test_indices),Feature_Histograms(test_indices,:),model);


    
    
toc;

%% Notification sound
load chirp               % handel,gong,laughter,train ,splat
sound(y,Fs)

