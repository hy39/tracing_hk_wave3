%% the Supplementary Figure S1
% 
% Use this function to plot the numbers of imported cases and undetected imported cases in Hong Kong
% 
function [] = plot_HK_imported_single_2()

totaltime = 90;
[detected_imp undetected_imp] = get_sir_import();
imp = detected_imp(1:end-1);
udet_imp = undetected_imp(1:end-1);

%%
%load('virus_hk07.mat');
virus_hk = load('dat/virus_hk07.mat');
virus = virus_hk.virus_hk07;
figure();clf
%subplot(2,2,1);
hold on;
%import cases
t = [1:totaltime+1];
tt =t(1:end-2);
n = length(tt);
current_t = 60; % 60 = 15 Aug
imp_mean = imp;
b1 = plot(tt(1:current_t),virus(tt(1:current_t),2)','o','MarkerFaceColor','r','MarkerSize',7)
b2 = plot(tt(1:end),imp_mean(1:end),'-o','MarkerFaceColor','b','color','b','linewidth',1.2);
plot(tt(current_t:end),imp_mean(current_t:end),'b--','linewidth',1.2);
udet_imp_mean = udet_imp;
udet_imp_bound = prctile(udet_imp,[2.5 97.5 25 75]);
b3 = plot(tt(1:end), udet_imp_mean(1:end),'-o','MarkerFaceColor',[0.9290, 0.6940, 0.1250],'color', [0.9290, 0.6940, 0.1250],'linewidth',1.2);

ymaxl = 50;
ll = 0:0.1:ymaxl;
plot(3*ones(length(ll),1), 0:0.1:ymaxl,'color',[0.3 0.3 0.3],'linestyle','--','linewidth',1.2);
plot(19*ones(length(ll),1), 0:0.1:ymaxl,'color',[0.3 0.3 0.3],'linestyle','--','linewidth',1.2);
plot(29*ones(length(ll),1), 0:0.1:ymaxl,'color',[0.3 0.3 0.3],'linestyle','--','linewidth',1.2);
plot((37-1)*ones(length(ll),1), 0:0.1:ymaxl,'color',[0.3 0.3 0.3],'linestyle','--','linewidth',1.2);
plot((43+1)*ones(length(ll),1), 0:0.1:ymaxl,'color',[0.3 0.3 0.3],'linestyle','--','linewidth',1.2);
set(gcf,'position',[400,350,900,600]);

lgd = legend([b1 b2 b3],{'Observed','Imported (moving average)','Exempted'});
%lgd = legend('Imported(CI:95%)','Imported(CI:50%)','Imported(mean)','Observed','Location','best');
lgd.FontSize = 18;
% set(gca,'position',[0.1,0.1,0.9,0.9]);
%xlim([1,totalt]);
xlim([1 current_t]);
ylim([0 35]);
xlabel('Date','fontsize',32);
ylabel('Daily imported cases','fontsize',32);

date0 = ([1 6 11 16 21 26 31 36 41 46 51 56]);
date = ({'17/06','22/06','27/06','02/07','07/07','12/07','17/07','22/07','27/07','01/08','06/08','11/08'});
set(gca,'FontSize',20);
set(gca,'xtick',date0,'XTickLabel',date)
xtickangle(90);
box on

ax = gca;
%%
function [detected_imp undetected_imp] = get_sir_import()


%detected_imp_ratio
i1_list = [8, 4, 3, 1, 3, 30, 16, 2, 14, 3, 1, 2, 4, 2, 28, 9, 5, 11, 8, 16, 5, 5, 8, 6, 12, 8, 11, 8, 5, 4, 8, 4, 25, 7, 3, 11, 8, 8, 7, 25, 4, 8, 5, 4, 3, 1, 1, 0, 5, 3, 4, 8, 2, 9, 2, 1, 1, 4, 2, 7, 4, 13, 1];
i1_list_avg = movmean(i1_list,5);

factor = 0.1*(1+((1:totaltime)/30)*0.18);
for tid = 1:totaltime
if tid > length(i1_list_avg)
   %if round((t - floor(t))*1000) < 10
   e1(tid) = mean(i1_list_avg);
   i1(tid) = mean(i1_list_avg)*factor(tid);
   %end 
else
   %if round((t - floor(t))*1000) < 10
   e1(tid) = i1_list_avg(tid);  
   i1(tid) = i1_list_avg(tid)*factor(tid);   
   %end
end
end

%detected_imp = [0; diff(h21)];
detected_imp = e1';
undetected_imp = i1';
end


end

