clear
close all


Data = ...
  [0	442.4949
10	432.8073
11	441.1179
12	447.849
14	265.5504
16	176.7501
18	170.9748
24	171.0072
30	171.2502
36	171.5418
40	171.3474];


dst = Data(:,1);
y = Data(:,2);
% axis([0 2 -0.5 6])
% hold on
plot(dst,y,'ko', 'MarkerSize', 12)
%title('Data points')

% F = @(x,xdata) ( (x(1)^x(2)) / (x(1)^x(2) + xdata^x(2)) );

% hill_fit = @(b,x)  ( (b(1).^b(2)) ./ ( b(1).^b(2) + x.^b(2)));

% hill_fit = @(b,x)  ( 3472.691419*(b(1).^b(2)) ./ ( b(1).^b(2) + x.^b(2)) + 151.1981315);

hill_fit = @(b,x)  ( b(3)*(b(1).^b(2)) ./ ( b(1).^b(2) + x.^b(2)) + b(4));

b0 = [1; 1; 400; 170];    % Initial Parameter Estimates

[B,resnorm,~,exitflag,output] = lsqcurvefit(hill_fit, b0, dst, y)


% [x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,dst,y)

dstVct = linspace(min(dst), max(dst));   % Plot Finer Resolution


hold on
% plot(dst,F(x,dst))
plot(dstVct, hill_fit(B, dstVct), '-r', 'LineWidth', 3)
% plot(dst, hill_fit(B, dst), '-r')
xlabel('[CTX] (\mug/ml)')
ylabel('Area covered (pixel)')
hold off
legend('Avg', 'Hill-fit')
set(gca, 'FontSize', 20)

yfit = hill_fit(B, dst);

SStot = sum((y-mean(y)).^2);                            % Total Sum-Of-Squares
SSres = sum((y(:)-yfit(:)).^2);                         % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot


OutPut = [dstVct', hill_fit(B, dstVct)']';

