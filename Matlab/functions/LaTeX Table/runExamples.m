% This script runs two simple examples of latexTable.m
clc; clear input;

%% Example 1: using an numerical array as data input
fprintf('Example 1: using an array as data input\n\n');

% numeric values you want to tabulate:
% this field has to be an array or a MATLAB table
% in this example we use an array
input.data = [1.12345 NaN 3.12345; ...
    4.12345 5.12345 6.12345; ...
    7.12345 8.12345 9.12345; ...
    10.12345 11.12345 12.12345];

% Optional fields:

% Set column labels (use empty string for no label):
input.tableColLabels = {'col1','col2','col3'};
% Set row labels (use empty string for no label):
input.tableRowLabels = {'row1','row2','','row4'};

% Switch transposing/pivoting your table:
input.transposeTable = 0;

% Determine whether input.dataFormat is applied column or row based:
input.dataFormatMode = 'column'; % use 'column' or 'row'. if not set 'colum' is used

% Formatting-string to set the precision of the table values:
% For using different formats in different rows use a cell array like
% {myFormatString1,numberOfValues1,myFormatString2,numberOfValues2, ... }
% where myFormatString_ are formatting-strings and numberOfValues_ are the
% number of table columns or rows that the preceding formatting-string applies.
% Please make sure the sum of numberOfValues_ matches the number of columns or
% rows in input.tableData!
%
input.dataFormat = {'%.3f',2,'%.1f',1}; % three digits precision for first two columns, one digit for the last

% Define how NaN values in input.tableData should be printed in the LaTex table:
input.dataNanString = '-';

% Column alignment in Latex table ('l'=left-justified, 'c'=centered,'r'=right-justified):
input.tableColumnAlignment = 'c';

% Switch table borders on/off:
input.tableBorders = 1;

% LaTex table caption:
input.tableCaption = 'MyTableCaption';

% LaTex table label:
input.tableLabel = 'MyTableLabel';

% Switch to generate a complete LaTex document or just a table:
input.makeCompleteLatexDocument = 1;

% call latexTable:
latex = latexTable(input);


%% Example 2: using a MATLAB table as data input

% Please note: since the table datatype was introduced in MATLAB version r2013b,
% you cannot use this feature in older versions of MATLAB!
% Check MATLAB version:
DateNumberThisVersion = datenum(version('-date'),'mmmm dd, yyyy');
if DateNumberThisVersion < 735459 % MATLAB r2013b release day was datenumber 735459
    fprintf('\n\nCannot run example 2: This MATLAB version does not support datatype ''table''!\n');
    break;
end

fprintf('\n\nExample 2: using MATLAB table datatype as data input\n\n');

% Set up a MATLAB table (similar to example used in MATLAB docs):
% Please note that the resulting LaTex table is row-based, not
% column-based. So the LaTex table is a 'transposed' copy of the MATLAB table.
LastName = {'Smith';'Johnson';'Williams';'Jones';'Brown'};
Age = [38;43;38;40;49];
Height = [71;69;64;67;64];
Weight = [176;163;131;133;119];
T = table(Age,Height,Weight,'RowNames',LastName);

% Now use this table as input in our input struct:
input.data = T;

% Set the row format of the data values (in this example we want to use
% integers only):
input.dataFormat = {'%i'};

% Column alignment ('l'=left-justified, 'c'=centered,'r'=right-justified):
input.tableColumnAlignment = 'c';

% Switch table borders on/off:
input.tableBorders = 1;

% Switch to generate a complete LaTex document or just a table:
input.makeCompleteLatexDocument = 1;

% Now call the function to generate LaTex code:
latex = latexTable(input);
