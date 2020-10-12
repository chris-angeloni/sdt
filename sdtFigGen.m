addpath(genpath('~/chris-lab/code_general/'))



%% generate some figures for signal detection theory lecture

% parameters
m1 = 0;
m2 = 1;
s = .3;
x = [-2:.01:3];

% plot signal and noise distributions
plotCritCDF(x,m1,m2,s)
text(m1,max(ylim)*.95,'Noise','HorizontalAlignment','center')
text(m2,max(ylim)*.95,'Signal','HorizontalAlignment','center')

% plot distributions
clf; hold on
plot(x,npd1,'b','LineWidth',1)
plot(x,npd2,'r','LineWidth',1)
text(m1,max(npd1)+.001,'Noise','HorizontalAlignment','center')
text(m2,max(npd2)+.001,'Signal','HorizontalAlignment','center')

% plot a criterion
criterion = .5;
clf; hold on
plot(x,npd1,'b','LineWidth',1)
plot(x,npd2,'r','LineWidth',1)
plot([criterion criterion],ylim,'k--','LineWidth',1)
text(criterion+.1,max(ylim)*.95,'criterion')

% plot a criterion, with decision logic
criterion = .5;
clf; hold on
plot(x,npd1,'b','LineWidth',1)
plot(x,npd2,'r','LineWidth',1)
plot([criterion criterion],ylim,'k--','LineWidth',1)
text(criterion+.1,max(ylim)*.95,'\rightarrow SAY "SIGNAL"',...
     'horizontalalignment','left')
text(criterion-.1,max(ylim)*.95,'SAY "NOISE" \leftarrow ',...
     'horizontalalignment','right')

% hits vs miss
criterion = .5;
clf; hold on
xx = [criterion max(x) fliplr(x(x>criterion)) criterion criterion];
yy = [0 0 fliplr(normpdf(x(x>criterion),m2,s2)./ sum(pd1))  ...
      normpdf(criterion,m2,s2)./sum(pd1) 0];
patch(xx,yy,1,'FaceColor','r','FaceAlpha',.5)
xx = [criterion min(x) x(x<criterion) criterion criterion];
yy = [0 0 normpdf(x(x<criterion),m2,s2)./ sum(pd1)  ...
      normpdf(criterion,m2,s2)./sum(pd1) 0];
patch(xx,yy,1,'FaceColor','b','FaceAlpha',.5)
plot(x,npd1,'b','LineWidth',1)
plot(x,npd2,'r','LineWidth',3)
plot([criterion criterion],ylim,'k--','LineWidth',1)
text(m2,max(npd2)+.001,'Signal Present','HorizontalAlignment', ...
     'center')


% correct reject vs false alarm
criterion = .5;
clf; hold on
xx = [criterion max(x) fliplr(x(x>criterion)) criterion criterion];
yy = [0 0 fliplr(normpdf(x(x>criterion),m1,s1)./ sum(pd1))  ...
      normpdf(criterion,m1,s1)./sum(pd1) 0];
patch(xx,yy,1,'FaceColor','r','FaceAlpha',.5)
xx = [criterion min(x) x(x<criterion) criterion criterion];
yy = [0 0 normpdf(x(x<criterion),m1,s1)./ sum(pd1)  ...
      normpdf(criterion,m1,s1)./sum(pd1) 0];
patch(xx,yy,1,'FaceColor','b','FaceAlpha',.5)
plot(x,npd1,'b','LineWidth',3)
plot(x,npd2,'r','LineWidth',1)
plot([criterion criterion],ylim,'k--','LineWidth',1)
text(m1,max(npd1)+.001,'Signal Absent','HorizontalAlignment', ...
     'center')

% test analytic AUC function
[aucAnalytic] = analyticROC(m2,m1,s1,linspace(-2,3,1000))

[~,~,aucSample] = computeROC(normrnd(m1,s1,10000,1),normrnd(m2,s2,10000,1),linspace(-2,3,1000))




