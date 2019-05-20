%% Demo 4: Code flow

% MATLAB runs instructions in sequential order. Controlling their flow
% defines the logic of your program

%% Conditional statements
% Execute some code if a condition(s) is(are) met
x=5;
if (x>3)
    fprintf('Condition met! \n')
end

% Can use multiple conditions... 
if ((x>3 & x<10) | (x>1 & x~=5))
    fprintf('Multiple conditions met\n')
end

% ...and hierarchies
if (x>2)
    fprintf('x is more than 2\n')
    if (x<10)
        fprintf('x less than 10\n')
    end
    if (y>4)
        fprintf('y is more than 4\n')
    else
        if (y>=1)
            fprintf('y is at least 1\n')
        end
    end
end

%% Loops
% For loops : will be repeated a pre-defined number of times

for i=[1 2 3] % THREE times
    fprintf(['I ran ' num2str(i) ' times\n']);
end
   
for i=[5 6 8] % Still THREE times!
    fprintf(['I ran the code, i= ' num2str(i) '\n']);
end

% While loops: will be repeated as long as a condition is met
x=1;
while x<10
    x=x+1;
end
x