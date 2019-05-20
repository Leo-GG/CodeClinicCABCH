%% Demo 3: More on variables

% Values stored in memory can represent different things
% The variable type determines the structure of the values in memory

% Can be integers, doubles, strings...
x=1;
y=3.574;
z='abcd';

% Find out which type is a variable
whos('x')


%% Variables in MATLAB

% In MATLAB context, all variables are arrays or matrices

% 1-row array
x=[ 1 2 3]

% 1-column array
y=[ 4; 5; 6]

% 3x3 matrix
z=[ 1 2 3; 4 5 6; 7 8 9]


%% Access elements of an array or a matrix

% Index by row,column
z(2,1)

% Strings are also arrays!
a='abcd'
a(3)


%% Operate on matrix elements

z(2,2)=999

%% Cells
% Can contain different types of variables
my_cell{1}=5
my_cell{2}='Some text'
my_cell{3}=[2 4 ; 99 42]

% Access elements using curly braces
my_cell{3}

% Acess sub-elements like on a normal matrix
my_cell{3}(1,1)
