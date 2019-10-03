% PLwriteSVG - Writes a SVG-file of a PL or CPL
%	(by Mattias F. Traeger, SG-Library, 2015-OCT-22;
%    last changes by Christina M. Hein, 2016-JAN-25)
%
%   This file writes a point list (PL) or a closed polygon list (CPL) in a
%   SVG-file.
%   
%   PLwriteSVG(SG.CPL,'fName','SVG-test','rgbList',MyList,'lineWidth',1)
%
%   PLwriteSVG(obj,varargin,rgbList)
%   === INPUT PARAMETERS ===
%   'obj':      Array with PL or CPL. Arrays Have to be separated with a 
%               line of NaN, e.g. obj=[CPL1;NaN NaN;PL2;NaN NaN;PL3]
%   'fName':    Name of the SVG-file without extension '.svg'
%               default is DATE-TIME.svg
%   'fPath':    Desired path to save the SVG-file
%               default is the current folder
%   'rgbList':  List with dimension nx3 that contains rgb-definitions of
%               process colors. These colors are used for laser cutting in 
%               rising order.
%               default rgb list for lasercutting with the Speedy 400 flexx
%               (Trotec Laser GmbH, Austria)
%   'rgbStart': The first process color for cutting (no engraving)
%               default is 2
%   'sort':     Option to sort the contours from inner to outer ones.
%               default is 1 (ON).
%   'lineWidth':Line width in svg.
%               default is 0.01 mm

function PLwriteSVG(obj,varargin)
%% default values
t = datetime('now','Format','yyyy-MM-dd_HH-mm-ss');
fname = [char(t),'.svg'];
rgbStart = 2;
lineWidth = 0.01;
sort = 1;

% standard process colors for lasercutting with the Speedy 400 flexx
% (Trotec Laser GmbH, Austria)
rgbList = [ ...
    0   0	0;      % 1: reserved for engraving
    255	0	0;      % 2
    0	0	255;    % 3
    51	102 255;    % 4
    0   255 255;    % 5
    0   255 0;      % 6
    0   153 51;     % 7
    0   102 51;     % 8
    153 153 51;     % 9
    153 102 51;     % 10
    102 51  0;      % 11
    102 0   102;    % 12
    153 0   204;    % 13
    255 0   255;    % 14
    255 102 0;      % 15
    255 255 0   ];  % 16

%% input values

for vn=1:2:nargin-1;
    var=varargin{vn};
    switch var
        case 'fName'
            fname=[varargin{vn+1},'.svg'];
        case 'fPath'
            % TODO
            fpath=varargin{vn+1};
            fname=[fpath,'\',fname];
        case 'rgbList'
            rgbList = varargin{vn+1};
        case 'rgbStart'
            rgbStart = varargin{vn+1};
        case 'sort'
            sort = varargin{vn+1};
        case 'lineWidth'
            lineWidth = varargin{vn+1};
        otherwise
            error(['Unknown input parameter: ', var])
    end
end

%% error messages
if size(obj,2)~=2 || size(obj,1)<2
    error('The input object has to be a point list with the dimension nx2 and at least n=2.')
elseif isnumeric(obj)~=1
    error('The point list entries have to be numeric.')
end

if size(rgbList,2)~=3
    error('rgbList to be a nx3 array.')
elseif size(rgbList,1)<1
    error('rgbList need at least one color definition.')
elseif isnumeric(rgbList)~=1
    error('only numeric in rgbList allowed.')
end

%% adjust coordinate system
% translate all points so that smallest x and y values are zero.
% transform coordinate so that its origin is in the upper left corner,
% x-axis points to the right, y-axis points downwards. 
Mmin = min(obj)-2*lineWidth; Mmax = max(obj)+2*lineWidth;
dY = abs(Mmax(2)-Mmin(2));
obj = [obj(:,1)-Mmin(1),abs(obj(:,2)-Mmin(2)-dY)];
xmax = Mmax(1)-Mmin(1); ymax = Mmax(2)-Mmin(2);

%% 
% separate the different PL-contours in obj
PLsep = struct('PL',[],'order',[]);
countPL = 1; line = 1;
for i=1:length(obj)
    if isequaln(obj(i,:),[NaN NaN])~=1
        PLsep(countPL).PL(line,:) = obj(i,:);
        PLsep(countPL).order = rgbStart;
        line = line+1;
    elseif isequaln(obj(i,:),[NaN NaN])==1
        countPL = countPL+1;
        line = 1;
    end
end

%%
% adjust the order of contours for cutting from inside to outside. starting
% with the first process color for cutting, n=2, rgb=[255 0 0].
if sort==1
    for i=1:countPL
        for j=1:countPL
            if i~=j % do not check identical contour
                if CPLinsideCPL(PLsep(i).PL,PLsep(j).PL) == 1
                    % second PL inside first PL
                    if PLsep(i).order < length(rgbList)
                        PLsep(i).order = PLsep(i).order+1;
                    else
                        warning('Only %i process colours available.',length(rgbList))
                    end
                end
            end
        end
    end
end

% open new file with writing rights
fid = fopen(fname, 'w');

% write SVG header
fprintf(fid, '<svg\tversion="1.1"\n\t\txmlns="http://www.w3.org/2000/svg"\n');
fprintf(fid, '\t\twidth="%7.3fmm" height="%7.3fmm"\n', xmax, ymax);
fprintf(fid, '\t\tviewBox="0 0 %7.3f %7.3f" ', xmax, ymax);
fprintf(fid, '>\n');
% write PL contour as group
fprintf(fid, '<g\n');
for i=1:countPL
    writePL = PLsep(i).PL;
    writeO = PLsep(i).order;
    fprintf(fid, ' <polyline\n');
    fprintf(fid, '\tfill="none"\n');
    fprintf(fid, '\tstroke-width="%3.3fmm"\n',lineWidth);
    fprintf(fid, '\tstroke="rgb(%i,%i,%i)"\n',rgbList(writeO,1),rgbList(writeO,2),rgbList(writeO,3));
    fprintf(fid, '\tpoints="\n');
    for i=1:length(writePL)
        fprintf(fid, '\t\t%7.3f,%7.3f', writePL(i,1),writePL(i,2));
        if i~=length(writePL)
            fprintf(fid, '\n');
        end
    end
    fprintf(fid, '" />\n');
end
fprintf(fid, '</g>\n');
% end SVG definition
fprintf(fid, '</svg>');
% close file
fclose(fid);

end

