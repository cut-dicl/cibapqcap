function [BT BP]=Jump_places_overlapig(Ship_search_space_jump, iii,pTime, AT, ABQ, BQ, LoS, PBP, PBQ, BT, BP,lengthOfwharf)

if rem(length(Ship_search_space_jump),2)==0
           for i=1:length(Ship_search_space_jump)
            if rem(i,2)==0   % hr 2 ships overlap ho re hain...therefore, we will change bq of one ship
                %if any(ShipNo_BQChange(i)==PBQ_changed)==false % || PBQ_changed ==[] %==false % any(ShipNo_BQChange(1)~=PBQ_changed(1))==true %ShipNo_BQChange~=1......any(1)~=1==true
                %if any(ShipNo_BQChange(i-1)==PBQ_changed)==false    
                    % b=randi([1,2]);            %[minnn, Index]=min(LoS(ShipNo_BQChange(1)), LoS(ShipNo_BQChange(2)));
                    pp=[Ship_search_space_jump(i-1) Ship_search_space_jump(i)]; %% pp contains two overlaping ships and one of them needs to change its BQ
                    [min_pTime, b]=min(pTime(pp)); % finding max time and location
                    % new tamasha
                    s1=find(BQ==PBQ(pp(b))); % it contains ships having 
                    s2=find(AT(s1)>AT(pp(b))); % it finds ships having at after at of that ship that is going to change its bq
                    s3=find(AT(s1)<AT(pp(b)));
                    s4=find(AT(s1)+pTime(s1)>AT(pp(b)));
                    common1=intersect(s2,s3);
                    common2=intersect(s3,s4);
                    common3=union(common1,common2);
                    max_posb_plac=max(BP(s1(common3))+LoS(s1(common3)));
                    min_posb_plac=min(BP(s1(common3)));
                    if common3>0
                        if sum(lengthOfwharf(1:PBQ(pp(b))))-LoS(pp(b)) > max_posb_plac
                            BP(pp(b))=randi([max_posb_plac, sum(lengthOfwharf(1:PBQ(pp(b))))-LoS(pp(b))]);
                        elseif min_posb_plac >= sum(lengthOfwharf(1:PBQ(pp(b))-1))+LoS(pp(b))
                            BP(pp(b))=randi([sum(lengthOfwharf(1:PBQ(pp(b))-1)), min_posb_plac-LoS(pp(b))]);
                        end
                   end
                   %end       %end
            end
            %[x1]=mainplot(BT, BP, pTime, LoS, 3); % plot
           end
end