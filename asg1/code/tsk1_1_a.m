%launch via - tsk1_1_a(xtr)
function [] = tsk1_1_a(xtr)
    patches = xtr ./ 63;
    patches_std = std(patches,0,2);

    figure;
    h = histogram(patches_std,64);
    h.BinWidth = 0.5 / 64;
    title('histogram of patches standard deviations');
    xlabel('standard deviation');
    ylabel('number of patches');
end