function spotFlag = uLCDGridSpotController(state)
    global u
    uStim=state.handles{1};
    %create spot as soon as possible during epoch
    if state.time >= 0 && uStim.spotFlag
        u.spot_white(uStim.centerX,uStim.centerY,uStim.spotRadius);
        uStim.spotFlag=0;
    %clear screen after led has flashed
    elseif state.time > (uStim.preTime+uStim.stimTime) && uStim.clearFlag
        u.clear;
        uStim.clearFlag=1;
    end
    spotFlag=uStim.spotFlag;
end
