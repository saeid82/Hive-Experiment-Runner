%% Copyright 2016 Saeid Shams
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

function  dstatsPlot(V, W , X, Y, Z)


    % Create figure
    figure1 = figure;

    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    plot(V, W , X, Y, Z);
    
    % Date formatted tick labels
    datetick('x','dd-MM HH:mm:ss');
    
%     function out = varname(var)
%         out = inputname(1);
%     end

    xlabel(inputname(1));
    ylabel(inputname(2));

    box(axes1,'on');
    set(axes1,'XGrid','on','YGrid','on');
    
end
