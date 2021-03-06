function PLV_Pos_ch = find_earliest_PLV_2(PLV, plv_time, Baseline_Time_max, pre_onset_time , start_onset )

Multiplied_STD_inThresh = 6;
%%
ix_selected = find( ( plv_time >=  (start_onset - pre_onset_time) ) & ( plv_time <  start_onset ) );
ix_Baseline = find( (plv_time >= 0 ) & ( plv_time <=  Baseline_Time_max ));
%%
tmp = PLV (:, ix_Baseline );
mtmp = mean (tmp , 2);
stdtmp = std ( tmp, 0 , 2);
Thre = mtmp + Multiplied_STD_inThresh * stdtmp ;

%%
h = figure;
PLVn = ( PLV - repmat( mtmp , [1 size(PLV,2) ]) ) ./ repmat( Multiplied_STD_inThresh*stdtmp , [1 size(PLV,2) ] );
imagesc(PLVn);
ylabel( 'channels');
xlabel('time [s]')
title ( ['Normalized PLV [ (PLV - mean) / ', num2str(Multiplied_STD_inThresh) ,'xSTD ] ' ] )
colorbar

h = figure;
imagesc(PLVn > 1 );
ylabel( 'channels');
xlabel('time [s]')
title ('Normalized PLV > 1 ')
colorbar

%%
PLV2 = PLV(:,ix_selected);

for ch = 1: size (PLV2, 1)
    significant_ch {ch}= find(PLV2(ch,:)> Thre(ch));
end

for ch = 1: size(PLV2,1)
    emp(ch) = isempty(significant_ch{ch});
end
ch_higher_PLV = find(emp ==0);

if isempty(ch_higher_PLV)
    PLV_Pos_ch = [];
else
    
    for i= 1:length(ch_higher_PLV)
        min_vec(i) = min(significant_ch{ch_higher_PLV(i)});
    end
    
    [min_vec_sort, min_vec_sort_index] = sort(min_vec, 'ascend');
    ealy_PLV_ch = ch_higher_PLV(min_vec_sort_index);
    earliest_PLV_ch = ch_higher_PLV(find(min_vec == min (min_vec)));
    
    PLV_Pos_ch = sort(ealy_PLV_ch);
end
end

