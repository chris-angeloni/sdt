addpath(genpath('~/chris-lab/code_general/'))

%% generate some figures for signal detection theory lecture

% parameters
m1 = 0;
m2 = 1;
s = .3;
x = [-2:.01:3];

% plot signal and noise distributions
plotCritCDF(x,m1,m2,s)
t(1) = text(m1,max(ylim)*.95,'Noise','HorizontalAlignment','center');
t(2) = text(m2,max(ylim)*.95,'Signal','HorizontalAlignment','center');
xlabel('x (Internal Response)'); ylabel('p(x)');

% add criterion
delete(t); hold on
criterion = .5;
plot([criterion criterion],ylim,'k--','LineWidth',1)
t = text(criterion+.1,max(ylim)*.95,'criterion')

% add decision logic
delete(t); hold on;
text(criterion+.1,max(ylim)*.95,'\rightarrow SAY "SIGNAL"',...
     'horizontalalignment','left')
text(criterion-.1,max(ylim)*.95,'SAY "NOISE" \leftarrow ',...
     'horizontalalignment','right')

% hits vs miss
clf; hold on;
plotCritCDF(x,m1,m2,s,criterion,{'hit','miss'});
xlabel('x (Internal Response)'); ylabel('p(x)');
legend({'hit','miss'}); title('Signal Present');

% cr vs fa
clf; hold on;
plotCritCDF(x,m1,m2,s,criterion,{'cr','fa'});
xlabel('x (Internal Response)'); ylabel('p(x)');
legend({'correct reject','false alarm'}); title('Signal Absent');


%% ROC animation
criteria = linspace(-1,2,20);
[auc,pHit,pFa] = analyticROC(m2,m1,s,linspace(-1,2,1000));
for i = 1:length(criteria)
    clf;
    subplot(3,1,1); hold on;
    plotCritCDF(x,m1,m2,s,criteria(i),{'hit','fa'})
    xlabel('x (Internal Response)'); ylabel('p(x)');
    title('ROC');
    
    subplot(3,1,[2 3]); hold on;
    plot(pFa,pHit,'LineWidth',2,'Color',[.5 .5 .5]);
    plot([0 1],[0 1],'k--')
    [~,ph,pf] = analyticROC(m2,m1,s,criteria(i));
    plot(pf,ph,'r.','MarkerSize',50);
    text(.8,.2,sprintf('auc = %3.2f',auc));
    xlabel('p(FA)'); ylabel('p(Hit)');
    drawnow;
    pause;
    
end


%% effects of mean shifts
clf;
crits = linspace(-1,2,1000);
ms = linspace(0,1,5);
color = [ones(5,1) repmat(linspace(.75,0,5)',1,2)];
for i = 1:length(ms)
    subplot(3,1,1); hold on;
    plotCritCDF(x,m1,ms(i),s,[],[],color(i,:))
    xlabel('x (Internal Response)'); ylabel('p(x)');
    title('Shift in Mean');
    
    subplot(3,1,[2 3]); hold on;
    plot([0 1],[0 1],'k--')
    [auc,ph,pf] = analyticROC(ms(i),m1,s,crits);
    plot(pf,ph,'Color',color(i,:));
    text(.8,.3-(.05*(i-1)),sprintf('auc = %3.2f',auc),...
         'color',color(i,:));
    xlabel('p(FA)'); ylabel('p(Hit)');
    drawnow;
    pause;
end


%% effects of noise shifts
clf;
crits = linspace(-6,6,1000);
ns = [3 2.5 2 1 .3];
color = [repmat(linspace(.75,0,5)',1,2) ones(5,1) ];
for i = length(ns):-1:1
    subplot(3,1,1); hold on;
    plotCritCDF(x,m1,m2,ns(i),[],[],color(i,:))
    xlabel('x (Internal Response)'); ylabel('p(x)');
    title('Shift in Variance');
    
    subplot(3,1,[2 3]); hold on;
    plot([0 1],[0 1],'k--')
    [auc,ph,pf] = analyticROC(m2,m1,ns(i),crits);
    plot(pf,ph,'Color',color(i,:));
    text(.8,.3-(.05*(i-1)),sprintf('auc = %3.2f',auc),...
         'color',color(i,:));
    xlabel('p(FA)'); ylabel('p(Hit)');
    drawnow;
    pause;
end
