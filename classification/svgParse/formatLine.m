function [ out ] = formatLine( line )
%line = 'M283,317C283,317 300.2512071569135,338.4537515974283 311,361C320.0336063127724,379.94854007069335 317.03990889254413,383.75739517350445 324,403C324.9607779524187,405.6562684566871 328,407.9947053281865 328,408C328,408.0021178687254 324,406 324,406';
out = 'M';
for i = 2 : length(line)
    if int32(line(i)) >= 65 && int32(line(i)) <= 90 || int32(line(i)) >= 97 && int32(line(i)) <= 122
        if int32(line(i-1)) >= 48 && int32(line(i-1)) <= 57
            out = [out ' '];
            out = [out line(i)];
        else
            out = [out line(i)];
        end
    elseif int32(line(i)) == 44
        out = [out ' '];
    else
        out = [out line(i)];
    end
end

end

