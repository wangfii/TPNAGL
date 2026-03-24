function [U,k] = process(X,Y,numanchor,lambda,gamma,alpha,ker)

% X n*di


m = numanchor;   % anchor number
k = length(unique(Y)); % cluster number
nV = length(X);  % view number
n = size(Y,1);  % sample number

sX = [m,n,nV];

for v = 1 : nV
    C{v} = zeros(m,n);
    D{v} = zeros(m,n);
    A{v} = zeros(size(X{v},2),m);
    Q{v} = zeros(m,n);
    J{v} = zeros(m,n);
    X{v} = X{v}';   % di*n
end

% for v = 1:nV
%     k_XX{v} = kernel(X{v},X{v},ker{v});   %kk
% end

%%
eta = 0.001;
tau = 1;
epson = 1e-6;
pho_mu = 2;
max_mu = 10e10;
mu = 10e-5;



for v = 1:nV
    vA{v}=zeros(size(A{v}));
end

iter = 1;
Isconverg = 0;
obj = [];
while(Isconverg == 0)
    
    for v = 1:nV
        k_AA{v} = kernel(A{v},A{v},ker{v});  % m*m
        k_AX{v} = kernel(A{v},X{v},ker{v});  % m*n
    end
    
    %% update ============ J{v} ===========================================
    C_tensor = cat(3,C{:,:});
    Q_tensor = cat(3,Q{:,:});

    c = C_tensor(:);
    q = Q_tensor(:);

    % TNN
    [J_tensor,objV] = wshrinkObj(c+1/mu*q,alpha/mu,sX,0,3);
    
    for v = 1:nV
        J{v} = J_tensor(:,:,v);
    end
    j = J_tensor(:);

    %% update ============ C{v} ===========================================
    for v = 1:nV
        C{v} = pinv((1/2)*k_AA{v} + mu*eye(m))*(k_AX{v}+mu*J{v}-Q{v}-(1/2)*k_AA{v}*D{v});   % m*n
        C{v} = SimplexProj(C{v}');
        C{v} = C{v}';
       
    end

    %% update ============ D{v} ===========================================
    for v = 1:nV
        D{v} = pinv((1/2)*k_AA{v}+2*gamma*eye(m))*(k_AX{v}-(1/2)*k_AA{v}*C{v});
        D{v} = SimplexProj(D{v}');
        D{v} = D{v}';
    end

    %% update ============ A{v} ===========================================
    for v = 1:nV
        g_kAX{v} = -(C{v}+D{v})';
        g_kAA{v} = 0.25*(C{v}+D{v})*(C{v}+D{v})'+ 1*lambda*eye(m);
        [g_D1,T1,C1]=gXY(g_kAX{v},k_AX{v}',X{v},A{v},ker{v},'Y');
        [g_D2,T2,C2]=gXX(g_kAA{v},k_AA{v},A{v},ker{v});
        nabla{v} =  tau/ker{v}.par*(2*T2-diag(C1(1,:)-2*C2(1,:)));
        g_A{v} = (g_D1+g_D2)/nabla{v};
        vA{v} = g_A{v} + eta*vA{v};
        A{v} = A{v} - vA{v};
    end

 

    %% update ============ Q{v} ===========================================
    for v = 1:nV
        Q{v} = Q{v} + mu*(C{v}-J{v});
    end

    mu = min(mu*pho_mu, max_mu);

    
    % obj1 = 0;
    % obj2 = 0;
    % obj3 = 0;
    % for v = 1:nV
    %     obj1 = obj1 + trace(k_XX{v})-trace(k_AX{v}*(C{v}+D{v})')+trace((1/4)*k_AA{v}*(C{v}+D{v})*(C{v}+D{v})');
    %     obj1 = obj1 + trace(k_XX{v}-k_AX{v}'*(C{v}+D{v})+(1/4)*(C{v}+D{v})'*k_AA{v}*(C{v}+D{v}));
    %     obj2 = obj2 + trace(k_AA{v});
    %     obj3 = obj3 + trace(D{v}'*D{v});
    % end
    % 
    % obj(iter) = obj1 + lambda*obj2 + gamma*obj3 + alpha*objV;

    Isconverg = 1;
    max_C_J = 0;
    for v = 1:nV
        if (norm(C{v}-J{v},inf)>epson)
            history.norm_C_J = norm(C{v}-J{v},inf);
            % fprintf('    norm_C_J %7.10f \n', history.norm_C_J);
            max_C_J = max(max_C_J,history.norm_C_J);
            Isconverg = 0;
        end
    end


     constraint(iter) = max_C_J;

    if iter > 200
        Isconverg = 1;
        fprintf('iter 200');
    end

    iter = iter + 1;


end

fprintf("--iter=%d--",iter);


%% 收敛性曲线
% iterations = 1:length(obj);  % 迭代次数，假设 obj 和 constraint 的长度相同
% 
% % 对违反约束变量进行归一化，将其映射到 [0, 1] 范围内
% constraint_normalized = (constraint - min(constraint)) / (max(constraint) - min(constraint));
% 
% % 创建一个图形
% figure;
% 
% % 绘制目标函数的值
% yyaxis left
% plot(iterations, obj, '-o', 'DisplayName', 'Objective Value', 'LineWidth', 2);
% ylabel('Objective Function Value');
% xlabel('Iterations');
% set(gca, 'YColor', 'b');
% 
% % 创建右侧纵坐标来绘制违反约束变量的值
% yyaxis right
% plot(iterations, constraint_normalized, '-x', 'DisplayName', '$\|\mathcal{C}-\mathcal{J}\|_{\infty}$', 'LineWidth', 2);
% 
% % 设置 LaTeX 解释器用于图例
% legend('show', 'Interpreter', 'latex');
% ylabel('Constraint Violation Value');
% set(gca, 'YColor', 'r');
% 
% % 添加图例
% legend('show');
% grid on;








Sbar=[];
for v = 1:nV
    Sbar=cat(1,Sbar,1/sqrt(nV)*C{v});  % 35*210
end
[U,Sig,V] = mySVD(Sbar',k); 


end


%% function 
function [K,XY]=kernel(X,Y,ker)
nx=size(X,2);
ny=size(Y,2);
XY=X'*Y;    %kk
if strcmp(ker.type,'rbf')
    xx=sum(X.*X,1);
    yy=sum(Y.*Y,1);
    D1=repmat(xx',1,ny) + repmat(yy,nx,1) - 2*XY;
    K=exp(-D1/2/ker.par); 
end
if strcmp(ker.type,'poly')
    K=(XY+ker.par(1)).^ker.par(2);
end
end

%%
function [g,T,C]=gXY(g_Kxd,Kxd,X,D,ker,v)
switch v
    case 'Y'
        T=g_Kxd.*Kxd;   % n x d
        C=repmat(sum(T),size(X,1),1);
        g=1/ker.par*(X*T-D.*C);  
    case 'X'
        T=g_Kxd'.*Kxd';    % d x n;
        C=repmat(sum(T),size(X,1),1);
        g=1/ker.par*(D*T-X.*C);
end
end

%%
function [g,T,C]=gXX(g_Kdd,Kdd,D,ker,I)
if ~exist('I')
    T=g_Kdd.*Kdd;
    C=repmat(sum(T),size(D,1),1);
    g=2/ker.par*(D*T-D.*C);
else
    T=g_Kdd.*Kdd;
    C=repmat(sum(T),size(D,1),1);
    g=2/ker.par*(D.*repmat(diag(T)',size(D,1),1)-D.*C);
end
end 
