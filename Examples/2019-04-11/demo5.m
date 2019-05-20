%% Demo 5: Functions

% External pieces of code that can be called upon to executed a pre-defined
% series of instructions

z=log(10)

%% It is easy to define your own functions in MATLAB
% (see the function definition in the file my_function.m)
my_function

%% Functions can take inputs...
x=rand(20,1).*10;
y=x+rand(20,1).*2;
my_function2(x,y)

%% ... and return outputs
[z,w]=my_function3(x,y);
z
w

%%
[b,l]=hist(rand(1000,1),10);
histocat(b,l)