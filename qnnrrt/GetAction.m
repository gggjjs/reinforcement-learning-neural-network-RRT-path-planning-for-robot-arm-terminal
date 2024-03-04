% 选择动作
function delta = GetAction( actionIndx, step )

    if actionIndx == 1 
        delta  = [step, 0, 0];
    
      elseif actionIndx == 2
        delta = [-step, 0, 0];
        
      elseif actionIndx == 3  
        delta = [0, step, 0];
         
      elseif actionIndx == 4
        delta = [0, -step, 0];
         
      elseif actionIndx == 5
        delta = [0, 0, step];
        
      elseif actionIndx == 6  
        delta = [0, 0, -step];

      end

end