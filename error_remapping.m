%% Lossless compression

%%
disp("Start.");
for pred = 255:-5:0 %
  
  arr = single(zeros(256, 3));
  
  cnt = 1;
  for e=-pred:(255-pred)

    arr(cnt, 1) = e;
    arr(cnt, 2) = error2symbol(e, pred);
    arr(cnt, 3) = symbol2error(arr(cnt, 2), pred);

%     disp(strcat(num2str(e), ...
%                 " -> ", ...
%                 num2str(arr(cnt, 2), 3), ...
%                 " -> ", ...
%                 num2str(arr(cnt, 3), 3)));

    cnt = cnt+1;
  end

  if sum(arr(:,1)~=arr(:,3))
    disp(sum(arr(:,1)~=arr(:,3)));
  end
  
end

disp("End.");

% after mapping
% [S, I] = sort(abs(arr(:,1)), 'ascend');
% after_map = arr(I, 2);
% disp(after_map');

%%

%% Auxiliary
function symbol = error2symbol(e, pred)
  % e = orig - prediction
  % this makes the error falls into the interval 
  % [-pred, 2^b-1-pred]
  % assuming 8 bits images -> b=8
  b=8;
  t = min(pred, 2^b-1-pred);  
  
  if abs(e) <= t    
    symbol = bitshift(abs(e), 1) - uint8(e>0);    
  else  
    symbol = t + abs(e);    
  end
  
%   mask = abs(e)<=7
%   symbol = 

end

function error = symbol2error(symbol, pred)

  symbol = uint16(symbol);
%   pred = uint8(pred);

  % remap symbol to error
  b = 8;
  t = min(pred, 2^b-1-pred);
  
  
  if symbol<=2*t
    error = bitshift((symbol+1), -1);    
    error = single(error)  * ...
            (-1)^single(bitand(symbol+1,1)); 
  else
    error = symbol-t;
    error = single(error) * ...
            single((-1)^(bitshift(pred, -7)));
  end
  
  % negative on even indexes
  % positive on odd indexes

end




















