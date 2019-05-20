%% Declaring your own functions

function [m,s]=my_function3(a,b)
    figure;
    plot(a,b,'+');
    m=mean(b);
    s=std(b);
    hold on;
    line([min(b) max(b)],[m m],'color','r')
    line([min(b) max(b)],[m+s m+s],'color','r','linestyle','--')
    line([min(b) max(b)],[m-s m-s],'color','r','linestyle','--')
end