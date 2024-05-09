function plot_correlation(d,roi, plot)

if strcmpi(plot, 'HC')

    figure('Name','HC');
    sgt = sgtitle('Healthy Controls');
    sgt.FontSize = 25;
    
    subplot(1,2,1)
    scatter(d.HC_metadata.acute_mean_sound_lo, d.HC_metadata.acute_mean_thumb_lo)
    l = lsline;
    set(l,'LineWidth', 2)
    ax = gca;
    ax.YLim = [0 100];
    ax.XLim = [0 100];
    xlabel('Sound low ', 'FontSize', 15)
    ylabel('Pressure low', 'FontSize', 15)
    legend('0.77', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')

    subplot(1,2,2)
    scatter(d.HC_metadata.acute_mean_sound_hi, d.HC_metadata.acute_mean_thumb_hi)
    l = lsline;
    set(l,'LineWidth', 2)
    ax.YLim = [0 100];
    ax.XLim = [0 100];
    xlabel('Sound high', 'FontSize', 15) 
    ylabel('Pressure high', 'FontSize', 15) 
    legend('0.66', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')
    hold on

elseif strcmpi(plot, 'CLBP')
    
    figure('Name','CLBP');
    sgt = sgtitle('Chronic Back Pain');
    sgt.FontSize = 25;
    
    subplot(1,2,1)
    scatter(d.CLBP_metadata.acute_mean_sound_lo, d.CLBP_metadata.acute_mean_thumb_lo)
    l = lsline;
    set(l,'LineWidth', 2)
    ax = gca;
    ax.YLim = [0 100];
    ax.XLim = [0 100];
    xlabel('Sound low ', 'FontSize', 15)
    ylabel('Pressure low', 'FontSize', 15)
    legend('0.25', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')
    
    subplot(1,2,2)
    scatter(d.CLBP_metadata.acute_mean_sound_hi, d.CLBP_metadata.acute_mean_thumb_hi)
    l = lsline;
    set(l,'LineWidth', 2)
    ax.YLim = [0 100];
    ax.XLim = [0 100];
    xlabel('Sound high', 'FontSize', 15) 
    ylabel('Pressure high', 'FontSize', 15) 
    legend('0.22', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')
    hold on

elseif strcmpi(plot, 'CLBP_clinical')
    
    figure('Name','CLBP');
    sgt = sgtitle('Chronic Back Pain');
    sgt.FontSize = 25;

    subplot(2,2,1)
    scatter(d.CLBP_metadata.pain_avg, d.CLBP_metadata.acute_mean_sound_lo)
    ax1 = gca;
    ax1.YLim = [0 100];
    ax1.XLim = [0 10];
    l = lsline;
    set(l,'LineWidth', 2)
    xlabel('Average Pain (BPI)', 'FontSize', 15)
    ylabel('Sound low', 'FontSize', 15)
    legend('0.38', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')
    
    subplot(2,2,2)
    ax2 = gca;
    ax2.YLim = [0 100];
    ax2.XLim = [0 10];
    scatter(d.CLBP_metadata.pain_avg, d.CLBP_metadata.acute_mean_sound_hi)
    
    l = lsline;
    set(l,'LineWidth', 2)
    xlabel('Average Pain (BPI)', 'FontSize', 15) 
    ylabel('Sound high', 'FontSize', 15) 
    legend('0.30', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')


    subplot(2,2,3)
    scatter(d.CLBP_metadata.spon_pain_rating_mean, d.CLBP_metadata.acute_mean_sound_lo)
    l = lsline;
    set(l,'LineWidth', 2)
    ax3 = gca;
    ax3.YLim = [0 100];
    ax3.XLim = [0 100];
    xlabel('Spontaneous Pain', 'FontSize', 15) 
    ylabel('Sound low', 'FontSize', 15) 
    legend('0.23', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')

    subplot(2,2,4)
    scatter(d.CLBP_metadata.spon_pain_rating_mean, d.CLBP_metadata.acute_mean_thumb_lo)
    l = lsline;
    set(l,'LineWidth', 2)
    ax4 = gca;
    ax4.YLim = [0 100];
    ax4.XLim = [0 100];
    xlabel('Spontaneous Pain', 'FontSize', 15) 
    ylabel('Pressure low', 'FontSize', 15) 
    legend('0.27', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')

   
elseif strcmpi(plot, 'brain_behavior')

    figure('Name','CLBP');
    sgt = sgtitle('Chronic Back Pain');
    sgt.FontSize = 25;

    subplot(1,2,1)
    scatter(d.CLBP_metadata.acute_mean_sound_lo, roi.A1.clbp_s_l)
    ax1 = gca;
    ax1.XLim = [0 100];
    l = lsline;
    set(l,'LineWidth', 2)
    xlabel('Sound low', 'FontSize', 15)
    ylabel('Primary auditory cortex activity', 'FontSize', 15)
    legend('0.32', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')
    
    subplot(1,2,2)
    ax2 = gca;
    ax2.XLim = [0 100];
    scatter(d.CLBP_metadata.acute_mean_sound_hi, roi.A1.clbp_s_h)
    l = lsline;
    set(l,'LineWidth', 2)
    xlabel('Sound high', 'FontSize', 15)
    ylabel('Primary auditory cortex activity', 'FontSize', 15)
    legend('0.25', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')


    figure('Name','HC');
    sgt = sgtitle('Healthy Controls');
    sgt.FontSize = 25;

    subplot(1,2,1)
    scatter(d.HC_metadata.acute_mean_sound_lo, roi.A1.hc_s_l)
    ax1 = gca;
    ax1.XLim = [0 100];
    l = lsline;
    set(l,'LineWidth', 2)
    xlabel('Sound low', 'FontSize', 15)
    ylabel('Primary auditory cortex activity', 'FontSize', 15)
    legend('0.31', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')
    
    subplot(1,2,2)
    ax2 = gca;
    ax2.XLim = [0 100];
    scatter(d.HC_metadata.acute_mean_sound_hi, roi.A1.hc_s_h)
    l = lsline;
    set(l,'LineWidth', 2)
    xlabel('Sound high', 'FontSize', 15)
    ylabel('Primary auditory cortex activity', 'FontSize', 15)
    legend('0.42', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')



elseif strcmpi(plot, 'brain_clinical')

    figure('Name','CLBP');
    sgt = sgtitle('Chronic Back Pain');
    sgt.FontSize = 25;

    subplot(1,2,1)
    scatter(d.CLBP_metadata.pain_avg, roi.dorsal_insula.clbp_s_l)
    ax1 = gca;
    ax1.XLim = [0 10];
    l = lsline;
    set(l,'LineWidth', 2)
    xlabel('Average Pain (BPI)', 'FontSize', 15)
    ylabel('Dorsal insula activity', 'FontSize', 15)
    legend('0.20', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')
    
    subplot(1,2,2)
    ax2 = gca;
    ax2.YLim = [0 100];
    ax2.XLim = [0 10];
    scatter(d.CLBP_metadata.spon_pain_rating_mean, roi.mPFC.clbp_s_l)
    l = lsline;
    set(l,'LineWidth', 2)
    xlabel('Spontaneous clinical pain', 'FontSize', 15) 
    ylabel('medial prefrontal cortex activity', 'FontSize', 15) 
    legend('0.20', 'Location', 'northwest', 'FontSize', 15)
    legend('boxoff')


end