function [HE, t_flag] = rouletteSelection (HeList, k, order) %HeList = Hyperedges with score, k= selection pressure
   HE = cell(1,order);
   max_weight = HeList{1,order+1};
   min_weight = HeList{size(HeList,1),order+1};
   if k < size(HeList,1) && max_weight ~= min_weight
      olist = []; % roulettet score
      xlist = []; % raw score
      for x=1:size(HeList, 1)
         xlist = [xlist; HeList{x,order+1}]; 
      end
      
      for x=1:size(xlist, 1)
         olist = [olist; abs((min_weight - xlist(x)) + (min_weight - max_weight) / (k-1))];
      end
      xSum = 0; % total roulettet score
      for x=1:size(olist, 1)
         xSum = xSum+olist(x); 
      end
      
      point = rand * xSum;
      sumf = 0;
      t = 0; % if t==1 then break;
      i = 1; % loop count
      while t==0
          sumf = sumf + olist(i);
          if point < sumf
              HE = HeList(i, 1:order);
              t_flag = HeList{i, order+2};
              %output{1,1} = HeList{i,1}; output{1,2} = HeList{i,2}; output{1,3} = HeList{i,3};               
              t = 1;
          end
          i = i + 1;
      end
      return;
   else
       index = ceil(rand * size(HeList, 1));
       HE = HeList(index, 1:order);
       t_flag = HeList{index, order+2};
   end
end