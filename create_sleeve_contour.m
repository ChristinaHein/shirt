function pattern = create_sleeve_contour(human,pattern,correction_sleeve)
if nargin == 0
    error('Function create_sleeve needs a human and a pattern as input');
elseif nargin == 1
    error('Function create_sleeve needs a human and a pattern as input');
elseif nargin == 2
    correction_sleeve = 0;
elseif nargin == 3
    % delete existing sleeve from pattern
    pos = find(isnan(pattern.basic_pattern(:,1)));
    pattern.basic_pattern = pattern.basic_pattern(1:(pos(2)-1),:);
end

sleeve_length = pattern.construction_dimensions.sl; % sleeve length

pattern.construction_dimensions.ac = pattern.construction_dimensions.fac+pattern.construction_dimensions.bac; % armhole circumference
pattern.construction_dimensions.cm_ss = 0.5; %constant measurement sleeve shoulder
pattern.construction_dimensions.cm_sP1 = 1; %constant measurement shoulder shift P1

if strcmp(human.type,'female') % fit allowance for women
    if pattern.construction_dimensions.fit_allowance <0
        pattern.construction_dimensions.cm_sw = 0.5; %constant measurement seam wrist 
        pattern.construction_dimensions.cm_ua = 0.5; % constant measurement upper arm
    elseif pattern.construction_dimensions.fit_allowance <=1
        pattern.construction_dimensions.cm_sw = 1.5; %constant measurement seam wrist 
        pattern.construction_dimensions.cm_ua = 1; 
    elseif pattern.construction_dimensions.fit_allowance <= 3
        pattern.construction_dimensions.cm_sw = 1.5; %constant measurement seam wrist 
        pattern.construction_dimensions.cm_ua = 1.5; % constant measurement upper arm
    else
        pattern.construction_dimensions.cm_sw = pattern.construction_dimensions.fit_allowance/2 ; %constant measurement seam wrist 
        pattern.construction_dimensions.cm_ua = pattern.construction_dimensions.fit_allowance/2; % constant measurement upper arm
    end
elseif strcmp(human.type,'male') % fit allowance for men
    if pattern.construction_dimensions.fit_allowance <0
        pattern.construction_dimensions.cm_sw = 1.5; %constant measurement seam wrist 
        pattern.construction_dimensions.cm_ua = 0; % constant measurement upper arm
    elseif pattern.construction_dimensions.fit_allowance <=3
        pattern.construction_dimensions.cm_sw = 2; %constant measurement seam wrist 
        pattern.construction_dimensions.cm_ua = 3;% constant measurement upper arm
    else
        pattern.construction_dimensions.cm_sw = pattern.construction_dimensions.fit_allowance/2 ; %constant measurement seam wrist 
        pattern.construction_dimensions.cm_ua = pattern.construction_dimensions.fit_allowance/2; % constant measurement upper arm
    end
end

%% construction Points sleeve

pattern.construction_points.sA = [0 pattern.construction_dimensions.ac/3 + correction_sleeve];

pattern.construction_points.sB = pattern.construction_points.sA + [0 -human.arm_length];

pattern.construction_points.sC = [0 0];

x = sqrt((pattern.construction_dimensions.fac + pattern.construction_dimensions.cm_ss)^2 - (pattern.construction_dimensions.ac/3)^2);
y = pattern.construction_dimensions.ac/3 + correction_sleeve;
pattern.construction_points.sD = [x y];

x = pattern.construction_points.sD(1) + sqrt((pattern.construction_dimensions.bac + pattern.construction_dimensions.cm_ss)^2 - (pattern.construction_dimensions.ac/3)^2);
y = 0;
pattern.construction_points.sE = [x y];

pattern.construction_points.sF = [pattern.construction_points.sE(1)/2 0];

pattern.construction_points.sG = [pattern.construction_points.sF(1) pattern.construction_points.sB(2)];

pattern.construction_points.sH = [pattern.construction_points.sE(1) pattern.construction_points.sB(2)];


pattern.construction_points.sh = pattern.construction_points.sG + [(human.wrist_circumference+pattern.construction_dimensions.cm_sw)/2 0];
pattern.construction_points.sb = pattern.construction_points.sG + [-(human.wrist_circumference+pattern.construction_dimensions.cm_sw)/2 0];
pattern.construction_points.sa = [pattern.construction_points.sE(1) pattern.construction_points.sA(2)];

% correction of sb and sh for short sleeves
alpha = atan(pattern.construction_points.sb(1)/(abs(pattern.construction_points.sB(2))));
y = -(sleeve_length*human.arm_length - pattern.construction_points.sA(2));
x = pattern.construction_points.sE(1)+ y*tan(alpha);
pattern.construction_points.sh = [x,y];
x = -y*tan(alpha);
pattern.construction_points.sb =[x,y];
pattern.construction_points.sB = [0,y];
pattern.construction_points.sH = [pattern.construction_points.sH(1), y];

% shoulder curve construction points
x = (pattern.construction_dimensions.fac/2+pattern.construction_dimensions.cm_ss-pattern.construction_dimensions.cm_sP1)/(pattern.construction_dimensions.fac+pattern.construction_dimensions.cm_ss)*pattern.construction_points.sD(1);
y = pattern.construction_points.sD(2)/pattern.construction_points.sD(1)*x;
pattern.construction_points.P1 = [x y];

pattern.construction_points.P3 = pattern.construction_points.sE + 1/3*(pattern.construction_points.sD-pattern.construction_points.sE);

pattern.construction_points.P1a = create_P_between_P1P2_with_d(pattern.construction_points.sC, pattern.construction_points.P1, -0.8);
pattern.construction_points.P1b = create_P_between_P1P2_with_d(pattern.construction_points.P1, pattern.construction_points.sD, 1.5);
pattern.construction_points.P2 = create_P_between_P1P2_with_d(pattern.construction_points.sD, pattern.construction_points.P3, 1.5);
pattern.construction_points.P3a = create_P_between_P1P2_with_d(pattern.construction_points.P3, pattern.construction_points.sE, -0.7);

%% Basic Pattern sleeve

% shoulder
% Point List
PL = [pattern.construction_points.sC; pattern.construction_points.P1a; 
    pattern.construction_points.P1; pattern.construction_points.P1b];
PL = [PL; pattern.construction_points.sD]; 
PL = [PL; pattern.construction_points.P2; 
    pattern.construction_points.P3;
    pattern.construction_points.P3a; 
    pattern.construction_points.sE];

% Tangent List
TL = [0.5*pattern.construction_points.P1(1) 0];
TL = [TL; 2*(pattern.construction_points.sD-pattern.construction_points.sC)/norm(pattern.construction_points.sD-pattern.construction_points.sC)];
TL = [TL; 2*(pattern.construction_points.P1b-pattern.construction_points.P1a)/norm(pattern.construction_points.P1b-pattern.construction_points.P1a)];
TL = [TL; 2*TL(2,:)];
TL = [TL; 3*TL(1,:)];
TL = [TL; 5*(pattern.construction_points.sE-pattern.construction_points.sD)/norm(pattern.construction_points.sE-pattern.construction_points.sD)];
TL = [TL; 2*(pattern.construction_points.P3a-pattern.construction_points.P2)/norm(pattern.construction_points.P3a-pattern.construction_points.P2)];
TL = [TL; 0.5*TL(6,:)];
TL = [TL; -0.5*(pattern.construction_points.P3(1)-pattern.construction_points.sE(1)) 0];

%figure
%plot(PL(:,1), PL(:,2),'ro'); daspect([1 1 1]); hold on;
%plot(PL(:,1)+TL(:,1), PL(:,2)+TL(:,2),'b*'); 
PL = PLBezierPT(PL,TL,10);
%plot(PL(:,1), PL(:,2),'r-'); 


pattern.construction_dimensions.sac = PLCurveLength(PL); % sleeve armhole circumference

if sleeve_length*human.arm_length <= pattern.construction_points.sA(2)*2 % 
    PL = [PL; pattern.construction_points.sh; pattern.construction_points.sb; pattern.construction_points.sC];    
else
    % calculate circumference from upper arm
    d = 0.25/sleeve_length*abs(pattern.construction_points.sB(2))*tan(alpha);
    circumference_upper_arm = pattern.construction_points.sE(1)-2*d;
    delta = circumference_upper_arm-(human.circumference_upper_arm+pattern.construction_dimensions.cm_ua); % actual value and target value

    % sleeve seam right
    P = create_P_between_P1P2_with_d(pattern.construction_points.sE, pattern.construction_points.sh, -delta/2, 0.25/sleeve_length);
    PLt = [pattern.construction_points.sE; P; pattern.construction_points.sh];
    PLt = PLaddauxpoints(PLt,human.arm_length*0.05);
    PLt = VLBezierC(PLt);
    PL = [PL; PLt(:,1) PLt(:,2)];

    % sleeve seam left
    P = create_P_between_P1P2_with_d(pattern.construction_points.sb, pattern.construction_points.sC, -delta/2, 1-0.25/sleeve_length);
    PLt = [pattern.construction_points.sb; P; pattern.construction_points.sC];
    PLt = PLaddauxpoints(PLt,human.arm_length*0.05);
    PLt = VLBezierC(PLt);
    PL = [PL; PLt(:,1) PLt(:,2)];
end


%% write into PL basic pattern
pattern.basic_pattern = [pattern.basic_pattern; NaN, NaN; PL(:,1) PL(:,2); NaN NaN];
