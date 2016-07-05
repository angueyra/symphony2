function cmdCount = uLCDCenterSurroundController(state)
    fprintf('controller hi\n')
    uStim=state.handles{1};
    u=uStim.uLCD;
    cmdCount = uStim.cmdCount;
    if state.time < 0.5 %&& state.time < 0.6
        cmdCount = cmdCount + 1;
        u.spot_white(110,110,10);
    elseif state.time >= 0.5 && state.time < 0.6
        cmdCount = cmdCount + 1;
        u.ring_white(110,110,10,25);
        fprintf('made it here, only once?\n')
        disp(cmdFlag2)
    %     fprintf('This is when i would send command\n')
    %     fprintf('\tFrame = %g  ',state.frame)
    %     fprintf('Time = %g s\n',state.time)
    elseif state.time >= 0.6
        cmdCount = cmdCount + 1;
        u.clear;
    end

    uStim.cmdCount = cmdCount
end
