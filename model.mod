set Crops;

param day_count integer >=0;
set Days := 1..day_count;

param worker_count;
param plot_count;
param initial_money;

param planting_time{Crops} integer >=1;
param growth_time{Crops} integer >=1;
param harvest_time{Crops} integer >=1;
param purchase_price{Crops} integer >=0;
param selling_price{Crops} integer >=0;

var started_planting{Days, Crops} integer >=0;
var started_planting_in_past{Days, Crops} integer >=0;
var planting{Days, Crops} integer >=0;
var planted{Days, Crops} integer >=0;
var planted_in_past{Days, Crops} integer >=0;
var growing{Days, Crops} integer >=0;
var grown{Days, Crops} integer >=0;
var started_harvesting{Days, Crops} integer >=0;
var started_harvesting_in_past{Days, Crops} integer >=0;
var harvesting{Days, Crops} integer >=0;
var harvested{Days, Crops} integer >=0;

var available_plots{Days} integer >=0;
var available_workers{Days} integer >=0;
var available_money{Days} integer >=0;

s.t. Set_available_money{d in Days}: available_money[d] = initial_money - sum{d2 in Days, c in Crops: d2 < d} (started_planting[d2, c] * purchase_price[c] - harvested[d2, c] * selling_price[c]) + sum{c in Crops} (harvested[d, c] * selling_price[c]);

s.t. Set_available_workers{d in Days}: available_workers[d] = worker_count - sum{c in Crops} (planting[d, c] + harvesting[d, c]);

s.t. Set_available_plots{d in Days}: available_plots[d] = plot_count - sum{c in Crops} (planting[d, c] + planted[d, c] + growing[d, c] + grown[d, c] + harvesting[d, c]); 

s.t. Cant_harvest_more_than_grown{d in Days, c in Crops}: started_harvesting[d, c] <= sum{d2 in Days: d2 <= d} (grown[d2, c] - harvested[d2, c]);

s.t. Cant_spend_more_than_currently_available_money{d in Days}: sum{c in Crops} (started_planting[d, c] * purchase_price[c]) <= available_money[d];

s.t. Cant_plant_or_harvest_more_than_available_workers{d in Days}: sum{c in Crops} (started_planting[d, c] + started_harvesting[d, c]) <= available_workers[d];

s.t. Cant_plant_more_than_available_plots{d in Days}: sum{c in Crops} started_planting[d, c] <= available_plots[d];

s.t. Set_started_planting_in_past{d in Days, c in Crops}: started_planting_in_past[d, c] = sum{d2 in Days: d2 < d && d2 > (d - planting_time[c])} started_planting[d2, c];

s.t. Set_planted_in_past{d in Days, c in Crops}: planted_in_past[d, c] = sum{d2 in Days: d2 < d && d2 > (d - growth_time[c])} planted[d2, c];

s.t. Set_started_harvesting_in_past{d in Days, c in Crops}: started_harvesting_in_past[d, c] = sum{d2 in Days: d2 < d && d2 > (d - harvest_time[c])} started_harvesting[d2, c];

s.t. Set_growing{d in Days, c in Crops}: growing[d, c] >= planted_in_past[d, c];

s.t. Set_planting{d in Days, c in Crops}: planting[d, c] >= started_planting_in_past[d, c];

s.t. Set_harvesting{d in Days, c in Crops}: harvesting[d, c] >= started_harvesting_in_past[d, c];

s.t. Cant_plant_or_harvest_more_than_number_of_workers{d in Days}: sum{c in Crops} (planting[d, c] + harvesting[d, c]) <= worker_count;

s.t. Cant_plant_or_grow_or_harvest_more_than_number_of_plots{d in Days}: sum{c in Crops} (growing[d, c] + planting[d, c] + harvesting[d, c]) <= plot_count;

s.t. Set_planted{d in Days, c in Crops: d > planting_time[c]}: planted[d, c] <= started_planting[d - planting_time[c], c];

s.t. Set_planted_in_first_days{d in Days, c in Crops: d <= planting_time[c]}: planted[d, c] <= 0;

s.t. Set_grown{d in Days, c in Crops: d > growth_time[c] + planting_time[c]}: grown[d, c] <= planted[d - growth_time[c], c];

s.t. Set_grown_in_first_days{d in Days, c in Crops: d <= growth_time[c] + planting_time[c]}: grown[d, c] <= 0;

s.t. Set_Harvested{d in Days, c in Crops: d > growth_time[c] + planting_time[c] + harvest_time[c]}: harvested[d, c] <= started_harvesting[d - harvest_time[c], c];

s.t. Set_Harvested_in_first_days{d in Days, c in Crops: d <= growth_time[c] + planting_time[c] + harvest_time[c]}: harvested[d, c] <= 0;

maximize Profit: sum{d in Days, c in Crops} (harvested[d, c] * selling_price[c] - started_planting[d, c] * purchase_price[c]);
solve;

printf "\n\n==================================================\n";
printf "Starting money: %d\n", initial_money;
printf "Number of workers: %d\n", worker_count;
printf "Number of plots: %d\n", plot_count;
printf "--------------------------------------------------\n";

for{c in Crops: sum{d in Days} started_planting[d, c] > 0}
{
	printf "Purchased %d pcs of %s for %d value\n", sum{d in Days} started_planting[d, c], c, sum{d in Days} (started_planting[d, c] * purchase_price[c]);
}

for{c in Crops: sum{d in Days} grown[d, c] > 0}
{
	printf "Sold %d pcs of %s for %d value\n", sum{d in Days} harvested[d, c], c, sum{d in Days} (harvested[d, c] * selling_price[c]);
}

printf "--------------------------------------------------\n";
printf "Total profit: %d\n", Profit;

for{d in Days}
{
	printf "==================================================\n";
	printf "Day %d:\n\n", d;
	printf "Available money for purchase: %d\n", available_money[d];
	printf "Available workers: %d\n", available_workers[d];
	printf "Available plots: %d\n\n", available_plots[d];
	
	printf "Started planting %d pcs of crops for %d value\n", sum{c in Crops} started_planting[d, c], sum{c in Crops} started_planting[d, c] * purchase_price[c];
	printf "Sold %d pcs of crops for %d value\n", sum{c in Crops} harvested[d, c], sum{c in Crops} harvested[d, c] * selling_price[c];
	printf "Started harvesting %d pcs of crops\n", sum{c in Crops} started_harvesting[d, c];
	
	printf "--------------------------------------------------\n";
	printf "Purchased & started planting:\n\n";
	for{c in Crops: started_planting[d, c] > 0}
	{
		printf "%d pcs of %s for %d value\n", started_planting[d, c], c, started_planting[d, c] * purchase_price[c];
	}
	printf "--------------------------------------------------\n";
	printf "Finished planting:\n\n";
	for{c in Crops: planted[d, c] > 0}
	{
		printf "%d pcs of %s\n", planted[d, c], c;
	}
	printf "--------------------------------------------------\n";
	printf "Grown:\n\n";
	for{c in Crops: grown[d, c] > 0}
	{
		printf "%d pcs of %s\n", grown[d, c], c;
	}
	printf "--------------------------------------------------\n";
	printf "Started harvesting:\n\n";
	for{c in Crops: started_harvesting[d, c] > 0}
	{
		printf "%d pcs of %s\n", started_harvesting[d, c], c;
	}
	printf "--------------------------------------------------\n";
	printf "Harvested & sold:\n\n";
	for{c in Crops: harvested[d, c] > 0}
	{
		printf "%d pcs of %s for %d value\n", harvested[d, c], c, harvested[d, c] * selling_price[c];
	}
}
printf "==================================================\n\n";

end;
