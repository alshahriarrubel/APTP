clear;
close all;
% Create a figure window
fig = uifigure('Name','Facial Expression Recognition');
ax = uiaxes(f);
% Create a push button
btn = uibutton(fig,'push',...
               'Position',[250, 300, 100, 22],...
               'Text','Select an image',...
               'ButtonPushedFcn', @(btn,event) main(fig));
