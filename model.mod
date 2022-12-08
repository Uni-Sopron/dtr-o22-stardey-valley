set Crops;

param day_count integer >=0;
set Days := 1..day_count;

param worker_count;
param plot_count;

param planting_time{Crops};
param growth_time{Crops};
param purchase_price{Crops};
param selling_price{Crops};

var planted{Days, Crops} integer >=0;
var planted_in_past{Days, Crops} integer >=0;
var growing{Days, Crops} integer >=0;
var grown{Days, Crops} integer >=0;

var available_plots{Days} integer >=0;

s.t. Set_available_plots{d in Days}: available_plots[d] = plot_count - sum{c in Crops} growing[d, c]; 

s.t. Cant_plant_more_than_available_plots{d in Days}: sum{c in Crops} planted[d, c] <= available_plots[d];

s.t. One_worker_can_only_plant_one_at_a_time{d in Days}: sum {c in Crops} planted[d, c] <= worker_count;

s.t. Set_planted_in_past{d in Days, c in Crops}: planted_in_past[d, c] = sum{d2 in Days: d2 < d && d2 > (d - growth_time[c])} planted[d2, c];

s.t. Set_growing{d in Days, c in Crops}: growing[d, c] >= planted_in_past[d, c];

s.t. Cant_grow_more_than_number_of_plots{d in Days}: sum{c in Crops} growing[d, c] <= plot_count;

s.t. Set_grown{d in Days, c in Crops: d > growth_time[c]}: grown[d, c] <= planted[d - growth_time[c], c];

s.t. Set_grown_in_first_days{d in Days, c in Crops: d <= growth_time[c]}: grown[d, c] <= 0;

maximize Profit: sum{d in Days, c in Crops} (grown[d, c] * selling_price[c] - planted[d, c] * purchase_price[c]);
solve;

printf "\nProfit: %d\n", Profit;

for{d in Days}
{
	printf "\n\nDay %d:\n\n", d;
	
	for{c in Crops}
	{
		printf "\nPlanted %s: %d\n", c, planted[d, c];
		printf "Growing %s: %d\n", c, growing[d, c];
		printf "Grown %s: %d\n", c, grown[d, c];
	}
}
printf "\n";

end;
