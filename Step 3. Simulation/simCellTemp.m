% ik - current in amperes, where (+) is discharge. Size is N x 1.
% temp  - temperature (degC). Size is N x 1.
% deltaT = sampling interval of data in seconds. Size is 1 x 1 (a scalar)
% model - standard model structure
% z0 - initial SOC. Size is 1 x 1.
% iR0 - initial resistor currents as column vector. Size is Nr x 1 where Nr is 
%       number of R-C pairs in model.
% h0 - initial hysteresis state. Size is 1 x 1.
%
% vest - predicted cell voltage. Size is N x 1.
% rck - predicted resistor currents. Size is N x Nr (first row is set to iR0')
% hk - predicted dynamic hysteresis states. Size is N x 1 (first entry is h0)
% zk - predicted cell state of charge. Size is N x 1 (first entry is z0)
% sik - sign of input current. Size is N x 1.
% OCV - predicted cell open circuit voltage. Size is N x 1.
function [vest,rck,hk,zk,sik,OCV] = simCellTemp(ik,temp,deltaT,model,z0,iR0,h0)

  % Force data to be column vector(s)
  ik = ik(:); iR0 = iR0(:); temp = temp(:);
  N = length(ik); Nr = length(iR0);
  % initialize some outputs
  vest = zeros(N,1); rck = zeros(N,Nr); hk = zeros(N,1); zk = zeros(N,1); 
  sik = zeros(N,1); OCV = zeros(N,1);
  rck(1,:) = iR0'; hk(1) = h0; zk(1) = z0; sik(1) = 0;
  OCV(1) = OCVfromSOCtemp(z0,temp(1),model);

  
  T = temp(:);
  RCfact = exp(-deltaT./abs(getParamESC('RCParam',T,model)))';
  if length(RCfact) ~= Nr
    error('iR0 does not have the correct number of entries');
  end
  G = getParamESC('GParam',T,model);
  Q = getParamESC('QParam',T,model);
  M = getParamESC('MParam',T,model);
  M0 = getParamESC('M0Param',T,model);
  RParam = getParamESC('RParam',T,model);
  R0Param = getParamESC('R0Param',T,model);
  etaParam = getParamESC('etaParam',T,model);
  
  etaik = ik; etaik(ik<0) = etaParam*ik(ik<0);

  % Simulate the dynamic states of the model
  for k = 2:length(ik)
    rck(k,:) = rck(k-1,:)*diag(RCfact) + (1-RCfact')*etaik(k-1);
  end
  zk = z0-cumsum([0;etaik(1:end-1)])*deltaT/(Q*3600);
  if any(zk>1.1)
    warning('Current may have wrong sign as SOC > 110%');
  end
  
  % Hysteresis stuff
  fac=exp(-abs(G*etaik*deltaT/(3600*Q)));
  for k=2:length(ik)
    hk(k)=fac(k-1)*hk(k-1)+(fac(k-1)-1)*sign(ik(k-1));
    sik(k) = sign(ik(k));
    if abs(ik(k))<Q/100, sik(k) = sik(k-1); end
  end
    
  % Compute output equation
  OCV = OCVfromSOCtemp(zk,T,model);  
  vest = OCV - rck*RParam' - R0Param*ik + M*hk + M0*sik;
end
