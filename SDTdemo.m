%% generate some figures for signal detection theory lecture

% parameters
m1 = 0;
m2 = 1;
s = .3;
x = [-2:.01:3];

% plot params
lw = 3;
fsz = 24;

% plot signal and noise distributions
clf; subplot(3,1,1); hold on;
plotCritCDF(x,m1,m2,s,[],[],[],lw)
t(1) = text(m1,max(ylim)*1.05,'Noise','HorizontalAlignment','center',...
    'FontSize',fsz);
t(2) = text(m2,max(ylim)*1.05,'Signal','HorizontalAlignment','center',...
    'FontSize',fsz);
xlabel('x (Internal Response)'); ylabel('p(x)');
set(gca,'FontSize',fsz);



%% add criterion
delete(t); hold on;
criterion = .5;
plot([criterion criterion],ylim,'k--','LineWidth',lw)
t = text(criterion+.1,max(ylim)*.95,'criterion',...
    'FontSize',fsz);



%% add decision logic
delete(t); hold on;
text(criterion+.1,max(ylim)*.95,'\rightarrow SAY "SIGNAL"',...
    'horizontalalignment','left','FontSize',fsz)
text(criterion-.1,max(ylim)*.95,'SAY "NOISE" \leftarrow ',...
    'horizontalalignment','right','FontSize',fsz)



%% hits vs miss
clf; subplot(3,1,1); hold on;
plotCritCDF(x,m1,m2,s,criterion,{'hit','miss'},[],lw);
xlabel('x (Internal Response)'); ylabel('p(x)');
legend({'hit','miss'}); title('Signal Present');
set(gca,'FontSize',fsz);



%% cr vs fa
clf; subplot(3,1,1); hold on;
plotCritCDF(x,m1,m2,s,criterion,{'cr','fa'},[],lw);
xlabel('x (Internal Response)'); ylabel('p(x)');
legend({'correct reject','false alarm'}); title('Signal Absent');
set(gca,'FontSize',fsz);



%% ROC animation
criteria = linspace(-1,2,20);
[auc,pHit,pFa] = analyticROC(m2,m1,s,linspace(-1,2,1000));
for i = 1:length(criteria)
    clf;
    subplot(3,1,1); hold on;
    plotCritCDF(x,m1,m2,s,criteria(i),{'hit','fa'},[],lw)
    xlabel('x (Internal Response)'); ylabel('p(x)');
    title('ROC');
    set(gca,'FontSize',fsz);
    
    
    subplot(3,1,[2 3]); hold on;
    plot(pFa,pHit,'LineWidth',2,'Color',[.5 .5 .5]);
    plot([0 1],[0 1],'k--','LineWidth',lw)
    [~,ph,pf] = analyticROC(m2,m1,s,criteria(i));
    plot(pf,ph,'r.','MarkerSize',50);
    text(.5,.2,sprintf('auc = %3.2f',auc),'FontSize',fsz);
    xlabel('p(FA)'); ylabel('p(Hit)');
    set(gca,'FontSize',fsz);
    
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
    plotCritCDF(x,m1,ms(i),s,[],[],color(i,:),lw)
    xlabel('x (Internal Response)'); ylabel('p(x)');
    title('Shift in Mean');
    set(gca,'FontSize',fsz);
    
    subplot(3,1,[2 3]); hold on;
    plot([0 1],[0 1],'k--')
    [auc,ph,pf] = analyticROC(ms(i),m1,s,crits);
    plot(pf,ph,'Color',color(i,:),'LineWidth',lw);
    text(.5,.3-(.05*(i-1)),sprintf('auc = %3.2f',auc),...
        'color',color(i,:),'FontSize',fsz);
    xlabel('p(FA)'); ylabel('p(Hit)');
    set(gca,'FontSize',fsz);
    
    
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
    plotCritCDF(x,m1,m2,ns(i),[],[],color(i,:),lw)
    xlabel('x (Internal Response)'); ylabel('p(x)');
    title('Shift in Variance');
    set(gca,'FontSize',fsz);
    
    
    subplot(3,1,[2 3]); hold on;
    plot([0 1],[0 1],'k--')
    [auc,ph,pf] = analyticROC(m2,m1,ns(i),crits);
    plot(pf,ph,'Color',color(i,:),'LineWidth',lw);
    text(.5,.3-(.05*(i-1)),sprintf('auc = %3.2f',auc),...
        'color',color(i,:),'FontSize',fsz);
    xlabel('p(FA)'); ylabel('p(Hit)');
    set(gca,'FontSize',fsz);
    
    drawnow;
    pause;
end













%% d-prime
clf;
crits = linspace(-1,2,1000);
ms = linspace(0,1,5);
color = [ones(5,1) repmat(linspace(.75,0,5)',1,2)];
for i = 1:length(ms)
    subplot(3,1,1); hold on;
    plotCritCDF(x,m1,ms(i),s,[],[],color(i,:),lw)
    set(gca,'FontSize',24);
    xlabel('x (Internal Response)'); ylabel('p(x)');
    title('Shift in Mean');
    set(gca,'FontSize',fsz);
    
    
    subplot(3,1,[2 3]); hold on;
    plot([0 1],[0 1],'k--')
    [auc,ph,pf] = analyticROC(ms(i),m1,s,crits);
    dprime = (ms(i) - m1) / sqrt(.5*(s^2 + s^2));
    plot(pf,ph,'Color',color(i,:),'LineWidth',lw);
    text(.5,.3-(.05*(i-1)),sprintf('auc = %3.2f (d''=%3.2f)',auc,dprime),...
        'color',color(i,:),'FontSize',fsz);
    set(gca,'FontSize',24);
    xlabel('p(FA)'); ylabel('p(Hit)');
    set(gca,'FontSize',fsz);
    
    drawnow;
    pause;
end




%%
clf;
crits = linspace(-6,6,1000);
ns = [3 2.5 2 1 .3];
color = [repmat(linspace(.75,0,5)',1,2) ones(5,1) ];
for i = length(ns):-1:1
    subplot(3,1,1); hold on;
    plotCritCDF(x,m1,m2,ns(i),[],[],color(i,:),lw)
    set(gca,'FontSize',24);
    xlabel('x (Internal Response)'); ylabel('p(x)');
    title('Shift in Variance');
    set(gca,'FontSize',fsz);
    
    
    subplot(3,1,[2 3]); hold on;
    plot([0 1],[0 1],'k--')
    [auc,ph,pf] = analyticROC(m2,m1,ns(i),crits);
    dprime = (m2 - m1) / sqrt(.5*(ns(i)^2 + ns(i)^2));
    plot(pf,ph,'Color',color(i,:),'LineWidth',lw);
    text(.5,.3-(.05*(i-1)),sprintf('auc = %3.2f (d''=%3.2f)',auc,dprime),...
        'color',color(i,:),'FontSize',fsz);
    set(gca,'FontSize',24);
    xlabel('p(FA)'); ylabel('p(Hit)');
    set(gca,'FontSize',fsz);
    
    drawnow;
    pause;
end





