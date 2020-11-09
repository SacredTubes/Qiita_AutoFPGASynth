modelName = 'cordicSynth0';
open_system(modelName)
subsystemName = 'CORDIC_Sin';

% bitWidth = 12;
% cordicIter = 12;
%% パラメータ設定
bitWidthParam = 8:18;       % bit幅は8~18bit
cordicIterParam = 8:18;     % CORDICの繰り返し回数は8~18回
% ただし制約がある: cordicIter <= bitWidth

%%
for n = 1:numel(bitWidthParam)
    for m = 1:numel(cordicIterParam)
        bitWidth = bitWidthParam(n)
        cordicIter = cordicIterParam(m)
        if cordicIter > bitWidth    % 制約に引っかかる場合は処理をスキップ
            disp('Skip HDL Generation')
        else
            out = sim(modelName);   % 誤差計算のためシミュレーション実行
            errorSignal = out.logsout.getElement('FxptError').Values.Data;
            stdError(n,m) = std(errorSignal)    % 標準偏差
            maxError(n,m) = max(errorSignal)    % 最大誤差
            % 自動生成されたコンパイル用スクリプトにパラメータを与えて実行
            hdlworkflowCORDIC(modelName, subsystemName, bitWidth, cordicIter)
        end
    end
end

%% Max Error Plot
bar3(maxError)
h = gca;
h.XTickLabel = num2str(bitWidthParam');
xlabel('Bit width')
h.YTickLabel = num2str(cordicIterParam');
ylabel('CORDIC iteration')
h.ZScale = 'log';
zlabel('Max error')

