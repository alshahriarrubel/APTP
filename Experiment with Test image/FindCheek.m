function [output]=FindCheek(img)
addpath(genpath('.'));
% % Load Models
fitting_model='models/Chehra_f1.0.mat';
load(fitting_model);    
Boundaries_of_check_region=zeros(4);

%% Perform Fitting  
    % % Load Image
    test_image=im2double(img); 
    if size(test_image,3) == 3
        test_input_image = im2double(rgb2gray(test_image));
    else
        test_input_image = im2double((test_image));
    end
%    subplot(1,2,1);
    %imshow(test_image);hold on;
    disp('Detecting Face..');   
    faceDetector = vision.CascadeObjectDetector();   % Returns an object that is used to detect face region
    bbox = step(faceDetector, test_image);           % Returns step response 
    test_init_shape = InitShape(bbox,refShape);
    test_init_shape = reshape(test_init_shape,49,2);         %%reshape(A,sz) reshapes A using the size vector, sz, to define size(B). 
                                                             %%For example, reshape(A,[2,3]) reshapes A into a 2-by-3 matrix


    MaxIter=6;
    test_points = Fitting(test_input_image,test_init_shape,RegMat,MaxIter);
    
    [highest_x,highest_idx_x]=max(test_points(:,1));                                                    
    [lowest_x,lowest_idx_x]=min(test_points(:,1));                 
    
%    hold on;                                                      
%     plot(round(test_points(highest_idx_x,1)),round(test_points(highest_idx_x,2)),'ms','MarkerSize',10);  
%      
%     hold on;                                                       
%     plot(round(test_points(lowest_idx_x,1)),round(test_points(lowest_idx_x,2)),'cs','MarkerSize',10);  
%    
   test_points_sorted=sortrows(test_points,2);           
%     hold on;                                                      
%     plot(round(test_points_sorted(23,1)),round(test_points_sorted(23,2)),'rs','MarkerSize',10); 
%      
%     hold on;                                                       
%     plot(round(test_points_sorted(32,1)),round(test_points_sorted(32,2)),'ys','MarkerSize',10);  
%     title('Input Image With Cheek Region','FontSize',16,'Color','m');
%     
    left_eyebrow = round(lowest_x);
    right_eyebrow = round(highest_x);
    lower_eye=round(test_points_sorted(23,2));
    upper_lip=round(test_points_sorted(32,2));
        
    Boundaries_of_check_region(1)=left_eyebrow;
    Boundaries_of_check_region(2)=right_eyebrow;
    Boundaries_of_check_region(3)=lower_eye;
    Boundaries_of_check_region(4)=upper_lip;
    
    output=Boundaries_of_check_region;
%%
