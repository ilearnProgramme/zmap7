function [bValue, bStdDev, aValue] =  calc_bmemag(magnitudes, binInterval, nanOption)
    % a- and b-value based on the maximum likelihood estimation (with b-value's std dev)
    %
    % [ bValue, bStdDev, aValue] =  calc_bmemag(magnitudes , binInterval)
    %
    % Calculates the mean magnitute, the b-value based
    % on the maximum likelihood estimation, the a-value and the
    % standard deviation of the b-value
    %
    % Input parameters:
    %   magnitudes      column vector of magnitudes
    %   binInterval     Binning of the earthquake magnitudes
    %   nanOption       'includenan' or 'omitnan' describes how to treat nan magnitude values
    %
    % Output parameters:
    %   bValue          b-value
    %   bStdDev         Standard deviation of b-value
    %   aValue          a-value
    %
    % vectorized, nans are ignored
    
    % Copyright (C) 2003 by Danijel Schorlemmer based on Stefan Wiemer's code,
    % now modified by CGReyes
    %
    % This program is free software; you can redistribute it and/or modify
    % it under the terms of the GNU General Public License as published by
    % the Free Software Foundation; either version 2 of the License, or
    % (at your option) any later version.
    %
    % This program is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    % GNU General Public License for more details.
    %
    % You should have received a copy of the GNU General Public License
    % along with this program; if not, write to the
    % Free Software Foundation, Inc.,
    % 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
         
    % Set the default value if not passed to the function

    if ~exist('nanOption','var')
        nanOption = 'omitnan';
    end
    if iscolumn(magnitudes) 
        % ok
        n = size(magnitudes,1);
    else
        n = sum(~isnan(magnitudes), 1);
    end
    % Calculate the minimum and mean magnitude, length of catalog
    minMag = min(magnitudes);
    meanMag = sum(magnitudes, nanOption) ./ n;
    
    % Calculate the b-value (maximum likelihood)
    bValue = (1 ./ (meanMag + binInterval .* 0.5 - minMag) ) .* log10(exp(1));
    if nargout<=1
        return
    end
    % Calculate the standard deviation
    
    bVariance_by_n = var(magnitudes - meanMag, nanOption) ./ n; %actual denominator becomes (n-1*n)
    bStdDev = 2.30 .* sqrt(bVariance_by_n) .* bValue .^ 2;
    if nargout==2
        return
    end
    % Calculate the a-value
    aValue = log10(n) + bValue .* minMag;
end