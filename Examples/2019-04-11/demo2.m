%% Demo 2A: MATLAB basics

% Assigning variables
x=1
y=[2 3 4]
x=4
y=6;

% Displaying values
x
y

% Clear command window
clc

% Delete variable
clear x

% Comments

% Running a line
% -> F9
%%
x=5
y=6
z='aaa'
%%
% Running a section
% -> Ctrl+Enter

% Operations
x+x
x*y
x^4
%...

%% Demo 2B: high-level functions

% Magic-square function
x=magic(5);
x
% All rows and columns add up to the same number
sum(x(1,:))
sum(x(:,1))

% Imagesc function displays 2D matrix as an image
figure;
imagesc(x)

% Looks fancier at higher resolutions...
figure;
imagesc(magic(30))