function [ totalStroke ] = parseOneSvgToPts( D )
[ bezierCurveData, transformStruct ] = parseStrokePath( D );
tradjCell = {};
for i = 1 : length(bezierCurveData)
    tradjCell{end+1} = parsePathLine( bezierCurveData{i} );
end
f = tradjCell;
t1 = linspace(0,1,10);
t2 = linspace(0,1,2);
totalStroke = {};
for i = 1 : length(f)
    oneStroke = [];
    tradj = f{i};
    tradj = formatLine(tradj);
    splited = splitStr(tradj, ' ');
    startType = splited{1}(1);
    if strcmp(startType, 'M') ~= 1
        error('start error');
    end
    bpoints = [str2num(splited{1}(2:end)); -str2num(splited{2}(1:end))];
    
    j = 3;
    while j <= length(splited)-1
        t = t1;
        subStokType = splited{j}(1);
        switch subStokType
            case 'C'
                control_point1 = [str2num(splited{j}(2:end)); -str2num(splited{j+1}(1:end))];
                control_point2 = [str2num(splited{j+2}(1:end)); -str2num(splited{j+3}(1:end))];
                end_point = [str2num(splited{j+4}(1:end)); -str2num(splited{j+5}(1:end))];
                if sqrt(sum((bpoints - end_point).^2)) < 15
                    t = t2;
                end
                pts = kron((1-t).^3,bpoints) + kron(3*(1-t).^2.*t,control_point1) + kron(3*(1-t).*t.^2,control_point2) + kron(t.^3,end_point);
%                 plot(pts(1,:), pts(2,:), 'r.'); hold on;
                oneStroke = [oneStroke [pts(1,:);-pts(2,:)]];
                j = j+6;
                bpoints = end_point;
            case 'L'
                end_point = [str2num(splited{j}(2:end)); -str2num(splited{j+1}(1:end))];
                if sqrt(sum((bpoints - end_point).^2)) < 15
                    t = t2;
                end
                pts = kron( (1-t), bpoints) + kron( t, end_point);
%                 plot(pts(1,:), pts(2,:), 'r.'); hold on;
                oneStroke = [oneStroke [pts(1,:);-pts(2,:)]];
                j = j + 2;
                bpoints = end_point;
            otherwise
                error(subStokType);
        end
    end
    oneStroke(3,:) = zeros(1,size(oneStroke,2));
    oneStroke = (oneStroke+1);
    oneStroke = transformStruct{3}.matrix * (transformStruct{2}.matrix * (transformStruct{1}.matrix * oneStroke));
    totalStroke{end+1,1} = round(oneStroke(1:2,:));
end

end

function [ bezierCurveData, transformStruct ] = parseStrokePath( D )
sketchData = D;
transformData = sketchData{5};
transformStruct = parseTransformLine(transformData);
bezierCurveData = sketchData(6:end-3);
end

function [ tradj ] = parsePathLine( pathLine )
%line = '<path id="0" d="M430 191 C430 191 423.7463 177.223 417 172 C411.6752 167.8776 407.6824 167.1385 399 167 C317.3769 165.6975 312.945 165.453 229 169 C207.6314 169.9029 207.3312 173.4692 186 176 C178.2132 176.9239 170 176 170 176 "/>';
line = strtrim(pathLine);
flag = 0;
for i = 1 : length(line)
    switch line(i)
        case ' '
            if mod(flag, 2) == 0
                line(i) = '_';
            end
        case '"'
            flag = flag + 1;
        otherwise
    end
end
splited = splitStr(line, '_');
tradj = splitStr(splited{3}, '"');
tradj = tradj{2};
end

function [ transformStruct ] = parseTransformLine( transformData )
    transformStruct = {};
    line = transformData;
    line = strtrim(line);
    flag = 0;
    for i = 1 : length(line)
        switch line(i)
            case ' '
                if mod(flag, 2) == 0
                    line(i) = '_';
                end
            case '"'
                flag = flag + 1;
            otherwise
        end
    end
    splited = splitStr(line, '_');
    transformAttr = splited{2};
    transformSplited = splitStr(transformAttr, '"');
    transformSeq = transformSplited{2};
    transforms = splitStr(transformSeq, ' ');
    for i = 1 : length(transforms)
        tmp = splitStr(transforms{i}, '(');
        transformName = tmp{1};
        tmp2 = splitStr(tmp{2}, ')');
        parms = tmp2{1};
        transStruct.transformName = transformName;
        transStruct.parms = parms;
        switch transformName
            case 'translate'
                splt = splitStr(parms, ',');
                matrix = [1 0 str2num(splt{1});0 1 str2num(splt{2}); 0 0 1];
                transStruct.matrix = matrix;
            case 'scale'
                matrix = [str2num(parms) 0 0; 0 str2num(parms) 0; 0 0 1];
                transStruct.matrix = matrix;
            otherwise
                error('transform error');
        end
        transformStruct{end+1} = transStruct;
    end
end


