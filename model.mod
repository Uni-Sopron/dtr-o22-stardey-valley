set Plants;
set Days integer >=0;

param initial_money integer >=0;

param purchase_price{Plants} integer >=0;
param selling_price{Plants} integer >=0;
param growth_time{Plants} integer >=0;

var purchased_plants{Days, Plants} integer >=0;
var money{Days} integer >=0;