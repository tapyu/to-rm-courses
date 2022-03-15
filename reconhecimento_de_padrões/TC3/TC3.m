clear; clc; close all;

X = load('./data/datasetTC3.dat');


[N, M] = size(X);
K = 3;
I = randperm(N,K); W = X(1:3,:);

Ne = 10;

for r=1:Ne
    
    for t=1:N
        for k=1:K
            Dist2(k) = norm(X(t,:) - W(k,:));
        end
        [Dmin(t), Icluster(t)] = min(Dist2); % indice do prototipo mais proximo
    end
    SSD(r) = sum(Dmin.^2);
    
    % Particiona os dados
    for k=1:K
        I = find(Icluster==k);
        Particao{k} = X(I,:);
        W(k,:) = mean(Particao{k});
    end
    
    % Calcula o SSD
    for t=1:N
        for k=1:K
            Dist2(k) = norm(X(t,:) - W(k,:));
        end
        [dummy, Icluster(t)] = min(Dist2); % indice do prototipo mais proximo
    end
    % 
    
end


plot(SSD)