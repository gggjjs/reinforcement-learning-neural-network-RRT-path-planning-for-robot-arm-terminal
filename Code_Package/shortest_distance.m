function true_realdistance = shortest_distance(poin1, poin2, obstacl1)
     pqx = poin2(1,1) - poin1(1,1);
	 pqy = poin2(1,2) - poin1(1,2);
	 pqz = poin2(1,3) - poin1(1,3);
	 dx = obstacl1(1,1) - poin1(1,1);
	 dy = obstacl1(1,2) - poin1(1,2);
	 dz = obstacl1(1,3) - poin1(1,3);
	 d_1 = pqx*pqx + pqy*pqy + pqz*pqz;  % qp�߶γ��ȵ�ƽ��
	 t_2 = pqx*dx + pqy*dy + pqz*dz;   % p pt���� ��� pq ������p�൱��A�㣬q�൱��B�㣬pt�൱��P�㣩

		t_1 = t_2 / d_1;    %?��ʱt �൱�� �����Ƶ��е� r��
	if (t_1 < 0)
		t_1 = 0;  %?��t��r��< 0ʱ����̾��뼴Ϊ pt�� �� p�㣨A���P�㣩֮��ľ��롣
	else if (t_1 > 1)
		t_1 = 1; %  ��t��r��> 1ʱ����̾��뼴Ϊ pt�� �� q�㣨B���P�㣩֮��ľ��롣
        else
            t_1 = 2;
        end
    end
    
    if t_1 == 0
        true_realdistance = Distance(poin1,obstacl1);
    end
    if t_1 == 1
         true_realdistance = Distance(poin2,obstacl1);
    end
    if t_1 == 2
         true_realdistance = point_to_line(poin1,poin2,obstacl1);
    end

end

function realdistance = point_to_line(point1, point2, obstacle1)

vx1x2 = point2 - point1;%����x1��x2
vx1x3 = obstacle1 - point1;%����x1��x3[
% if  vx1x2'* vx1x2 == 0 %���x1��x2�غϣ�ע�⣬�Ը��������õ���0���жϲ��ɿ�
%     realdistance = 0;
% elseif vx1x3' * vx1x3 == 0%���x1��x3�غϣ���������¾����Ƿ�Ϊ0��Ҫ�Լ�����
%     realdistance = 0;
% else
     inner_product = dot(vx1x2, vx1x3);%���������ڻ�
     inner_product_2 = inner_product * inner_product;%�ڻ�ƽ��
     cos_2 = inner_product_2 / dot(vx1x2,vx1x2) / dot(vx1x3, vx1x3);%�н�cosֵ��ƽ��
     sin_2 = 1 - cos_2;  %�н�sin��ƽ��
     dis_2 = dot(vx1x3,vx1x3) * sin_2;
     realdistance = sqrt(dis_2); %����
end

function dist = Distance(X,Y)
     dist = sqrt(sum((X - Y).^2));
end