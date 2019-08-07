function param = SetConfig()
    % set path
    dataPath = 'D:\HTAction18_renamePair_NEW\frames\'; 
    nameParam = 'HT_1_cam_0_';

    % set Pameter    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    startPhase = 0; 
    startAction = 1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    imgWidth = 480;
    imgHeight = 270;
    imgNumDigit = '%.5d'; % 00001 ~ 99999 %.5d
    
    % set cam
    pickCam = {'0';};
            
    % set Action
    pickAction = {
        '101_HT_JumpingJack';
                    '102_HT_BurpeeTest';
                    '103_HT_Walking';
                    '104_HT_SingleArmLow';
                    '105_HT_KettlebellSwing';
                    '106_HT_CrabReach';
                    '107_HT_Squat';
                    '108_HT_FrontLunge';
                    '109_HT_SideLunge';
                    '110_HT_LegRaise';
                    '111_HT_SingleLegDeadlift';
                    '112_HT_MountainClimber';
                    '113_HT_HipExtensionKneeTuck';
                    '114_HT_Airplane';
                    '115_HT_SplitJump';
                    '116_HT_SidePlankLeglift';
                    '117_HT_Bridge';
                    '118_HT_SingleLegToeTouch';
                    '119_HT_Pendulumleg';
                    '120_HT_HipLiftMarch';
                    '121_HT_SitUp';
                    '122_HT_PlankWalking';
                    '123_HT_BirdDog';
                    '124_HT_SidePlankKneeDrives';
                    '125_HT_PlankAlternatingLeglifts';
                    '126_HT_DumbbellDeadLift';
                    '127_HT_Plank';
                    '128_HT_SidePlank';
                    '129_HT_GoodMorningExercise';
                    '130_HT_ArmWalking';
                    '131_HT_BottomUpSquat';
                    '132_HT_TwistedSitUps';
                    '133_HT_PushUp';
                    '134_HT_TricepKickbacks';
                    '135_HT_ReverseFly';
                    '136_HT_FrontRaise';
                    '137_HT_LateralRaise';
                    '138_HT_OverheadTricepExtension';
                    '139_HT_ReverseCurl';
                    '140_HT_HammerCurl';
                    '141_HT_BicepCurlHalfWayup';
                    '201_WAKE_StandedStretching';
                    '202_WAKE_StandedArmStretching';
                    '203_WAKE_StandedShoulderStretching';
                    '204_WAKE_ArmSwingStretching';
                    '205_WAKE_StandedTimePose';
                    '206_WAKE_StandedCrossArms';
                    '207_WAKE_BendingAndRestingMotion';
                    '208_WAKE_SquatDownAndRest';
                    '209_WAKE_SitDownCouch';
                    '301_OLD_OverheadArmRaise';
                    '302_OLD_ChairDip';
                    '303_OLD_ChairStand';
                    '304_OLD_LegStraightening';
                    '305_OLD_SideLegRaise';
                    '306_OLD_Balance_Walk';
                    '307_OLD_HeelToToe';
                    '308_OLD_BackOFLeg';
                    '309_OLD_Thigh';
                    '310_OLD_Neck';};
                

    param.reSemanticStruct = struct('keyWord',{},'numPhase',zeros(1),...
                        'numImg',zeros(1),'isErr',zeros(1),'reActPoint',zeros(1));

    param.name = nameParam;
    param.srcPath = dataPath;
    param.h = imgHeight; % vidHeight
    param.w = imgWidth; % vidWidth
    param.cam = pickCam;
    param.action = pickAction;
    param.digit = imgNumDigit;
    param.keyWord = 'none';
    param.folderPath = 'none';
    param.numPhase = 0;
    param.srtPhase = startPhase;
    param.srtAction = startAction;
    
    
end
