function [U,k] = process_ablation(X,Y,numanchor,lambda,gamma,alpha,ker)

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

iter = 0;
Isconverg = 0;
obj = 0;
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


     RE(iter+1) = max_C_J; 

    if iter > 200
        Isconverg = 1;
        fprintf('iter 200');
    end

    iter = iter + 1;


end

fprintf("--iter=%d--",iter);


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
