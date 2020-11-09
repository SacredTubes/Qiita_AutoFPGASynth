function hdlworkflowCORDIC(modelName, subsystemName, bitWidth, cordicIter)
%% Load the Model
load_system(modelName);

PrjDir = ['hdl_' modelName '_b' num2str(bitWidth) '_c' num2str(cordicIter)];
HDLTargetDir = [PrjDir '\hdlsrc'];

%% Restore the Model to default HDL parameters
%hdlrestoreparams('operators_vs_area/Sub_single');

%% Model HDL Parameters
hdlset_param(modelName, 'HDLSubsystem', [modelName '/' subsystemName]);

%% Set Model modelName HDL parameters
% hdlset_param(modelName, 'AdaptivePipelining', 'off');
% hdlset_param(modelName, 'ClockRatePipelining', 'off');
% hdlset_param(modelName, 'EnableTestpoints', 'on');
% hdlset_param(modelName, 'FloatingPointTargetConfiguration', hdlcoder.createFloatingPointTargetConfig('NativeFloatingPoint'));
% hdlset_param(modelName, 'GenerateCoSimModel', 'ModelSim');
% hdlset_param(modelName, 'GenerateValidationModel', 'on');
% hdlset_param(modelName, 'HDLGenerateWebview', 'on');
% hdlset_param(modelName, 'HierarchicalDistPipelining', 'on');
% hdlset_param(modelName, 'MaskParameterAsGeneric', 'on');
% hdlset_param(modelName, 'MinimizeClockEnables', 'on');
% hdlset_param(modelName, 'MinimizeIntermediateSignals', 'on');
% hdlset_param(modelName, 'OptimizationReport', 'on');
% hdlset_param(modelName, 'ResetType', 'asynchronous');
% hdlset_param(modelName, 'ResourceReport', 'on');
% hdlset_param(modelName, 'ShareAdders', 'on');
% hdlset_param(modelName, 'SynthesisTool', 'Altera QUARTUS II');
% hdlset_param(modelName, 'SynthesisToolChipFamily', 'Arria 10');
% hdlset_param(modelName, 'SynthesisToolDeviceName', '10AS066H1F34E1SG');
% hdlset_param(modelName, 'SynthesisToolPackageName', '');
% hdlset_param(modelName, 'SynthesisToolSpeedValue', '');
% hdlset_param(modelName, 'TargetDirectory', HDLTargetDir);
% hdlset_param(modelName, 'TargetFrequency', 200);
% hdlset_param(modelName, 'Traceability', 'on');


%% Workflow Configuration Settings
% Construct the Workflow Configuration Object with default settings
hWC = hdlcoder.WorkflowConfig('SynthesisTool','Altera QUARTUS II','TargetWorkflow','Generic ASIC/FPGA');

% Specify the top level project directory
hWC.ProjectFolder = PrjDir;

% Set Workflow tasks to run
hWC.RunTaskGenerateRTLCodeAndTestbench = true;
hWC.RunTaskVerifyWithHDLCosimulation = false;
hWC.RunTaskCreateProject = true;
hWC.RunTaskPerformLogicSynthesis = true;
hWC.RunTaskPerformMapping = true;
hWC.RunTaskPerformPlaceAndRoute = false;
hWC.RunTaskAnnotateModelWithSynthesisResult = false;

% Set properties related to 'RunTaskGenerateRTLCodeAndTestbench' Task
hWC.GenerateRTLCode = true;
hWC.GenerateTestbench = false;
hWC.GenerateValidationModel = false;

% Set properties related to 'RunTaskCreateProject' Task
hWC.Objective = hdlcoder.Objective.None;
hWC.AdditionalProjectCreationTclFiles = '';

% Set properties related to 'RunTaskPerformMapping' Task
hWC.SkipPreRouteTimingAnalysis = false;

% Set properties related to 'RunTaskPerformPlaceAndRoute' Task
hWC.IgnorePlaceAndRouteErrors = false;

% Set properties related to 'RunTaskAnnotateModelWithSynthesisResult' Task
hWC.CriticalPathSource = 'pre-route';
hWC.CriticalPathNumber =  1;
hWC.ShowAllPaths = false;
hWC.ShowDelayData = false;
hWC.ShowUniquePaths = false;
hWC.ShowEndsOnly = false;

% Validate the Workflow Configuration Object
hWC.validate;

%% Run the workflow
hdlcoder.runWorkflow([modelName '/' subsystemName], hWC);
