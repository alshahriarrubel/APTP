function [cropping_points]=detect_cropping_points(img)

%Create a face detector object.
faceDetector = vision.CascadeObjectDetector;

I = img;

%%
%Detect faces.

bboxes = faceDetector(I);
cropping_points=bboxes;



