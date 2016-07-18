function pop = VisibleController(state)
    global a
    if state.frame == 1
        a.clear;
    end
    if state.time >= .5 && state.time < 1.5
        if ~flag
            st=state;
            flag=1;
        end 
        pop=1;
        a.ring_white(110,110,15,20);
    else
        pop=0;
        a.spot_white(110,110,10);
    end
end
