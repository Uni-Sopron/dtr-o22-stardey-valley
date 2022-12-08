set Crops;

param day_count integer >=0;
set Days := 1..day_count;

param growth_time{Crops};
param purchase_price{Crops};
param selling_price{Crops};

var planted{Days, Crops} binary;
var planted_in_past{Days, Crops} integer >=0;
var growing{Days, Crops} binary;
var grown{Days, Crops} binary;

s.t. Cant_plant_something_if_growing{d in Days}: sum{c in Crops} planted[d, c] <= 1 - sum{c in Crops} growing[d, c];

s.t. Cant_plant_more_than_one_crop_at_a_time{d in Days}: sum{c in Crops} planted[d, c] <= 1;

s.t. Set_planted_in_past{d in Days, c in Crops}: planted_in_past[d, c] = sum{d2 in Days: d2 < d && d2 > (d - growth_time[c] - 1)} planted[d2, c];

s.t. Set_growing{d in Days, c in Crops}: growing[d, c] >= planted_in_past[d, c];

s.t. Cant_grow_more_than_one_crop_at_a_time{d in Days}: sum{c in Crops} growing[d, c] <= 1;

s.t. If_growing_cant_plant_another{d in Days, c in Crops}: planted[d, c] <= 1 - growing[d, c];

s.t. Set_grown{d in Days, c in Crops: d > growth_time[c] + 1}: grown[d, c] <= planted[d - growth_time[c] - 1, c];

s.t. Set_grown_in_first_days{d in Days, c in Crops: d <= growth_time[c] + 1}: grown[d, c] <= 0;

maximize Profit: sum{d in Days, c in Crops} (grown[d, c] * selling_price[c] - planted[d, c] * purchase_price[c]);
solve;

printf "\nProfit: %d\n", Profit;

for{d in Days}
{
	printf "\n\nDay %d:\n\n", d;
	
	for{c in Crops}
	{
		printf "\nPlanting %s: %d\n", c, planted[d, c];
		printf "Growing %s: %d\n", c, growing[d, c];
		printf "Grown %s: %d\n", c, grown[d, c];
	}
}
printf "\n";

end;