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

s.t. Set_Harvested{d in Days, c in Crops: d > growth_time[c] + planting_time[c] + harvest_time[c]}: grown[d, c] <= harvested[d - harvest_time[c], c];

s.t. Set_Harvested_in_first_days{d in Days, c in Crops: d <= growth_time[c] + planting_time[c] + harvest_time[c]}: harvested[d, c] <= 0;

maximize Profit: sum{d in Days, c in Crops} (harvested[d, c] * selling_price[c] - started_planting[d, c] * purchase_price[c]);
solve;

printf "\n\n==================================================\n";
printf "Initial money: %d\n", initial_money;
printf "Total money at the end: %d\n", available_money[day_count];
printf "Profit: %d\n", Profit;
printf "--------------------------------------------------\n";

for{c in Crops: sum{d in Days} started_planting[d, c] > 0}
{
	printf "Purchased %d pcs of %s of %d value\n", sum{d in Days} started_planting[d, c], c, sum{d in Days} (started_planting[d, c] * purchase_price[c]);
}

for{c in Crops: sum{d in Days} grown[d, c] > 0}
{
	printf "Sold %d pcs of %s of %d value\n", sum{d in Days} harvested[d, c], c, sum{d in Days} (harvested[d, c] * selling_price[c]);
}

for{d in Days}
{
	printf "==================================================\n";
	printf "Day %d:\n\n", d;
	printf "Sold %d worth of crops\n", sum{c in Crops} harvested[d, c] * selling_price[c];
	printf "Available money for purchase: %d\n", available_money[d];
	printf "Purchased %d worth of crops\n", sum{c in Crops} started_planting[d, c] * purchase_price[c];
	for{c in Crops}
	{
		printf "--------------------------------------------------\n";
		printf "Purchased & started planting %s: %d\n", c, started_planting[d, c];
		printf "Planting %s: %d\n", c, planting[d, c];
		printf "Planted %s: %d\n", c, planted[d, c];
		printf "Growing %s: %d\n", c, growing[d, c];
		printf "Grown %s: %d\n", c, grown[d, c];
		printf "Started harvesting %s: %d\n", c, started_harvesting[d, c];
		printf "Harvesting %s: %d\n", c, harvesting[d, c];
		printf "Harvested & sold %s: %d\n", c, harvested[d, c];
	}
}
printf "==================================================\n\n";

end;
