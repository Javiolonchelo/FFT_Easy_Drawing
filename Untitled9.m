v_in = VideoReader('C:\Users\Javiolonchelo\Desktop\Kronk.mp4');

n = 0;
filename = 'C:\Users\Javiolonchelo\Desktop\Kronk_cut.gif';

while hasFrame(v_in)
    
    frame = readFrame(v_in);
    frame = frame(292:775,470:1910,:);
    [imind, cm] = rgb2ind(frame, 256);
    
    if n == 0
        imwrite(imind, cm, filename, 'gif', 'DelayTime', 0.02, 'Loopcount', inf);
        n = 1;
    else
        imwrite(imind, cm, filename, 'gif', 'DelayTime', 0.02, 'WriteMode', 'append');
    end
    
end
