%Mean Square Error
%Robert Kuramshin
function [error]=Mean_Square_Error(y,y_predicted)
    error = norm(y_predicted-y)^2/length(y);
end