set Crops;

param day_count integer >=0;
set Days := 1..day_count;

set Workers;

param plot_count;

param growth_time{Crops};
param purchase_price{Crops};
param selling_price{Crops};

var planted{Days, Crops, Workers} integer >=0;
var planted_in_past{Days, Crops, Workers} integer >=0;
var growing{Days, Crops, Workers} integer >=0;
var grown{Days, Crops, Workers} integer >=0;

var available_plots{Days} integer >=0;

s.t. Set_available_plots{d in Days}: available_plots[d] = plot_count - sum{c in Crops, w in Workers} growing[d, c, w]; 

s.t. Cant_plant_more_than_available_plots{d in Days}: sum{c in Crops, w in Workers} planted[d, c, w] <= available_plots[d];

s.t. One_worker_can_only_plant_one_at_a_time{d in Days, w in Workers}: sum {c in Crops} planted[d, c, w] <= 1;

s.t. Set_planted_in_past{d in Days, c in Crops, w in Workers}: planted_in_past[d, c, w] = sum{d2 in Days: d2 < d && d2 > (d - growth_time[c])} planted[d2, c, w];

s.t. Set_growing{d in Days, c in Crops, w in Workers}: growing[d, c, w] >= planted_in_past[d, c, w];

s.t. Cant_grow_more_than_number_of_plots{d in Days}: sum{c in Crops, w in Workers} growing[d, c, w] <= plot_count;

s.t. Set_grown{d in Days, c in Crops, w in Workers: d > growth_time[c]}: grown[d, c, w] <= planted[d - growth_time[c], c, w];

s.t. Set_grown_in_first_days{d in Days, c in Crops, w in Workers: d <= growth_time[c]}: grown[d, c, w] <= 0;

maximize Profit: sum{d in Days, c in Crops, w in Workers} (grown[d, c, w] * selling_price[c] - planted[d, c, w] * purchase_price[c]);
solve;

printf "\nProfit: %d\n", Profit;

for{d in Days}
{
	printf "\n\nDay %d:\n\n", d;
	
	for{c in Crops}
	{
		printf "\nPlanted %s: %d\n", c, sum{w in Workers} planted[d, c, w];
		printf "Growing %s: %d\n", c, sum{w in Workers} growing[d, c, w];
		printf "Grown %s: %d\n", c, sum{w in Workers} grown[d, c, w];
	}
}
printf "\n";

end;
