function plotCritCDF(x,m1,m2,s,criterion,type,color)

if ~exist('type','var')
    type = [];
end

if ~exist('color','var')
    color = 'k';
end

if ~exist('criterion','var')
    criterion = [];
end

% make pdfs
pd1 = normpdf(x,m1,s);
pd2 = normpdf(x,m2,s);
npd1 = pd1 / sum(pd1);
npd2 = pd2 / sum(pd2);

hold on;

% plot the response areas
for i = 1:length(type)
    if contains(type{i},'hit')
        
% plot hit area
        xx = [criterion max(x) fliplr(x(x>criterion)) criterion criterion];
        yy = [0 0 fliplr(normpdf(x(x>criterion),m2,s)./ sum(pd1))  ...
              normpdf(criterion,m2,s)./sum(pd1) 0];
        patch(xx,yy,1,'FaceColor','g','FaceAlpha',.5);
        
    end
    
    if contains(type{i},'miss')
        
% plot miss area
        xx = [criterion min(x) x(x<criterion) criterion criterion];
        yy = [0 0 normpdf(x(x<criterion),m2,s)./ sum(pd1)  ...
              normpdf(criterion,m2,s)./sum(pd1) 0];
        patch(xx,yy,1,'FaceColor','r','FaceAlpha',.5);
        
    end
    
    if contains(type{i},'fa')
        
% plot false alarm area
        xx = [criterion max(x) fliplr(x(x>criterion)) criterion criterion];
        yy = [0 0 fliplr(normpdf(x(x>criterion),m1,s)./ sum(pd1))  ...
              normpdf(criterion,m1,s)./sum(pd1) 0];
        patch(xx,yy,1,'FaceColor','m','FaceAlpha',.5);
        
    end
    
    if contains(type{i},'cr')
        
% plot correct reject area
        xx = [criterion min(x) x(x<criterion) criterion criterion];
        yy = [0 0 normpdf(x(x<criterion),m1,s)./ sum(pd1)  ...
              normpdf(criterion,m1,s)./sum(pd1) 0];
        patch(xx,yy,1,'FaceColor','c','FaceAlpha',.5);
        
    end
end

% plot the density functions on top and the criterion
plot(x,npd1,'Color',[.5 .5 .5],'LineWidth',1);
plot(x,npd2,'Color',color,'LineWidth',1);
if exist('criterion','var') & ~isempty(criterion)
    plot([criterion criterion],ylim,'k--','LineWidth',1);
end

