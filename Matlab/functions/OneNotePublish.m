function oneNotePublish(mfilename,pageTitle,opts)
% OneNotePublish - publishes an m-file to OneNote.
%
% OneNotePublish(mfilename, pageTitle, opts)
% mfilename: full path to m-file to be run.
% pageTitle: (Optional) title for page in OneNote (Default is mfile name)
% opts: (Optional) Options to pass to matlab Publish function.

[mfilepath, mfilenamepart] = fileparts(mfilename); % Split m-file into path, filename and .m component.

if nargin < 2
    pageTitle = mfilename;
end

opts.format = 'html';
opts.outputDir = sprintf('%s%s',tempdir,datestr(now,30));
publish(mfilename,opts);

% Start OneNote ActiveX Server
onApp = actxserver('OneNote.Application');

% Get the location of a new page in the Unfiled Notes section
onHierarchy = onApp.GetHierarchy('',1);                     % slBackUpFolder = 0, slUnfiledNotesSection = 1, slDefaultNotebookFolder = 2
unfiledSectionPath = onApp.GetSpecialLocation(1);           % slBackUpFolder = 0, slUnfiledNotesSection = 1, slDefaultNotebookFolder = 2
unfiledID = onApp.OpenHierarchy(unfiledSectionPath, '', 0); % cftNone = 0, cftNotebook = 1, cftFolder = 2, cftSection = 3
try
    newPageID = onApp.CreateNewPage(unfiledID,0); % npsDefault = 0, npsBlankPageWithTitle = 1, npsBlankPageNoTitle = 2
catch
    error('Could not create a new page!');
end

% Create XML text for importing
xml2importBase = sprintf('<?xml version="1.0"?>\n<one:Section xmlns:one="http://schemas.microsoft.com/office/onenote/2007/onenote" ID="'); 
xml2importBase = sprintf('%s%s">\n',xml2importBase, unfiledID); 
xml2importBase = sprintf('%s<one:Page ID="%s">\n', xml2importBase, newPageID); 
xml2importBase = sprintf('%s<one:Title>\n<one:OE>\n<one:T><![CDATA[%s]]></one:T>\n</one:OE>\n</one:Title>\n', xml2importBase,pageTitle); 

tailXml = sprintf('</one:Page>\n</one:Section>'); 

% This line imports the actual matlab code (m-file) into OneNote.
% xml2import = sprintf('%s<one:InsertedFile pathSource="%s"></one:InsertedFile>\n%s',xml2importBase, mfilename,tailXml); 


htmlFID = fopen([opts.outputDir,'\',mfilenamepart,'.html']);
htmlText = fread(htmlFID,'uint8=>char');
htmlText = strrep(htmlText(:)','src="',sprintf('src="%s\\',opts.outputDir));
% xml2import = sprintf('%s<Outline>\n<Html><Data><![CDATA[%s]]></Data></Html>\n</Outline>\n',xml2importBase, htmlText,tailXml);
xml2import = sprintf('%s<one:Outline><one:OEChildren><one:HTMLBlock><one:Data><![CDATA[%s]]></one:Data></one:HTMLBlock></one:OEChildren></one:Outline>\n%s',xml2importBase, htmlText,tailXml);

%%% Matlab XML file is stored in tempdir\mfilename.xml
%%% Insert code to convert Matlab XML to OneNote XML here

% Upload XML to OneNote
try 
    onApp.UpdateHierarchy(xml2import); 
    rmdir(opts.outputDir,'s');
    succeeded = true; 
catch
    % onApp.DeleteHierarchy(importedPageID, DateTime.MinValue); 
end