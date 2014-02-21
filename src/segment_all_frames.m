



for i = options.begin_frame:options.end_frame
    tic; fprintf('Segmenting frame %d...', i);
    bgs_this = bgs_frame(bg_model, i, options);
    bgs{i} = bgs_this;
    toc;
end

save('all_backgrounds.mat', 'bgs');
disp('Done');
