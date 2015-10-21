classdef msdanalyzer
    %%MSDANALYZER a class for simple mean square displacement analysis.
    %
    % msdanalyzer is a MATLAB per-value class dedicated to the mean square
    % displacement analysis of single particle trajectories. After the
    % instantiation, the user can feed the object with the trajectories of
    % several particles. The class allows him to then derive the MSD
    % curves, the velocity autocorrelation functions, to plot them and fit
    % them, and possible correct for drift if required.
    %
    % If you use this tool for your work, we kindly ask you to cite the
    % following article for which it was created:
    % 
    % Tarantino et al. TNF and IL-1 exhibit distinct ubiquitin requirements
    % for inducing NEMO-IKK supramolecular structures. J Cell Biol (2014)
    % vol. 204 (2) pp. 231-45
    %
    % Jean-Yves Tinevez - Institut Pasteur, 2013 - 2014 
    % <tinevez at pasteur dot fr>
    properties (Constant)
        % Tolerance for binning delays together. Two delays will be binned
        % together if they differ in absolute value by less than
        % 10^-TOLERANCE.
        TOLERANCE = 12;
    end
    
    properties (SetAccess = private)
        % The trajectories stored in a cell array, one T x n_dim per particle
        tracks = {};
        % The dimensionality of the problem
        n_dim
        % Spatial units
        space_units;
        % Time units
        time_units
        % Stores the MSD
        msd
        % Stores the velocty correlation
        vcorr
        % Stores the linear fit of MSD vs t
        lfit
        % Stores the linear fit of the log log plot of MSD vs t
        loglogfit
        % Drift movement
        drift
    end
    
    properties (SetAccess = private, GetAccess = private, Hidden = true)
        % If false, msd needs to be recomputed
        msd_valid = false;
        % If false, vcorr needs to be recomputed
        vcorr_valid = false
        
    end
    
    
    %% Constructor
    methods
        
        function obj = msdanalyzer(n_dim, space_units, time_units)
            %%MSDANALYZER Builds a new MSD analyzer object.
            % obj = MSDANALYZER(dimensionality, space__units, time_units)
            % builds a new empty msdanalyzer object with the specified
            % dimensionality (2 for 2D, 3 for 3D, etc...), spatial units
            % and time units. Units are strings, used only for display and
            % plotting.
            
            if ~isreal(n_dim) || ~isscalar(n_dim) || n_dim < 1 || ~(n_dim == floor(double(n_dim)))
                error('msdanalyzer:BadDimensionality', ...
                    'Dimensionality must be a positive integer, got %f.', ...
                    n_dim);
            end
            obj.n_dim = n_dim;
            obj.space_units = space_units;
            obj.time_units = time_units;
        end
    end
    
    %% Private methods
    
    methods (Access = private)
        
        time = getCommonTimes(obj)
        
        delays = getAllDelays(obj, indices)
        
    end
    
    %% Static methods
    
    methods (Static, Access = private)
        
        function wm = weightedmean(x, w)
            wm = sum( x .* w) ./ sum(w);
        end
        
        function sewm = standarderrorweightedmean(x, w)
            n = numel(w);
            wbar = mean(w);
            xbar = sum( x .* w) ./ sum(w);
            sewm = n /((n-1) * sum(w)^2) * (sum( (w.*x - wbar*xbar).^2) ...
                - 2 * xbar * sum( (w-wbar).*(w.*x - wbar*xbar)) ...
                + xbar^2 * sum((w-wbar).^2));
        end
        
        H = errorShade(ha, x, y, errBar, col, transparent)
        
    end
    
    %% Static and public functions
    
    methods (Static)
        
        %ROUNDN  Round towards nearest number with Nth decimals.
        %   ROUNDN(X,N) rounds the elements of X to the nearest numbers with the
        %   precision given by N.
        %
        %   Examples:   roundn(8.73,0) = 9
        %               roundn(8.73,1) = 8.7
        %               roundn(8.73,2) = 8.73
        %               roundn(8.73,-1) = 10
        %
        %   See also ROUND
        % Jean-Yves Tinevez - MPI-CBG - August 2007
        
        function Y = roundn(X,N)
            Y = 10^(-N) .* round(X.*10^(N));
        end
        
        function newobj = pool(msda_arr)
            %%POOL Pool the data of several masanalyzer objects in a new one.
            
            if ~isa(msda_arr, 'msdanalyzer')
                error('msdanalyzer:pool:BadArgument', ...
                    'Expect arguments to be of class ''masanalyzer'', got ''%s''.',...
                    class(msda_arr))
            end
            
            n_obj = numel(msda_arr);
            
            % Check dimensionality and units consistency
            lspace_units = msda_arr(1).space_units;
            ltime_units = msda_arr(1).time_units;
            ln_dim = msda_arr(1).n_dim;
            
            for i = 2 : n_obj
                
                obj = msda_arr(i);
                if ~strcmp(obj.space_units, lspace_units)
                    error('msdanalyzer:pool:InconsistentArray', ...
                        'Element %d is inconsistent. Expected space units to be %s, got %s.', ...
                        i, lspace_units, obj.space_units)
                end
                if ~strcmp(obj.time_units, ltime_units)
                    error('msdanalyzer:pool:InconsistentArray', ...
                        'Element %d is inconsistent. Expected time units to be %s, got %s.', ...
                        i, ltime_units, obj.time_units)
                end
                if obj.n_dim ~= ln_dim
                    error('msdanalyzer:pool:InconsistentArray', ...
                        'Element %d is inconsistent. Expected dimensionality to be %d, got %d.', ...
                        i, ln_dim, obj.n_dim)
                end
                
            end
            
            all_msd = cell(n_obj,1 );
            all_vcorr = cell(n_obj,1 );
            
            for i = 1 : n_obj
                obj = msda_arr(i);
                
                obj = obj.computeDrift('velocity');
                obj = obj.computeMSD;
                obj = obj.computeVCorr;
                
                all_msd{i} = obj.msd;
                all_vcorr{i} = obj.vcorr;
            end
            
            newobj = msdanalyzer(ln_dim, lspace_units, ltime_units);
            newobj.msd = vertcat(all_msd{:});
            newobj.vcorr = vertcat(all_vcorr{:});
            newobj.msd_valid = true;
            newobj.vcorr_valid = true;
            
        end
        
    end
    
end

