modelName = 'cordicSynth0';
subsystemName = 'CORDIC_Sin';

%% Read area report of Quartus
for n = 1:numel(bitWidthParam)
    for m = 1:numel(cordicIterParam)
        bitWidth = bitWidthParam(n);
        cordicIter = cordicIterParam(m);
        if cordicIter > bitWidth    % 制約に引っかかる場合は処理をスキップ
            % disp('Skip HDL Generation')
        else
            PrjDir = ['hdl_' modelName '_b' num2str(bitWidth) '_c' num2str(cordicIter)...
                '\quartus_prj'];
            fid = fopen([PrjDir '\CORDIC_Sin_quartus.map.rpt']);
            areaReportText = textscan(fid,'%s', 'Delimiter', '\n');
            areaReportText = areaReportText{1,1};
            fprintf('Bit Width = %d,   CORDIC Iteration = %d \n', bitWidth, cordicIter);
            for k = 1:numel(areaReportText)
                if contains(areaReportText{k,1}, 'Combinational ALUT usage for logic')||...
                    contains(areaReportText{k,1}, 'Dedicated logic registers')
                    disp(areaReportText{k,1})
                end
            end
            fclose(fid);
        end
    end
end