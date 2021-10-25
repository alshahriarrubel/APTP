function [ result] = PTP( img,left_eyebrow,right_eyebrow,lower_eye,upper_lip,Region_r, Region_c )

[r,c]=size(img);

result = [];
kmask = zeros( 3,3,8 );
kmask( :,:,1 ) = [ -3 -3 5 ; -3 0 5; -3 -3 5 ];
kmask( :,:,2 ) = [ -3 5 5 ; -3 0 5; -3 -3 -3 ];
kmask( :,:,3 ) = [ 5 5 5 ; -3 0 -3; -3 -3 -3 ];
kmask( :,:,4 ) = [ 5 5 -3 ; 5 0 -3; -3 -3 -3 ];
kmask( :,:,5 ) = [ 5 -3 -3 ; 5 0 -3; 5 -3 -3 ];
kmask( :,:,6 ) = [ -3 -3 -3 ; 5 0 -3; 5 5 -3 ];
kmask( :,:,7 ) = [ -3 -3 -3 ; -3 0 -3; 5 5 5 ];
kmask( :,:,8 ) = [ -3 -3 -3 ; -3 0 5; -3 5 5 ];

var2 = double(img);

dx = [ 0, -1, -1, -1, 0, 1, 1, 1 ];
dy = [ -1, -1, 0, 1, 1, 1, 0, -1 ];

%Matrix for storing the result of LDP
PTP_Code = zeros( r, c );
%For storing masked value for each mask
temp = zeros( 8,1 );
%Mask Position
mr = 2;
mc = 2;


ratio_r = r / Region_r;
ratio_c = c / Region_c;

%%
%% get the threshold sigma & average pixel value
sum_edge_response=0;
for ii=left_eyebrow:right_eyebrow
    for jj=lower_eye:upper_lip
       %Loop for selecting Kirsch Masks
        for k = 1:8
            sum = 0;
            %Loop for direction in each Mask
            for z = 1:8
                nr = ii + dx( z );
                nc = jj + dy( z ) ;
                if( nr >= 1 && nr <= r && nc >= 1 && nc <= c ) 
                    % nr and nc for image and mr and mc for mask
                    sum = sum + ( var2( nr,nc ) * kmask( mr + dx( z ) , mc + dy( z ) , k ) ) ;
                end
            end
            sum_edge_response = sum_edge_response+sum;
        end
        
    end
end
Avg_edge_local=round(sum_edge_response/((right_eyebrow-left_eyebrow+1)*(upper_lip-lower_eye+1)));

Threshold=Avg_edge_local;


%Loop for each window
for l = 1:Region_r
    %Local Window row start and end
    sr = ( ratio_r * ( l - 1 ) ) + 1;
    er = ratio_r * l ;
    for col = 1:Region_c
        %Local Window column start and end
        sc = ( ratio_c * ( col - 1 ) ) + 1;
        ec = ratio_c * col ;
        his = zeros( 1, 256 );
        %Loops for a single local window
        for i = sr:er
            for j = sc:ec
                %Loop for selecting Kirsch Masks
                for k = 1:8
                    sum = 0;
                    %Loop for direction in each Mask
                    for z = 1:8
                        nr = i + dx( z );
                        nc = j + dy( z ) ;
                        if( nr >= 1 && nr <= r && nc >= 1 && nc <= c ) 
                            % nr and nc for image and mr and mc for mask
                            sum = sum + ( var2( nr,nc ) * kmask( mr + dx( z ) , mc + dy( z ) , k ) ) ;
                        end

                    end
                    temp( k,1 ) = sum;                   
                end

                
                temp2=temp;
                [max1,max1_idx]=max(temp2);
                temp2(max1_idx)=-inf;
                [max2,max2_idx]=max(temp2);
                
                front_neighbour_of_Primary=max1_idx+1;
                back_neighbour_of_Primary=max1_idx-1;
                if(front_neighbour_of_Primary>8)
                    front_neighbour_of_Primary=1;
                end
                if(back_neighbour_of_Primary<1)
                    back_neighbour_of_Primary=8;
                end
                
                if(max2_idx==front_neighbour_of_Primary || max2_idx==back_neighbour_of_Primary)
                    temp2(front_neighbour_of_Primary)=-inf;
                    temp2(back_neighbour_of_Primary)=-inf;
                    [max2,max2_idx]=max(temp2);
                end
                
                if(max1>Threshold)
                    Ternary_pattern=2;
                elseif(max1<-Threshold)
                    Ternary_pattern=1;
                else
                    Ternary_pattern=0;
                end
                
                PTP_Code(i,j)=2^5*(max1_idx-1)+2^2*(max2_idx-1)+Ternary_pattern;
                his( 1, PTP_Code( i,j ) + 1 ) = his( 1, PTP_Code( i,j ) + 1 ) + 1;

            end
        end

        result = [result his];
    end
end




